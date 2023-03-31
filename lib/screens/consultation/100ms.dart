import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:record/record.dart';

import 'package:intouch_imagine_cup/constants.dart';
import 'package:intouch_imagine_cup/database/schemas/consultation_period.dart';
import 'package:intouch_imagine_cup/database/schemas/consultation_request.dart';
import 'package:intouch_imagine_cup/screens/consultation/new_mood_analysis.dart';
import 'package:intouch_imagine_cup/screens/consultation/main_screen.dart';
import 'package:intouch_imagine_cup/screens/first_aider/consultation_request.dart';
import 'package:intouch_imagine_cup/classes/room_data.dart';
import 'package:intouch_imagine_cup/classes/current_user.dart';
import 'package:intouch_imagine_cup/components/report_dialog.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage({super.key});

  static const String id = '100ms';

  @override
  State<MeetingPage> createState() => MeetingPageState();
}

class MeetingPageState extends State<MeetingPage> implements HMSUpdateListener {
  late String userType;
  //SDK
  late HMSSDK hmsSDK;
  // audio recording
  late Record record;
  // Variables required for generating access token
  late String roomId;
  // Variables required for joining a room
  late String authToken;
  String userName = FirebaseAuth.instance.currentUser!.uid;
  // Variables required for rendering video and peer info
  HMSPeer? localPeer, remotePeer;
  HMSVideoTrack? localPeerVideoTrack, remotePeerVideoTrack;
  // Variables on mic and video status
  bool micEnabled = true;
  late bool camEnabled;
  // Variable for mood analysis report
  List<String> imageList = [];
  // Variables to track how long first aider is in the consultation
  late DateTime startTime;
  late DateTime endTime;
  late int differenceInMinutes;

  // Initialize variables and join room
  @override
  void initState() {
    super.initState();
    camEnabled = Provider.of<RoomData>(context, listen: false).camEnabled;
    userType =
        Provider.of<CurrentUser>(context, listen: false).currentUser!.userType;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      generateAuthToken();
    });
  }

  void startRecording() async {
    record = Record();
    await record.start(
      path: '/storage/emulated/0/download/$roomId.mp4',
      encoder: AudioEncoder.aacLc, // by default
      bitRate: 128000, // by default
      samplingRate: 44100, // by default
    );
  }

  void generateAuthToken() async {
    final http.Response httpResponse = await http.post(
        Uri.parse(
          "https://prod-in2.100ms.live/hmsapi/jia-videoconf-1034.app.100ms.live/api/token",
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'room_id': roomId,
          'role': 'guest',
          'user_id': FirebaseAuth.instance.currentUser!.uid
        }));

    authToken = jsonDecode(httpResponse.body)['token'];
    print('User auth token : $authToken');
    initHMSSDK();
  }

  void initHMSSDK() async {
    if (camEnabled) {
      hmsSDK = HMSSDK();
    } else {
      HMSTrackSetting trackSettings = HMSTrackSetting(
          // This is for joining with muted video(camera off)
          audioTrackSetting: HMSAudioTrackSetting(
              trackInitialState: HMSTrackInitState.UNMUTED),
          videoTrackSetting:
              HMSVideoTrackSetting(trackInitialState: HMSTrackInitState.MUTED));
      hmsSDK = HMSSDK(hmsTrackSetting: trackSettings);
    }

    await hmsSDK.build(); // ensure to await while invoking the `build` method
    hmsSDK.addUpdateListener(listener: this);
    hmsSDK.join(config: HMSConfig(authToken: authToken, userName: userName));
  }

  // Clear all variables
  @override
  void dispose() {
    remotePeer = null;
    remotePeerVideoTrack = null;
    localPeer = null;
    localPeerVideoTrack = null;
    super.dispose();
  }

  // Called when there's a track update - use to update local & remote track variables
  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
      switch (trackUpdate) {
        case HMSTrackUpdate.trackRemoved:
          if (mounted) {
            setState(() {
              peer.isLocal
                  ? localPeerVideoTrack = null
                  : remotePeerVideoTrack = null;
            });
          }
          return;
        default:
          if (mounted) {
            setState(() {
              peer.isLocal
                  ? localPeerVideoTrack = track as HMSVideoTrack
                  : remotePeerVideoTrack = track as HMSVideoTrack;
            });
          }
      }
    }
  }

  // More callbacks - no need to implement for quickstart
  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {}

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {}

  @override
  void onHMSError({required HMSException error}) {}

  @override
  void onMessage({required HMSMessage message}) {}

  @override
  void onReconnected() {}

  @override
  void onReconnecting() {}

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {}

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {}

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {}

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {}

  // Called when peer joined the room - get current state of room by using HMSRoom obj
  @override
  void onJoin({required HMSRoom room}) {
    print('Successful joined a room');
    room.peers?.forEach((peer) {
      if (peer.isLocal) {
        localPeer = peer;
        if (peer.videoTrack != null) {
          localPeerVideoTrack = peer.videoTrack;
          if (userType == 'User') {
            print(
                'Current user is target user so turned on recording & image capture');
            Future.delayed(Duration(seconds: 2), captureImage);
          }
        }
        if (mounted) {
          setState(() {});
        }
      }
    });

    if (userType == 'First Aider') {
      startTime = DateTime.now();
    } else {
      //startRecording();
      // hmsSDK.startRtmpOrRecording(hmsRecordingConfig: HMSRecordingConfig(meetingUrl: , toRecord: true))
    }
  }

  void getSessionId() async {
    HMSRoom? room = await hmsSDK.getRoom();
    String sessionId = room!.sessionId;
  }

  void captureImage() async {
    if (localPeerVideoTrack != null) {
      Uint8List? bytes = await localPeerVideoTrack!.captureSnapshot();

      if (bytes != null) {
        String base64string = base64.encode(bytes);
        imageList.add(base64string);
        print('Image captured $imageList');
      }

      Future.delayed(Duration(seconds: 5), captureImage);
    } else {
      print('fail capturing image');
    }
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        if (!peer.isLocal) {
          if (mounted) {
            setState(() {
              remotePeer = peer;
            });
          }
        }
        break;
      case HMSPeerUpdate.peerLeft:
        leaveRoom();
        if (!peer.isLocal) {
          if (mounted) {
            setState(() {
              remotePeer = null;
            });
          }
        }
        break;
      case HMSPeerUpdate.networkQualityUpdated:
        return;
      default:
        if (mounted) {
          setState(() {
            localPeer = null;
          });
        }
    }
  }

  Future<void> leaveRoom() async {
    try {
      if (userType == 'User') {
        // await record.stop();
        const platform =
            MethodChannel('com.example.intouch_imagine_cup/100ms_token');
        String managementAccessToken =
            await platform.invokeMethod('generateAccessToken');

        print('Management access token : $managementAccessToken');

        final http.Response httpResponse = await http.post(
            Uri.parse(
              "https://api.100ms.live/v2/rooms/$roomId",
            ),
            headers: {
              'Content-Type': 'application/json',
              'header': 'Bearer $managementAccessToken',
            },
            body: jsonEncode({'enabled': false}));

        print(
            'Successfully disable the room : ${jsonDecode(httpResponse.body)}');

        String consultationStatus = await updateConsultReqStatus();

        /* If consultation status is End, go to mood analysis page */
        /* Else, go back to consultation main page */
        hmsSDK.removeUpdateListener(listener: this);
        if (consultationStatus == 'End' && imageList.length > 0) {
          hmsSDK.leave();
          Navigator.pushNamedAndRemoveUntil(
              context, NewMoodAnalysis.id, (Route<dynamic> route) => false,
              arguments: {'imageList': imageList});
        } else {
          hmsSDK.leave();
          Navigator.pushNamedAndRemoveUntil(
              context, ConsultationScreen.id, (Route<dynamic> route) => false);
        }
      } else {
        endTime = DateTime.now();
        differenceInMinutes = endTime.difference(startTime).inMinutes;
        await insertConsultationPeriod();

        hmsSDK.removeUpdateListener(listener: this);
        hmsSDK.leave();
        Navigator.pushNamedAndRemoveUntil(context, ConsultationRequestScreen.id,
            (Route<dynamic> route) => false);
      }
    } catch (e) {
      print(e);
    }
  }

  /* Find the current consultation request */
  Future<ConsultationRequest> currentConsultationRequest() async {
    final db = FirebaseFirestore.instance;
    final query = db
        .collection("consultation_request")
        .where("roomId", isEqualTo: roomId)
        .withConverter(
          fromFirestore: ConsultationRequest.fromFirestore,
          toFirestore: (ConsultationRequest consultationRequest, _) =>
              consultationRequest.toFirestore(),
        );

    final docSnap = await query.get();
    final consultationRequest = docSnap.docs.first;

    return consultationRequest.data();
  }

  /* Insert consultation period into database */
  Future<void> insertConsultationPeriod() async {
    ConsultationRequest consultationRequest =
        await currentConsultationRequest();
    String targetUserId = consultationRequest.target_user;

    final db = FirebaseFirestore.instance;

    ConsultationPeriod consultationPeriod = ConsultationPeriod(
        first_aider: FirebaseAuth.instance.currentUser!.uid,
        target_user: targetUserId,
        period: differenceInMinutes);

    final docRef = db
        .collection('consultation_period')
        .withConverter(
          fromFirestore: ConsultationPeriod.fromFirestore,
          toFirestore: (ConsultationPeriod consultationPeriod, options) =>
              consultationPeriod.toFirestore(),
        )
        .doc(consultationPeriod.id);

    await docRef.set(consultationPeriod);
  }

  /* To find out which first aider is in this session */
  Future<String> queryConsultationRequest() async {
    final db = FirebaseFirestore.instance;

    ConsultationRequest consultationRequest =
        await currentConsultationRequest();

    if (consultationRequest.status == 'Accepted') {
      return consultationRequest.first_aider;
    }

    return '';
  }

  /* Status change to End if initial status is Accepted */
  /* Status change to Cancelled if initial status is Pending */
  Future<String> updateConsultReqStatus() async {
    final db = FirebaseFirestore.instance;

    /* Find the current consultation request */
    final query = db
        .collection("consultation_request")
        .where("roomId", isEqualTo: roomId)
        .withConverter(
          fromFirestore: ConsultationRequest.fromFirestore,
          toFirestore: (ConsultationRequest consultationRequest, _) =>
              consultationRequest.toFirestore(),
        );

    final docSnap = await query.get();
    final consultationRequest = docSnap.docs.first;

    if (consultationRequest.data().status == 'Accepted') {
      /* Update the status of consultation request to End */
      print('Current status is accepted');
      final update = db
          .collection("consultation_request")
          .doc(consultationRequest.id)
          .update({'status': 'End'}).then(
              (value) => print("DocumentSnapshot successfully updated!"),
              onError: (e) => print("Error updating document $e"));
      return 'End';
    } else {
      /* Update the status of consultation request to Cancelled */
      print('Current status is pending');
      final update = db
          .collection("consultation_request")
          .doc(consultationRequest.id)
          .update({'status': 'Cancelled'}).then(
              (value) => print("DocumentSnapshot successfully updated!"),
              onError: (e) => print("Error updating document $e"));
      return 'Cancelled';
    }
  }

  // Widget to render grid of peer tiles and a end button
  @override
  Widget build(BuildContext context) {
    roomId = Provider.of<RoomData>(context, listen: false).roomID;
    return WillPopScope(
      // Used to call "leave room" upon clicking back button [in android]
      onWillPop: () async {
        leaveRoom();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // Grid of peer tiles
              Container(
                height: MediaQuery.of(context).size.height,
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: (remotePeer == null)
                          ? MediaQuery.of(context).size.height
                          : MediaQuery.of(context).size.height / 2,
                      crossAxisCount: 1),
                  children: [
                    if (remotePeer != null)
                      peerTile(
                          Key(remotePeerVideoTrack?.trackId ?? "" "mainVideo"),
                          remotePeerVideoTrack,
                          remotePeer),
                    peerTile(
                        Key(localPeerVideoTrack?.trackId ?? "" "mainVideo"),
                        localPeerVideoTrack,
                        localPeer)
                  ],
                ),
              ),
              // Header
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          roomId.substring(0, 10),
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w700,
                              fontSize: 30.0,
                              color: kOrangeColor),
                        ),
                        Provider.of<CurrentUser>(context)
                                    .currentUser!
                                    .userType ==
                                'User'
                            ? GestureDetector(
                                onTap: () async {
                                  String firstAiderID =
                                      await queryConsultationRequest();
                                  if (firstAiderID != '') {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ReportDialog(
                                            firstAiderID: firstAiderID,
                                          );
                                        });
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                                'First aider has not joined the session!'),
                                            content: Text(
                                                'You are only allowed to report first aider after the session started.'),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('OK'),
                                                style: kOrangeButtonStyle,
                                              )
                                            ],
                                          );
                                        });
                                  }
                                },
                                child: Icon(
                                  Icons.flag,
                                  color: Colors.red,
                                  size: 30.0,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: MeetingControls(
                      onToggleMicButtonPressed: () {
                        hmsSDK.toggleMicMuteState();
                        setState(() {
                          micEnabled = !micEnabled;
                        });
                      },
                      onToggleCameraButtonPressed: () {
                        hmsSDK.toggleCameraMuteState();
                        setState(() {
                          camEnabled = !camEnabled;
                        });
                        if (camEnabled && userType == 'User') {
                          Future.delayed(Duration(seconds: 5), captureImage);
                        }
                      },
                      onLeaveButtonPressed: () {
                        leaveRoom();
                      },
                      micOn: micEnabled,
                      camOn: camEnabled,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MeetingControls extends StatelessWidget {
  final void Function() onToggleMicButtonPressed;
  final void Function() onToggleCameraButtonPressed;
  final void Function() onLeaveButtonPressed;

  final bool micOn;
  final bool camOn;

  const MeetingControls(
      {Key? key,
      required this.onToggleMicButtonPressed,
      required this.onToggleCameraButtonPressed,
      required this.onLeaveButtonPressed,
      required this.camOn,
      required this.micOn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: onToggleCameraButtonPressed,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kLightOrangeColor,
            ),
            padding: EdgeInsets.all(10.0),
            child: !camOn
                ? Icon(
                    Icons.videocam_off_outlined,
                    color: kOrangeColor,
                    size: 50.0,
                  )
                : Icon(
                    Icons.videocam_outlined,
                    color: kOrangeColor,
                    size: 50.0,
                  ),
          ),
        ),
        GestureDetector(
          onTap: onLeaveButtonPressed,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            padding: EdgeInsets.all(10.0),
            child: Icon(
              Icons.call_end_outlined,
              color: Colors.white,
              size: 50.0,
            ),
          ),
        ),
        GestureDetector(
          onTap: onToggleMicButtonPressed,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kLightOrangeColor,
            ),
            padding: EdgeInsets.all(10.0),
            child: Icon(
              !micOn ? Icons.mic_off_outlined : Icons.mic_none_outlined,
              color: kOrangeColor,
              size: 50.0,
            ),
          ),
        ),
      ],
    );
  }
}

// Widget to render a single video tile
Widget peerTile(Key key, HMSVideoTrack? videoTrack, HMSPeer? peer) {
  return Container(
    key: key,
    child: (videoTrack != null && !(videoTrack.isMute))
        // Actual widget to render video
        ? HMSVideoView(
            track: videoTrack,
          )
        : Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(4),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.blue,
                    blurRadius: 20.0,
                    spreadRadius: 5.0,
                  ),
                ],
              ),
              child: Text(
                peer?.name.substring(0, 1) ?? "D",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
  );
}

import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:intouch_imagine_cup/classes/current_user.dart';
import 'package:intouch_imagine_cup/classes/room_data.dart';
import 'package:intouch_imagine_cup/database/schemas/consultation_request.dart';
// import 'package:videosdk/videosdk.dart';
import 'package:provider/provider.dart';
import 'main_screen.dart';
import 'package:intouch_imagine_cup/screens/first_aider/consultation_request.dart';
import 'package:intouch_imagine_cup/components/report_dialog.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MeetingScreen extends StatefulWidget {
  static const String id = 'meeting_screen';

  const MeetingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  Map<String, Stream?> participantVideoStreams = {};

  // bool micEnabled = true;
  // late bool camEnabled;
  // late Room room;
  // late RoomData roomData;
  // late String name;
  // late String roomId;
  // bool roomLeft = false;
  //
  // void setParticipantStreamEvents(Participant participant) {
  //   participant.on(Events.streamEnabled, (Stream stream) {
  //     if (stream.kind == 'video') {
  //       setState(() => participantVideoStreams[participant.id] = stream);
  //     }
  //   });
  //
  //   participant.on(Events.streamDisabled, (Stream stream) {
  //     if (stream.kind == 'video') {
  //       setState(() => participantVideoStreams.remove(participant.id));
  //     }
  //   });
  // }
  //
  // void setMeetingEventListener(Room _room) {
  //   setParticipantStreamEvents(_room.localParticipant);
  //   _room.on(
  //     Events.participantJoined,
  //     (Participant participant) {
  //       setParticipantStreamEvents(participant);
  //     },
  //   );
  //   _room.on(Events.roomLeft, () async {
  //     if (roomLeft == false) {
  //       print('leave room function called');
  //       roomLeft = true;
  //       participantVideoStreams.values.forEach((streams) async {
  //         streams!.renderer!.dispose();
  //       });
  //       participantVideoStreams.clear();
  //
  //       if (Provider.of<CurrentUser>(context, listen: false)
  //               .currentUser!
  //               .userType ==
  //           'User') {
  //         String consultationStatus = await updateConsultReqStatus();
  //
  //         /* If consultation status is End, go to mood analysis page */
  //         /* Else, go back to consultation main page */
  //         if (consultationStatus == 'End') {
  //           Navigator.pushNamedAndRemoveUntil(
  //               context, MoodAnalysis.id, (Route<dynamic> route) => false);
  //         } else {
  //           Navigator.pushNamedAndRemoveUntil(context, ConsultationScreen.id,
  //               (Route<dynamic> route) => false);
  //         }
  //       } else {
  //         Navigator.pushNamedAndRemoveUntil(context,
  //             ConsultationRequestScreen.id, (Route<dynamic> route) => false);
  //       }
  //     }
  //   });
  // }
  //
  // /* Status change to End if initial status is Accepted */
  // /* Status change to Cancelled if initial status is Pending */
  // Future<String> updateConsultReqStatus() async {
  //   final db = FirebaseFirestore.instance;
  //
  //   /* Find the current consultation request */
  //   final query = db
  //       .collection("consultation_request")
  //       .where("roomId", isEqualTo: roomId)
  //       .withConverter(
  //         fromFirestore: ConsultationRequest.fromFirestore,
  //         toFirestore: (ConsultationRequest consultationRequest, _) =>
  //             consultationRequest.toFirestore(),
  //       );
  //
  //   final docSnap = await query.get();
  //   final consultationRequest = docSnap.docs.first;
  //
  //   if (consultationRequest.data().status == 'Accepted') {
  //     /* Update the status of consultation request to End */
  //     print('Current status is accepted');
  //     final update = db
  //         .collection("consultation_request")
  //         .doc(consultationRequest.id)
  //         .update({'status': 'End'}).then(
  //             (value) => print("DocumentSnapshot successfully updated!"),
  //             onError: (e) => print("Error updating document $e"));
  //     return 'End';
  //   } else {
  //     /* Update the status of consultation request to Cancelled */
  //     print('Current status is pending');
  //     final update = db
  //         .collection("consultation_request")
  //         .doc(consultationRequest.id)
  //         .update({'status': 'Cancelled'}).then(
  //             (value) => print("DocumentSnapshot successfully updated!"),
  //             onError: (e) => print("Error updating document $e"));
  //     return 'Cancelled';
  //   }
  // }
  //
  // Future<void> createRoom() async {
  //   roomData = Provider.of<RoomData>(context, listen: false);
  //   roomId = roomData.roomID;
  //   final accessToken =
  //       Provider.of<CurrentUser>(context).currentUser!.userType == 'User'
  //           ? kTagetUserAccessToken
  //           : kFirstAiderAccessToken;
  //   name = roomData.name;
  //   camEnabled = roomData.camEnabled;
  //
  //   // Create instance of Room (Meeting)
  //   room = VideoSDK.createRoom(
  //     roomId: roomId,
  //     token: accessToken,
  //     displayName: name,
  //     micEnabled: true,
  //     camEnabled: camEnabled,
  //     maxResolution: 'hd',
  //     defaultCameraIndex: 1,
  //     notification: const NotificationInfo(
  //       title: "Video SDK",
  //       message: "Video SDK is sharing screen in the meeting",
  //       icon: "notification_share", // drawable icon name
  //     ),
  //   );
  //
  //   setMeetingEventListener(room);
  //
  //   // Join meeting
  //   room.join();
  // }
  //
  // Future<void> startRecording() async {
  //   print('Start recording function called');
  //   try {
  //     final http.Response httpResponse = await http.post(
  //         Uri.parse("https://api.videosdk.live/v2/recordings/start"),
  //         headers: {'Authorization': kTagetUserAccessToken},
  //         body: {'roomId': roomId});
  //
  //     print(json.decode(httpResponse.body));
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  //
  // /* To find out which first aider is in this session */
  // Future<String> queryConsultationRequest() async {
  //   final db = FirebaseFirestore.instance;
  //
  //   /* Find the current consultation request */
  //   final query = db
  //       .collection("consultation_request")
  //       .where("roomId", isEqualTo: roomId)
  //       .withConverter(
  //         fromFirestore: ConsultationRequest.fromFirestore,
  //         toFirestore: (ConsultationRequest consultationRequest, _) =>
  //             consultationRequest.toFirestore(),
  //       );
  //
  //   final docSnap = await query.get();
  //   final consultationRequest = docSnap.docs.first;
  //
  //   if (consultationRequest.data().status == 'Accepted') {
  //     return consultationRequest.data().first_aider;
  //   }
  //
  //   return '';
  // }
  //
  // @override
  // void didChangeDependencies() async {
  //   super.didChangeDependencies();
  //   await createRoom();
  //
  //   Future.delayed(const Duration(seconds: 40), () {
  //     room.startRecording(config: {
  //       'layout': {
  //         'type': 'GRID',
  //         'priority': 'SPEAKER',
  //         'gridSize': 2,
  //       },
  //       'theme': "LIGHT",
  //       "mode": "video-and-audio",
  //       'quality': 'high'
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        // decoration: BoxDecoration(
        //   color: Color(0xFFF9F9F9),
        // ),
        // child: Stack(children: [
        //   Column(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       ...participantVideoStreams.values
        //           .map(
        //             (e) => ParticipantTile(
        //               stream: e!,
        //             ),
        //           )
        //           .toList(),
        //     ],
        //   ),
        //   Column(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.only(top: 40.0),
        //         child: Row(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           children: [
        //             Text(
        //               roomId,
        //               style: TextStyle(
        //                   decoration: TextDecoration.none,
        //                   fontWeight: FontWeight.w700,
        //                   fontSize: 30.0,
        //                   color: Colors.black),
        //             ),
        //             Provider.of<CurrentUser>(context).currentUser!.userType ==
        //                     'User'
        //                 ? GestureDetector(
        //                     onTap: () async {
        //                       String firstAiderID =
        //                           await queryConsultationRequest();
        //                       if (firstAiderID != '') {
        //                         showDialog(
        //                             context: context,
        //                             builder: (context) {
        //                               return ReportDialog(
        //                                 firstAiderID: firstAiderID,
        //                               );
        //                             });
        //                       } else {
        //                         showDialog(
        //                             context: context,
        //                             builder: (context) {
        //                               return AlertDialog(
        //                                 title: Text(
        //                                     'First aider has not joined the session!'),
        //                                 content: Text(
        //                                     'You are only allowed to report first aider after the session started.'),
        //                                 actions: [
        //                                   ElevatedButton(
        //                                     onPressed: () =>
        //                                         Navigator.pop(context),
        //                                     child: Text('OK'),
        //                                     style: kOrangeButtonStyle,
        //                                   )
        //                                 ],
        //                               );
        //                             });
        //                       }
        //                     },
        //                     child: Icon(
        //                       Icons.flag,
        //                       color: Colors.red,
        //                       size: 30.0,
        //                     ),
        //                   )
        //                 : Container(),
        //           ],
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(bottom: 40.0),
        //         child: MeetingControls(
        //           onToggleMicButtonPressed: () {
        //             micEnabled ? room.muteMic() : room.unmuteMic();
        //
        //             setState(() {
        //               micEnabled = !micEnabled;
        //             });
        //           },
        //           onToggleCameraButtonPressed: () {
        //             camEnabled ? room.disableCam() : room.enableCam();
        //
        //             setState(() {
        //               camEnabled = !camEnabled;
        //             });
        //           },
        //           onLeaveButtonPressed: () {
        //             room.stopRecording();
        //             room.end();
        //           },
        //           onStartRecordingButtonPressed: () {
        //             room.startRecording(config: {
        //               'layout': {
        //                 'type': 'GRID',
        //                 'priority': 'SPEAKER',
        //                 'gridSize': 4,
        //               },
        //               'theme': "LIGHT",
        //               "mode": "video-and-audio",
        //               'quality': 'high'
        //             });
        //           },
        //           onStopRecordingButtonPressed: () => room.stopRecording(),
        //           micOn: micEnabled,
        //           camOn: camEnabled,
        //         ),
        //       ),
        //     ],
        //   ),
        // ]),
        );
  }
}

// class MeetingControls extends StatelessWidget {
//   final void Function() onToggleMicButtonPressed;
//   final void Function() onToggleCameraButtonPressed;
//   final void Function() onLeaveButtonPressed;
//   final void Function() onStartRecordingButtonPressed;
//   final void Function() onStopRecordingButtonPressed;
//
//   final bool micOn;
//   final bool camOn;
//
//   const MeetingControls(
//       {Key? key,
//       required this.onToggleMicButtonPressed,
//       required this.onToggleCameraButtonPressed,
//       required this.onLeaveButtonPressed,
//       required this.onStartRecordingButtonPressed,
//       required this.onStopRecordingButtonPressed,
//       required this.camOn,
//       required this.micOn})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         GestureDetector(
//           onTap: onToggleCameraButtonPressed,
//           child: Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: kLightOrangeColor,
//             ),
//             padding: EdgeInsets.all(10.0),
//             child: Icon(
//               !camOn ? Icons.videocam_off_outlined : Icons.videocam_outlined,
//               color: kOrangeColor,
//               size: 50.0,
//             ),
//           ),
//         ),
//         GestureDetector(
//           onTap: onLeaveButtonPressed,
//           child: Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.red,
//             ),
//             padding: EdgeInsets.all(10.0),
//             child: Icon(
//               Icons.call_end_outlined,
//               color: Colors.white,
//               size: 50.0,
//             ),
//           ),
//         ),
//         GestureDetector(
//           onTap: onToggleMicButtonPressed,
//           child: Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: kLightOrangeColor,
//             ),
//             padding: EdgeInsets.all(10.0),
//             child: Icon(
//               !micOn ? Icons.mic_off_outlined : Icons.mic_none_outlined,
//               color: kOrangeColor,
//               size: 50.0,
//             ),
//           ),
//         ),
//
//         // ElevatedButton(
//         //   child: const Text("Start Recording"),
//         //   onPressed: onStartRecordingButtonPressed,
//         // ),
//         // ElevatedButton(
//         //   child: const Text("Stop Recording"),
//         //   onPressed: onStopRecordingButtonPressed,
//         // )
//       ],
//     );
//   }
// }
//
// class ParticipantTile extends StatelessWidget {
//   final Stream stream;
//   const ParticipantTile({
//     Key? key,
//     required this.stream,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(
//           height: 300.0,
//           width: double.infinity,
//           child: RTCVideoView(
//             stream.renderer!,
//             objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//             mirror: true,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/classes/room_data.dart';
import 'package:intouch_imagine_cup/database/schemas/user.dart';
import 'package:intouch_imagine_cup/screens/consultation/100ms.dart';
import 'package:provider/provider.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:intouch_imagine_cup/classes/consultation_data.dart';

import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/bottom_navbar.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intouch_imagine_cup/classes/current_user.dart';
import 'meeting_screen.dart';

import 'package:intouch_imagine_cup/database/schemas/consultation_request.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ConsultationOptionScreen extends StatefulWidget {
  const ConsultationOptionScreen({Key? key}) : super(key: key);

  static const String id = 'consultation_option';

  @override
  State<ConsultationOptionScreen> createState() =>
      _ConsultationOptionScreenState();
}

class _ConsultationOptionScreenState extends State<ConsultationOptionScreen> {
  Future<String?> generateManagementAccessToken() async {
    try {
      const platform =
          MethodChannel('com.example.intouch_imagine_cup/100ms_token');
      String managementAccessToken =
          await platform.invokeMethod('generateAccessToken');

      return managementAccessToken;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<String?> createNewRoom() async {
    try {
      String roomName = 'demo_id_${DateTime.now().millisecondsSinceEpoch}';

      String? managementAccessToken = await generateManagementAccessToken();

      final http.Response httpResponse =
          await http.post(Uri.parse('https://api.100ms.live/v2/rooms'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $managementAccessToken'
              },
              body: jsonEncode({
                'name': roomName,
              }));

      print(jsonDecode(httpResponse.body));
      String roomId = jsonDecode(httpResponse.body)['id'];
      print('Room Id : $roomId');

      return roomId;
    } catch (e) {
      print(e);
    }
  }

  Future<String> insertConsultationRequest(String roomId) async {
    final db = FirebaseFirestore.instance;

    ConsultationRequest consultationRequest;
    ConsultationData consultationData =
        Provider.of<ConsultationData>(context, listen: false);
    UserData currentUser =
        Provider.of<CurrentUser>(context, listen: false).currentUser!;
    if (consultationData.selectedPlatform == 'Video') {
      consultationRequest = ConsultationRequest(
        roomId: roomId,
        status: 'Pending',
        all_fa: consultationData.all_fa,
        is_video: true,
        first_aider: consultationData.firstAider,
        target_user: currentUser.id,
      );
    } else {
      consultationRequest = ConsultationRequest(
          roomId: roomId,
          status: 'Pending',
          all_fa: consultationData.all_fa,
          is_video: false,
          first_aider: consultationData.firstAider,
          target_user: currentUser.id);
    }

    final docRef = db
        .collection("consultation_request")
        .withConverter(
          fromFirestore: ConsultationRequest.fromFirestore,
          toFirestore: (ConsultationRequest consultationRequest, options) =>
              consultationRequest.toFirestore(),
        )
        .doc(consultationRequest.id);

    await docRef.set(consultationRequest);
    return consultationRequest.id;
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ConsultationData>(context, listen: false)
        .removeSelectedPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WhiteAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 44.0),
            child: Text(
              'Choose Options',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Provider.of<ConsultationData>(context, listen: false)
                  .selectPlatform('Video');
            },
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border:
                      Provider.of<ConsultationData>(context).selectedPlatform ==
                              'Video'
                          ? Border.all(color: kOrangeColor, width: 3.0)
                          : null,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 1,
                        spreadRadius: 1,
                        offset: Offset(0, 3.0))
                  ]),
              padding: EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 75.0, top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kLightOrangeColor,
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.videocam_outlined,
                        color: kOrangeColor,
                        size: 50.0,
                      ),
                    ),
                    SizedBox(
                      width: 35.0,
                    ),
                    Text(
                      'Video',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40.0,
            width: double.infinity,
          ),
          GestureDetector(
            onTap: () {
              Provider.of<ConsultationData>(context, listen: false)
                  .selectPlatform('Voice');
            },
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border:
                      Provider.of<ConsultationData>(context).selectedPlatform ==
                              'Voice'
                          ? Border.all(color: kOrangeColor, width: 3.0)
                          : null,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 1,
                        spreadRadius: 1,
                        offset: Offset(0, 3.0))
                  ]),
              padding: EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 75.0, top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kLightOrangeColor,
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.mic_none_outlined,
                        color: kOrangeColor,
                        size: 50.0,
                      ),
                    ),
                    SizedBox(
                      width: 35.0,
                    ),
                    Text(
                      'Voice',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 70.0,
          ),
          ElevatedButton(
            style: kOrangeButtonStyle,
            onPressed: () async {
              if (Provider.of<ConsultationData>(context, listen: false)
                      .selectedPlatform ==
                  '') {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Please choose a consultation platform'),
                        // ignore: prefer_const_constructors
                        content: Text(
                            'You can select your preferred consultation platform by clicking on the box.'),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            // ignore: prefer_const_constructors
                            child: Text(
                              'Close',
                            ),
                            style: kOrangeButtonStyle,
                          )
                        ],
                      );
                    });
              } else {
                final roomID = await createNewRoom();
                if (roomID != null) {
                  String consultationRequestId =
                      await insertConsultationRequest(roomID);
                  if (Provider.of<ConsultationData>(context, listen: false)
                          .selectedPlatform ==
                      'Voice') {
                    Provider.of<RoomData>(context, listen: false)
                        .updateRoomData(
                            id: roomID,
                            cam: false,
                            userName: 'Target User',
                            requestId: consultationRequestId);
                    Navigator.pushNamed(context, MeetingPage.id);
                  } else {
                    Provider.of<RoomData>(context, listen: false)
                        .updateRoomData(
                            id: roomID,
                            cam: true,
                            userName: 'Target User',
                            requestId: consultationRequestId);
                    Navigator.pushNamed(context, MeetingPage.id);
                  }
                }
              }
            },
            child: Text(
              'Start Your Session',
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavbar(selectedIndex: 1),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/firstaider-bottom_navbar.dart';
import 'package:intouch_imagine_cup/components/consultation_request_container.dart';

import 'package:intouch_imagine_cup/database/schemas/consultation_request.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intouch_imagine_cup/database/schemas/user.dart';
import 'package:intouch_imagine_cup/classes/consultation_request.dart';

class ConsultationRequestScreen extends StatefulWidget {
  const ConsultationRequestScreen({Key? key}) : super(key: key);

  static const String id = 'consultation_request';

  @override
  State<ConsultationRequestScreen> createState() =>
      _ConsultationRequestScreenState();
}

class _ConsultationRequestScreenState extends State<ConsultationRequestScreen> {
  List<Consultation> pendingNormalRequest = [];
  List<Consultation> pendingSpecialRequest = [];

  Future<void> getAllPendingRequest() async {
    final db = FirebaseFirestore.instance;

    /* Query the normal consultation request */
    final queryNormal = db
        .collection("consultation_request")
        .where("status", isEqualTo: "Pending")
        .where("all_fa", isEqualTo: true)
        .withConverter(
          fromFirestore: ConsultationRequest.fromFirestore,
          toFirestore: (ConsultationRequest consultationRequest, _) =>
              consultationRequest.toFirestore(),
        );

    final docSnapNormal = await queryNormal.get();
    final normalConsultationRequests = docSnapNormal.docs;
    for (var t in normalConsultationRequests) {
      final queryUser = db
          .collection("users")
          .doc(t.data().target_user)
          .withConverter(
            fromFirestore: UserData.fromFirestore,
            toFirestore: (UserData userdata, options) => userdata.toFirestore(),
          );

      final docSnapUser = await queryUser.get();
      setState(() {
        pendingNormalRequest.add(Consultation(
            targetUserName: docSnapUser.data()!.email,
            roomId: t.data().roomId,
            is_video: t.data().is_video));
      });
    }

    /* Query special consultation request */
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final querySpecial = db
        .collection("consultation_request")
        .where("status", isEqualTo: "Pending")
        .where("all_fa", isEqualTo: false)
        .where("first_aider", isEqualTo: currentUserId)
        .withConverter(
          fromFirestore: ConsultationRequest.fromFirestore,
          toFirestore: (ConsultationRequest consultationRequest, _) =>
              consultationRequest.toFirestore(),
        );

    final docSnapSpecial = await querySpecial.get();
    final specialConsultationRequest = docSnapSpecial.docs;
    for (var t in specialConsultationRequest) {
      final queryUser = db
          .collection("users")
          .doc(t.data().target_user)
          .withConverter(
            fromFirestore: UserData.fromFirestore,
            toFirestore: (UserData userdata, options) => userdata.toFirestore(),
          );

      final docSnapUser = await queryUser.get();
      setState(() {
        pendingSpecialRequest.add(Consultation(
            targetUserName: docSnapUser.data()!.email,
            roomId: t.data().roomId,
            is_video: t.data().is_video));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllPendingRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WhiteAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 44.0,
                ),
                Text(
                  'Consultation Request',
                  style: kTitleTextStyle,
                ),
                SizedBox(
                  height: 35.0,
                ),
                Text(
                  'Special Request',
                  style: kInputHeaderTextStyle,
                ),
                pendingSpecialRequest.length == 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          'No special request to you currently.',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container(
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            Consultation request = pendingSpecialRequest[index];

                            return ConsultationRequestContainer(
                              imageUrl: 'images/profile_picture.jpg',
                              name: request.targetUserName,
                              roomID: request.roomId,
                              cam: request.is_video,
                            );
                          },
                          itemCount: pendingSpecialRequest.length,
                        ),
                      ),
                SizedBox(
                  height: 40.0,
                ),
                Text(
                  'Other Request',
                  style: kInputHeaderTextStyle,
                ),
                pendingNormalRequest.length == 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          'No other request currently.',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container(
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            Consultation request = pendingNormalRequest[index];
                            return ConsultationRequestContainer(
                              imageUrl: 'images/profile_picture.jpg',
                              name: request.targetUserName,
                              roomID: request.roomId,
                              cam: request.is_video,
                            );
                          },
                          itemCount: pendingNormalRequest.length,
                        ),
                      ),
                SizedBox(
                  height: 44.0,
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavbar(selectedIndex: 2));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:intouch_imagine_cup/screens/consultation/100ms.dart';
import 'package:intouch_imagine_cup/screens/consultation/meeting_screen.dart';
import 'package:intouch_imagine_cup/classes/room_data.dart';

import 'package:intouch_imagine_cup/database/schemas/consultation_request.dart';
import 'package:provider/provider.dart';

class ConsultationRequestContainer extends StatelessWidget {
  ConsultationRequestContainer(
      {Key? key,
      required this.imageUrl,
      required this.name,
      required this.roomID,
      required this.cam})
      : super(key: key);

  final String imageUrl;
  final String name;
  final String roomID;
  final bool cam;

  Future<String?> updateStatus() async {
    final db = FirebaseFirestore.instance;
    /* Query the latest consultation request */
    final query = db
        .collection("consultation_request")
        .where("roomId", isEqualTo: roomID)
        .withConverter(
          fromFirestore: ConsultationRequest.fromFirestore,
          toFirestore: (ConsultationRequest consultationRequest, _) =>
              consultationRequest.toFirestore(),
        );

    final docSnap = await query.get();
    final consultationRequest = docSnap.docs.first;

    /* Update the status of consultation request to Accepted */
    final update = db
        .collection("consultation_request")
        .doc(consultationRequest.id)
        .update({
      'status': 'Accepted',
      'first_aider': FirebaseAuth.instance.currentUser!.uid
    }).then((value) => print("DocumentSnapshot successfully updated!"),
            onError: (e) => print("Error updating document $e"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: Offset(0, 3.0))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 17.0,
                  foregroundImage: AssetImage(imageUrl),
                ),
                SizedBox(
                  width: 10.0,
                ),
                SizedBox(
                  width: 120.0,
                  child: Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: kOrangeSmallButtonStyle,
              onPressed: () async {
                await updateStatus();
                if (roomID != null) {
                  Provider.of<RoomData>(context, listen: false).updateRoomData(
                      id: roomID, cam: cam, userName: 'First Aider');

                  Navigator.pushNamed(context, MeetingPage.id);
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Something went wrong'),
                          content: Text('Please try again later'),
                          actions: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Close'),
                              style: kOrangeButtonStyle,
                            )
                          ],
                        );
                      });
                }
              },
              child: Text('Consult'),
            )
          ],
        ),
      ),
    );
  }
}

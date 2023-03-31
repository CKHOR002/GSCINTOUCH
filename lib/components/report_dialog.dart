import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/constants.dart';

import 'package:intouch_imagine_cup/components/first_aider_option.dart';

import 'package:intouch_imagine_cup/database/schemas/report.dart';
import 'package:intouch_imagine_cup/database/schemas/user.dart';

class ReportDialog extends StatefulWidget {
  ReportDialog({required this.firstAiderID, Key? key}) : super(key: key);

  final firstAiderID;

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final reasonTextController = TextEditingController();

  String firstAiderName = '';

  final db = FirebaseFirestore.instance;

  Future<void> submitReport() async {
    ReportData report = ReportData(
        reason: reasonTextController.text,
        firstAider: widget.firstAiderID,
        targetUser: FirebaseAuth.instance.currentUser!.uid);

    final docRef = db
        .collection('report')
        .withConverter(
          fromFirestore: ReportData.fromFirestore,
          toFirestore: (ReportData reportData, options) =>
              reportData.toFirestore(),
        )
        .doc(report.id);

    await docRef.set(report);
  }

  Future<void> getFirstAiderName() async {
    final query = db
        .collection("users")
        .where("id", isEqualTo: widget.firstAiderID)
        .withConverter(
            fromFirestore: UserData.fromFirestore,
            toFirestore: (UserData userdata, _) => userdata.toFirestore());

    final docSnap = await query.get();
    final user = docSnap.docs.first;

    setState(() {
      firstAiderName = user.data().email;
    });
  }

  @override
  void initState() {
    super.initState();
    getFirstAiderName();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.0),
      backgroundColor: kLightOrangeColor,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 17.0,
        vertical: 20.0,
      ),
      children: [
        Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                size: 30.0,
                color: kOrangeColor,
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
        Text(
          'Report First Aider',
          textAlign: TextAlign.center,
          style: kTitleTextStyle,
        ),
        SizedBox(
          height: 15.0,
        ),
        FirstAiderOption(
          name: firstAiderName,
          imageUrl: 'images/profile_picture.jpg',
          isSelected: false,
        ),
        SizedBox(
          height: 25.0,
        ),
        Row(
          children: [
            Text(
              'Reason ',
              style: kInputHeaderTextStyle,
            ),
            Text(
              '(optional) ',
              style: kInputSmallHeaderTextStyle,
            ),
            Text(
              ':',
              style: kInputHeaderTextStyle,
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        TextField(
          controller: reasonTextController,
          maxLines: 10,
          decoration: InputDecoration(
            hintText: 'Reason',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: kInputBorder,
            contentPadding: EdgeInsets.all(20.0),
            focusedBorder: kInputBorder,
          ),
        ),
        SizedBox(
          height: 50.0,
        ),
        ElevatedButton(
          style: kOrangeButtonStyle,
          onPressed: () {
            submitReport();
            Navigator.pop(context);
          },
          child: Text(
            'Report',
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
    );
  }
}

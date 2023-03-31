// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/bottom_navbar.dart';
import 'package:intouch_imagine_cup/screens/rewards/rewards_mainpage.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RedeemPage extends StatefulWidget {
  const RedeemPage(
      {super.key, required this.documentid, required this.imageurl});
  static const String id = 'RedeemPage';
  final String documentid;
  final String imageurl;
  @override
  State<RedeemPage> createState() => _RedeemPageState();
}

class _RedeemPageState extends State<RedeemPage> {
  String qrData = "https://shop.starbucks.com.sg/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WhiteAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 40.0,
            ),
            child: Center(
              child: Text(
                'Redeem Voucher',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25.0,
          ),
          Image.network(
            widget.imageurl,
            width: 200,
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            'Scan the QR code below to redeem:',
            style: kInputHeaderTextStyle,
          ),
          SizedBox(
            height: 15.0,
          ),
          QrImage(
            data: qrData,
            size: 220.0,
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            'QWERTY',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: kOrangeColor,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
            child: const Text('Done'),
            onPressed: () {
              final db = FirebaseFirestore.instance;
              // Get a new write batch
              final batch = db.batch();
              final ref =
                  db.collection("voucher_redeemption").doc(widget.documentid);

              batch.update(ref, {"redeemed": true});
              batch.commit().then((_) {
                Navigator.pop(context);
                Navigator.popAndPushNamed(context, RewardsMainPage.id);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kOrangeColor, // Background color
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavbar(selectedIndex: 3),
    );
  }
}

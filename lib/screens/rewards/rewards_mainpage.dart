// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/bottom_navbar.dart';
import 'package:intouch_imagine_cup/screens/rewards/redeempage.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../database/schemas/redemption.dart';

class RewardsMainPage extends StatefulWidget {
  const RewardsMainPage({Key? key}) : super(key: key);
  static const String id = 'RewardsMainPage';
  @override
  State<RewardsMainPage> createState() => _RewardsMainPageState();
}

class _RewardsMainPageState extends State<RewardsMainPage>
    with TickerProviderStateMixin {
  int _point = 0;
  @override
  void initState() {
    super.initState();
    // Replace 'points' with the name of your Firestore collection
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        setState(() {
          _point = docSnapshot.data()!['point'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WhiteAppBar(),
      body: ScaffoldWidget(point: _point),
      bottomNavigationBar: BottomNavbar(selectedIndex: 3),
    );
  }
}

class ScaffoldWidget extends StatelessWidget {
  const ScaffoldWidget({
    Key? key,
    required int point,
  })  : _point = point,
        super(key: key);

  final int _point;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(
              top: 40.0,
            ),
            child: Text(
              'My Wallet',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 35.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            'Keep going!',
            style: kInputHeaderTextStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19.0),
          child: Row(
            children: [
              LinearPercentIndicator(
                width: MediaQuery.of(context).size.width - 100,
                animation: true,
                lineHeight: 20.0,
                animationDuration: 1500,
                percent: _point / 500,
                // ignore: deprecated_member_use
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: kOrangeColor,
                backgroundColor: kLightOrangeColor,
                barRadius: const Radius.circular(16),
              ),
              CircularPercentIndicator(
                radius: 25.0,
                lineWidth: 12.0,
                percent: _point / 500,
                center: Text("500"),
                progressColor: kOrangeColor,
                backgroundColor: kLightOrangeColor,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, bottom: 30.0),
          child: Row(
            children: [
              Text(
                'Accumulated:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                '$_point points',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFE8235),
                ),
              ),
            ],
          ),
        ),
        TabSection(
          point: _point,
        ),
      ],
    );
  }
}

class TabSection extends StatelessWidget {
  const TabSection({super.key, required this.point});
  final int point;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TabBar(
            tabs: [
              Tab(text: "Available"),
              Tab(text: "Earned"),
              Tab(text: "Used/Expired"),
            ],
            labelColor: kOrangeColor,
            unselectedLabelColor: Colors.black,
            indicatorColor: kOrangeColor,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: TabBarView(
              children: [
                TabViewContainer(
                  tabbar: 'available',
                  point: point,
                ),
                TabViewContainer(
                  tabbar: 'earned',
                  point: point,
                ),
                TabViewContainer(
                  tabbar: 'used/expired',
                  point: point,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TabViewContainer extends StatefulWidget {
  const TabViewContainer(
      {super.key, required this.tabbar, required this.point});
  final String tabbar;
  final int point;

  @override
  State<TabViewContainer> createState() => _TabViewContainerState();
}

class _TabViewContainerState extends State<TabViewContainer> {
  Stream<QuerySnapshot> _vouchersStream = FirebaseFirestore.instance
      .collection('voucher')
      .where('voucherid', isEqualTo: '')
      .snapshots();

  @override
  void initState() {
    super.initState();
    if (widget.tabbar == 'available') {
      loadAvailableVoucher();
    } else if (widget.tabbar == 'earned') {
      loadEarnedVoucher();
    } else {
      loadExpiryVoucher();
    }
  }

  Future<void> loadAvailableVoucher() async {
    final nonExpiredVouchers = await FirebaseFirestore.instance
        .collection('voucher')
        .get()
        .then((snapshot) => snapshot.docs
            .where((doc) => DateFormat("MMMM d, y", "en_US")
                .parse(doc['expiry_date'])
                .isAfter(DateTime.now()))
            .map((doc) => doc.id)
            .toList());

    setState(() {});
    _vouchersStream = FirebaseFirestore.instance
        .collection('voucher')
        .where(FieldPath.documentId, whereIn: nonExpiredVouchers)
        .snapshots();
  }

  Future<void> loadEarnedVoucher() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final nonExpiredVouchers = await FirebaseFirestore.instance
        .collection('voucher')
        .get()
        .then((snapshot) => snapshot.docs
            .where((doc) => DateFormat("MMMM d, y", "en_US")
                .parse(doc['expiry_date'])
                .isAfter(DateTime.now()))
            .map((doc) => doc.id)
            .toList());
    setState(() {});
    if (nonExpiredVouchers.isNotEmpty) {
      _vouchersStream = FirebaseFirestore.instance
          .collection('voucher_redeemption')
          .where('userid', isEqualTo: userId)
          .where('voucherid', whereIn: nonExpiredVouchers)
          .where('redeemed', isEqualTo: false)
          .snapshots();
    }
  }

  Future<void> loadExpiryVoucher() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final expiredVoucherids = await FirebaseFirestore.instance
        .collection('voucher')
        .get()
        .then((snapshot) => snapshot.docs
            .where((doc) => DateFormat("MMMM d, y", "en_US")
                .parse(doc['expiry_date'])
                .isBefore(DateTime.now()))
            .map((doc) => doc.id)
            .toList());
    final usedVoucherRedeemption = await FirebaseFirestore.instance
        .collection('voucher_redeemption')
        .where('userid', isEqualTo: userId)
        .where('redeemed', isEqualTo: true)
        .get()
        .then((snapshot) => snapshot.docs.map((doc) => doc.id).toList());

    final expiredVoucherRedeemption = expiredVoucherids.isNotEmpty
        ? await FirebaseFirestore.instance
            .collection('voucher_redeemption')
            .where('userid', isEqualTo: userId)
            .where('voucherid', whereIn: expiredVoucherids)
            .get()
            .then((snapshot) => snapshot.docs.map((doc) => doc.id).toList())
        : [];

    final expiredAndUsedVoucher =
        expiredVoucherRedeemption + usedVoucherRedeemption;
    setState(() {});
    if (expiredAndUsedVoucher.isNotEmpty) {
      _vouchersStream = FirebaseFirestore.instance
          .collection('voucher_redeemption')
          .where(FieldPath.documentId, whereIn: expiredAndUsedVoucher)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: _vouchersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading"));
          }
          if (snapshot.data!.size == 0) {
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(child: Text("No voucher available")),
            );
          }

          return Column(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              if (widget.tabbar == 'earned' ||
                  widget.tabbar == 'used/expired') {
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('voucher')
                      .doc(data['voucherid'])
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final voucherdata = snapshot.data!;

                      return VoucherContainer(
                        documentid: document.id,
                        imageurl: voucherdata['image_url'],
                        vouchername: voucherdata['name'],
                        expirydate: voucherdata['expiry_date'],
                        voucherpoint:
                            int.parse(voucherdata['point'].toString()),
                        tabbar: widget.tabbar,
                        point: widget.point,
                        isRedeemed: data['redeemed'],
                      );
                    } else {
                      return Container(); // or a loading indicator widget
                    }
                  },
                );
              } else {
                return VoucherContainer(
                  point: widget.point,
                  documentid: document.id,
                  imageurl: data['image_url'],
                  vouchername: data['name'],
                  expirydate: data['expiry_date'],
                  voucherpoint: int.parse(data['point'].toString()),
                  tabbar: widget.tabbar,
                  isRedeemed: false,
                );
              }
            }).toList(),
          );
        },
      ),
    );
  }
}

class VoucherContainer extends StatefulWidget {
  const VoucherContainer(
      {super.key,
      required this.imageurl,
      required this.vouchername,
      required this.expirydate,
      required this.documentid,
      required this.point,
      required this.voucherpoint,
      required this.isRedeemed,
      required this.tabbar});

  final String imageurl;
  final String vouchername;
  final String expirydate;
  final String documentid;
  final String tabbar;
  final int point;
  final int voucherpoint;
  final bool isRedeemed;

  @override
  State<VoucherContainer> createState() => _VoucherContainerState();
}

class _VoucherContainerState extends State<VoucherContainer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          color:
              widget.tabbar == 'used/expired' ? Colors.grey : kLightOrangeColor,
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Image(
                      image: NetworkImage(widget.imageurl),
                      width: 100,
                    ),
                  ),
                  VoucherContainerDetailsRight(
                      documentid: widget.documentid,
                      vouchername: widget.vouchername,
                      expirydate: widget.expirydate,
                      tabbar: widget.tabbar,
                      point: widget.point,
                      voucherpoint: widget.voucherpoint,
                      isRedeemed: widget.isRedeemed,
                      imageurl: widget.imageurl)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VoucherContainerDetailsRight extends StatelessWidget {
  const VoucherContainerDetailsRight(
      {super.key,
      required this.vouchername,
      required this.expirydate,
      required this.documentid,
      required this.tabbar,
      required this.voucherpoint,
      required this.isRedeemed,
      required this.imageurl,
      required this.point});
  final String vouchername;
  final String expirydate;
  final String documentid;
  final String tabbar;
  final String imageurl;
  final int point;
  final int voucherpoint;
  final bool isRedeemed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                vouchername,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  'Expiry Date: $expirydate',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                tabbar == 'available'
                    ? Text('$voucherpoint points')
                    : SizedBox(),
                tabbar == 'available'
                    ? RedeemButton(
                        documentid: documentid,
                        point: point,
                        voucherpoint: voucherpoint,
                      )
                    : tabbar == 'earned'
                        ? TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xFFFE8235),
                              textStyle: const TextStyle(fontSize: 15),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RedeemPage(
                                        documentid: documentid,
                                        imageurl: imageurl),
                                  ));
                            },
                            child: Text(
                              "Use",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              isRedeemed ? 'Used' : 'Expired',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RedeemButton extends StatefulWidget {
  const RedeemButton({
    Key? key,
    required this.documentid,
    required this.point,
    required this.voucherpoint,
  }) : super(key: key);

  final String documentid;
  final int point;
  final int voucherpoint;

  @override
  State<RedeemButton> createState() => _RedeemButtonState();
}

class _RedeemButtonState extends State<RedeemButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextButton(
        style: widget.point >= widget.voucherpoint
            ? TextButton.styleFrom(
                backgroundColor: Color(0xFFFE8235),
                textStyle: const TextStyle(fontSize: 15),
              )
            : TextButton.styleFrom(
                backgroundColor: Colors.grey,
                textStyle: const TextStyle(fontSize: 15),
              ),
        onPressed: widget.point >= widget.voucherpoint
            ? (() {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Confirm Voucher Redemption?'),
                        content: Text(
                            'Are you sure you want to redeem this voucher?.'),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: kOrangeButtonStyle,
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Redemption newRedemptionData = Redemption(
                                  userid:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  redemptiondate: DateFormat('MMMM d, y')
                                      .format(DateTime.now()),
                                  voucherid: widget.documentid,
                                  redeemed: false);
                              final addNewRedemption =
                                  FirebaseFirestore.instance
                                      .collection('voucher_redeemption')
                                      .withConverter(
                                        fromFirestore: Redemption.fromFirestore,
                                        toFirestore: (Redemption redemptionData,
                                                options) =>
                                            redemptionData.toFirestore(),
                                      )
                                      .doc();
                              final db = FirebaseFirestore.instance;
                              // Get a new write batch
                              final batch = db.batch();
                              final ref = db
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser!.uid);

                              batch.update(ref, {
                                "point": widget.point - widget.voucherpoint
                              });
                              batch.commit().then((_) {
                                print('updated the user point');
                              });

                              await addNewRedemption
                                  .set(newRedemptionData)
                                  .then((value) {
                                Navigator.pop(context);
                                Navigator.popAndPushNamed(
                                    context, RewardsMainPage.id);
                              });
                            },
                            style: kOrangeButtonStyle,
                            child: Text('Confirm'),
                          ),
                        ],
                      );
                    });
              })
            : null,
        child: Text(
          "Redeem",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

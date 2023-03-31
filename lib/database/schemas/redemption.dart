import 'package:cloud_firestore/cloud_firestore.dart';

class Redemption {
  final String? redemptiondate;
  final String? userid;
  final String? voucherid;
  final bool? redeemed;

  Redemption({this.redemptiondate, this.userid, this.voucherid, this.redeemed});

  factory Redemption.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Redemption(
        redemptiondate: data?['redemptiondate'],
        userid: data?['userid'],
        redeemed: data?['redeemed'],
        voucherid: data?['voucherid']);
  }
  Map<String, dynamic> toFirestore() {
    return {
      if (redemptiondate != null) "redemptiondate": redemptiondate,
      if (userid != null) "userid": userid,
      if (voucherid != null) "voucherid": voucherid,
      if (redeemed != null) "redeemed": redeemed,
    };
  }
}

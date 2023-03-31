import 'package:cloud_firestore/cloud_firestore.dart';

class ReportData {
  ReportData(
      {String? reason = '',
      required this.firstAider,
      required this.targetUser,
      String? id})
      : id = id ?? 'demo_id_${DateTime.now().millisecondsSinceEpoch}';

  final String id;
  String? reason;
  String firstAider;
  String targetUser;

  factory ReportData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return ReportData(
        reason: data?['reason'],
        firstAider: data?['firstAider'],
        targetUser: data?['targetUser'],
        id: data?['id']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "reason": reason,
      "firstAider": firstAider,
      "targetUser": targetUser
    };
  }
}

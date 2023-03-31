import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultationPeriod {
  ConsultationPeriod(
      {required this.first_aider,
      required this.target_user,
      required this.period,
      String? id})
      : id = id ?? 'demo_id_${DateTime.now().millisecondsSinceEpoch}';

  final String id;
  String first_aider;
  String target_user;
  int period;

  factory ConsultationPeriod.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return ConsultationPeriod(
        first_aider: data?['first_aider'],
        target_user: data?['target_user'],
        period: data?['period'],
        id: data?['id']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "first_aider": first_aider,
      "target_user": target_user,
      "period": period
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultationRequest {
  ConsultationRequest(
      {required this.roomId,
      required this.status,
      required this.all_fa,
      required this.is_video,
      this.first_aider = '',
      required this.target_user,
      String? id})
      : id = id ?? 'demo_id_${DateTime.now().millisecondsSinceEpoch}';

  final String id;
  String roomId;
  String status;
  bool all_fa;
  bool is_video;
  String first_aider;
  String target_user;

  factory ConsultationRequest.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ConsultationRequest(
        roomId: data?['roomId'],
        status: data?['status'],
        all_fa: data?['all_fa'],
        is_video: data?['is_video'],
        first_aider: data?['first_aider'],
        id: data?['id'],
        target_user: data?['target_user']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "roomId": roomId,
      "status": status,
      "all_fa": all_fa,
      "is_video": is_video,
      "first_aider": first_aider,
      "target_user": target_user
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class CourseProgress {
  final int? progress;
  final String? answer;
  final bool? requirement_1;
  final bool? requirement_2;
  final String? user_id;

  CourseProgress(
      {this.progress,
      this.answer,
      this.requirement_1,
      this.requirement_2,
      this.user_id});

  factory CourseProgress.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CourseProgress(
        progress: data?['progress'],
        answer: data?['answer'],
        requirement_1: data?['requirement_1'],
        requirement_2: data?['requirement_2'],
        user_id: data?['user_id']);
  }
  Map<String, dynamic> toFirestore() {
    return {
      if (progress != null) "progress": progress,
      if (answer != null) "answer": answer,
      if (requirement_1 != null) "requirement_1": requirement_1,
      if (requirement_2 != null) "requirement_2": requirement_2,
      if (user_id != null) "user_id": user_id,
    };
  }
}

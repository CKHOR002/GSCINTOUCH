import 'package:cloud_firestore/cloud_firestore.dart';

class Quizzes {
  final String? senario;
  final String? courseListid;

  Quizzes({
    this.senario,
    this.courseListid,
  });

  factory Quizzes.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Quizzes(
      senario: data?['senario'],
      courseListid: data?['courselist_id'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      if (senario != null) "senario": senario,
      if (courseListid != null) "courseListid": courseListid,
    };
  }
}

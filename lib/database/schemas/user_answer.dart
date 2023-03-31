import 'package:cloud_firestore/cloud_firestore.dart';

class UserQuizAnswer {
  final String? quizid;
  final String? answer;
  final bool? isAccepted;
  final String? apiResponse;
  final String? userid;

  UserQuizAnswer({
    this.quizid,
    this.answer,
    this.isAccepted,
    this.apiResponse,
    this.userid,
  });

  factory UserQuizAnswer.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserQuizAnswer(
      quizid: data?['quizid'],
      answer: data?['answer'],
      isAccepted: data?['isAccepted'],
      apiResponse: data?['apiResponse'],
      userid: data?['userid'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      if (quizid != null) "quizid": quizid,
      if (answer != null) "answer": answer,
      if (isAccepted != null) "isAccepted": isAccepted,
      if (apiResponse != null) "apiResponse": apiResponse,
      if (userid != null) "userid": userid,
    };
  }
}

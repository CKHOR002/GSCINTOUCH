import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../database/schemas/courseprogress.dart';
import '../database/schemas/quizzes.dart';
import '../database/schemas/user_answer.dart';

var apiKey = dotenv.env['OpenAIAPIKey'];
var apiUrl = Uri.https('api.openai.com', '/v1/chat/completions');

class QuizzesRead extends ChangeNotifier {
  String? senario;
  String? apiResponseText = '';
  String? courseListId;
  String? quizID;
  String? answer = '';
  bool isLoading = false;
  bool isAccepted = false;
  int? progress;

  Future<String> apiResponse(String? answer, String? senario) async {
    print('calling api');
    isLoading = true;
    notifyListeners();

    final response = await http.post(apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey'
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo-0301',
          "messages": [
            {
              "role": "user",
              "content":
                  'Scenario:\n $senario\n\n Response to this scenario:\n $answer\n\n\n Determine this response may appropriate by giving a yes/no answer and continue with justification.\n'
            }
          ]
        }));

    if (response.statusCode == 200) {
      notifyListeners();
      print(json.decode(response.body)['choices'][0]['message']['content']);
      return json.decode(response.body)['choices'][0]['message']['content'];
    } else {
      throw response.body;
    }
  }

  Future<String?> open(String? courseListID) async {
    final db = FirebaseFirestore.instance;
    await db
        .collection("quizzes")
        .where('courselist_id', isEqualTo: courseListID)
        .get()
        .then((snapshot) async {
      String docid = snapshot.docs.first.id;
      final ref = db.collection("quizzes").doc(docid).withConverter(
            fromFirestore: Quizzes.fromFirestore,
            toFirestore: (Quizzes courseProgress, _) =>
                courseProgress.toFirestore(),
          );

      final docSnap = await ref.get();
      final quizdata = docSnap.data();
      if (quizdata != null) {
        senario = quizdata.senario;
        courseListId = quizdata.courseListid;
        quizID = docid;
        await db
            .collection("user-answer")
            .where('userid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('quizid', isEqualTo: docid)
            .withConverter(
              fromFirestore: UserQuizAnswer.fromFirestore,
              toFirestore: (UserQuizAnswer userQuizAnswer, _) =>
                  userQuizAnswer.toFirestore(),
            )
            .get()
            .then((snapshot) async {
          if (snapshot.size != 0) {
            String docid = snapshot.docs.first.id;
            final quizAnswerRef =
                db.collection("user-answer").doc(docid).withConverter(
                      fromFirestore: UserQuizAnswer.fromFirestore,
                      toFirestore: (UserQuizAnswer userQuizAnswer, _) =>
                          userQuizAnswer.toFirestore(),
                    );
            final quizAnswerDocSnap = await quizAnswerRef.get();
            final quizAnswerdata = quizAnswerDocSnap.data();
            if (quizAnswerdata != null) {
              answer = quizAnswerdata.answer;
              apiResponseText = quizAnswerdata.apiResponse;
              isAccepted = quizAnswerdata.isAccepted!;
            }
          }
        });
        await db
            .collection("course-progress")
            .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .get()
            .then((snapshot) async {
          String docid = snapshot.docs.first.id;
          final ref = db.collection("course-progress").doc(docid).withConverter(
                fromFirestore: CourseProgress.fromFirestore,
                toFirestore: (CourseProgress courseProgress, _) =>
                    courseProgress.toFirestore(),
              );
          final docSnap = await ref.get();
          final courseProgress = docSnap.data();
          if (courseProgress != null) {
            progress = courseProgress.progress;
          }
        });

        notifyListeners();
        return senario;
      } else {
        print("No such document.");
      }
    });
    return senario;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/database/schemas/courseprogress.dart';
import '../database/crud_functions/updateprogresstable.dart';

var apiKey = dotenv.env['OpenAIAPIKey'];
var apiUrl = Uri.https('api.openai.com', '/v1/chat/completions');

class PFACourseSkillValidation extends ChangeNotifier {
  bool? requirement_1;

  String? answer;
  int? progress;

  bool isValidate = false;
  PFACourseSkillValidation() {
    open();
  }
  Future<String> generateText(String content, String model) async {
    final response = await http.post(apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey'
        },
        body: jsonEncode({
          'model': model,
          "messages": [
            {"role": "user", "content": content}
          ]
        }));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(response.body);
    }
  }

  Future<String> openAIAPIResponse(String text) async {
    return await generateText(
        "Scenario:\nYou are a psychological first aid provider responding to a natural disaster. You encounter a survivor who has lost everything and is visibly distressed. How would you approach the survivor and provide psychological first aid?\n\nResponse to this scenario:\n$text\n\n\nValidate this response by giving yes/no with justification.\n",
        'gpt-3.5-turbo-0301');
  }

  void validation(String text) async {
    var response = await openAIAPIResponse(text);
    var responseText =
        json.decode(response)['choices'][0]['message']['content'];
    await updateAnswer(text);
    if (responseText.contains('Yes')) {
      isValidate = true;
      await updateRequirement(1, isValidate);
    } else {
      isValidate = false;
      await updateRequirement(1, isValidate);
    }

    notifyListeners();
  }

  Future<void> open() async {
    final db = FirebaseFirestore.instance;
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
        answer = courseProgress.answer;
        notifyListeners();
      } else {
        print("No such document.");
      }
    });
  }
}

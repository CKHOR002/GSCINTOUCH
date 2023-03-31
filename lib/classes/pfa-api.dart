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
var apiUrl = Uri.https('api.openai.com', '/v1/completions');

class PFA1RequirementData extends ChangeNotifier {
  bool? requirement_1;
  bool? requirement_2;
  String? answer;
  int? progress;

  bool isValidate1 = false;
  bool isValidate2 = false;
  PFA1RequirementData() {
    open();
  }
  Future<String> generateText(String prompt, String model) async {
    final response = await http.post(apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey'
        },
        body: jsonEncode(
            {'prompt': prompt, 'max_tokens': 50, 'stop': '.', 'model': model}));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(response.body);
    }
  }

  Future<String> openAIAPIRequirement1(String text) async {
    return await generateText(
        "Decide whether this sentence contains self-introduction\n\n Sentence: \"${text}\"\n Yes/No:",
        'text-davinci-003');
  }

  Future<String> openAIAPIRequirement2(String text) async {
    return await generateText(
        "Decide whether this conversation contains the purpose of this conversation.\n\n Conversation: \"${text}\"\n Yes/No:",
        'text-davinci-003');
  }

  void validation(String text) async {
    var response1 = await openAIAPIRequirement1(text);
    var responseText1 = json.decode(response1)['choices'][0]['text'];
    await updateAnswer(text);
    if (responseText1.contains('Yes')) {
      isValidate1 = true;
      await updateRequirement(1, isValidate1);
    } else {
      isValidate1 = false;
      await updateRequirement(1, isValidate1);
    }
    var response2 = await openAIAPIRequirement2(text);
    var responseText2 = json.decode(response2)['choices'][0]['text'];

    if (responseText2.contains('Yes')) {
      isValidate2 = true;
      await updateRequirement(2, isValidate2);
    } else {
      isValidate2 = false;
      await updateRequirement(2, isValidate2);
    }
    notifyListeners();
  }

  Future<int?> open() async {
    final db = FirebaseFirestore.instance;
    final ref = await db
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
        requirement_1 = courseProgress.requirement_1;
        requirement_2 = courseProgress.requirement_2;
        progress = courseProgress.progress;
        answer = courseProgress.answer;
        notifyListeners();
      } else {
        print("No such document.");
      }

      return progress;
    });
    return progress;
  }
}

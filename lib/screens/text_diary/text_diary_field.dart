// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/bottom_navbar.dart';
import 'package:intl/intl.dart';
import 'package:intouch_imagine_cup/screens/text_diary/text_diary_main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis_auth/auth_io.dart';

class TextDiaryField extends StatefulWidget {
  const TextDiaryField({Key? key}) : super(key: key);
  static const String id = 'textDiaryField';

  @override
  State<TextDiaryField> createState() => _TextDiaryFieldState();
}

class _TextDiaryFieldState extends State<TextDiaryField> {
  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            createDiaryData(textController.text).then((value) {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, TextDiaryMainPage.id);
            });
          },
          backgroundColor: kOrangeColor,
          child: const Icon(Icons.check),
        ),
        appBar: WhiteAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0,
                ),
                child: Center(
                  child: Text(
                    DateFormat.yMMMMd('en_US').format(
                      DateTime.now(),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                  bottom: 10.0,
                  left: 10.0,
                ),
                child: TextField(
                  controller: textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "How are you feeling today?",
                    hintStyle: kSubtitleTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavbar(selectedIndex: 2),
      ),
    );
  }
}

//sentiment analysis google cloud
Future<String> extractKeyPhrases(String? text) async {
  // late String gCloudAccessToken;
  var accountCredentials = ServiceAccountCredentials.fromJson({
    "type": "service_account",
    "private_key_id": dotenv.env['GoogleAPIPrivateKeyID'],
    "private_key": dotenv.env['GoogleAPIPrivateKey'],
    "client_email": "audiototext@intouch-378205.iam.gserviceaccount.com",
    "client_id": "112907106975140504099"
  });

  List<String> scopes = [
    'https://www.googleapis.com/auth/cloud-platform',
    'https://www.googleapis.com/auth/devstorage.full_control'
  ];

  AuthClient client = await clientViaServiceAccount(accountCredentials, scopes);
  var response = await client.post(
    Uri.parse('https://language.googleapis.com/v1/documents:analyzeSentiment'),
    body: json.encode(
      {
        'document': {
          'type': 'PLAIN_TEXT',
          'language': 'en-GB',
          'content': text,
        },
        'encodingType': 'UTF8'
      },
    ),
  );
  return response.body;
}

//to create diary entry to database
Future<void> createDiaryData(String controllerText) async {
  final db = FirebaseFirestore.instance;
  dynamic jsonData = jsonDecode(await extractKeyPhrases(controllerText));
  var sentimentScore = await jsonData['documentSentiment']['score'] / 2 + 0.5;

  final data = {
    "detail": controllerText,
    "date": DateFormat.yMMMMd('en_US').format(DateTime.now()),
    "time": DateFormat.jm().format(DateTime.now()),
    "user_id": FirebaseAuth.instance.currentUser?.uid,
    "sentimentScore": sentimentScore * 100,
    "datetime": FieldValue.serverTimestamp()
  };
  db.collection("text_diary").add(data);

  final userRef =
      db.collection("users").doc(FirebaseAuth.instance.currentUser!.uid);
  db.runTransaction((transaction) async {
    final snapshot = await transaction.get(userRef);

    final newPoint = snapshot.get("point") + 10;
    transaction.update(userRef, {"point": newPoint});
  }).then(
    (value) => print("DocumentSnapshot successfully updated!"),
    onError: (e) => print("Error updating document $e"),
  );
}

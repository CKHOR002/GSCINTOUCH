// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/bottom_navbar.dart';
import 'package:intl/intl.dart';
import 'package:intouch_imagine_cup/screens/text_diary/text_diary_main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'dart:convert';
import '../../database/schemas/textdiary.dart';

class TextDiaryDetail extends StatefulWidget {
  const TextDiaryDetail({super.key, required this.textdiarydata});
  static const String id = 'textDiaryDetail';

  final TextDiaryEntryData textdiarydata;

  @override
  State<TextDiaryDetail> createState() => _TextDiaryDetailState();
}

class _TextDiaryDetailState extends State<TextDiaryDetail> {
  bool editmode = false;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (editmode != true) {
            setState(() {
              editmode = true;
            });
          } else {
            updateDiaryData(textController.text, widget.textdiarydata).then(
              (value) =>
                  Navigator.popAndPushNamed(context, TextDiaryMainPage.id),
            );
          }
        },
        backgroundColor: kOrangeColor,
        child: editmode ? const Icon(Icons.check) : const Icon(Icons.edit),
      ),
      appBar: WhiteAppBar(),
      body: SafeArea(
        child: editmode ? edit_mode() : default_mode(),
      ),
      bottomNavigationBar: BottomNavbar(selectedIndex: 2),
    );
  }

  //diary edit mode
  // ignore: non_constant_identifier_names
  Column edit_mode() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 10.0,
          ),
          child: Center(
            child: Text(
              '${widget.textdiarydata.date}',
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
            controller: textController
              ..text = widget.textdiarydata.details.toString(),
            style: kSubtitleTextStyle,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  //default reading mode
  // ignore: non_constant_identifier_names
  Column default_mode() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 10.0,
            left: 10.0,
          ),
          child: Text(
            '${widget.textdiarydata.date}. ${widget.textdiarydata.time}', //date of detail
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
        Center(
          child: Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                    right: 10,
                  ),
                  child: Text(
                    'Sentiment Score:', //date of detail
                    textAlign: TextAlign.right,
                    style: kInputHeaderTextStyle,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                  ),
                  child: Text(
                    widget.textdiarydata.sentimentscore
                        .toString(), //date of detail
                    // textAlign: TextAlign.left,
                    style: kInputHeaderTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 10.0,
            left: 10.0,
            right: 10.0,
          ),
          child: Text(
            widget.textdiarydata.details.toString(),
            style: kSubtitleTextStyle,
          ),
        ),
      ],
    );
  }
}

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

Future<void> updateDiaryData(
    String controllerText, TextDiaryEntryData textdiarydata) async {
  final db = FirebaseFirestore.instance;
  dynamic jsonData = jsonDecode(await extractKeyPhrases(controllerText));
  var sentimentScore = await jsonData['documentSentiment']['score'] / 2 + 0.5;

  final data = {
    "detail": controllerText,
    "sentimentScore": sentimentScore * 100,
  };
  await db
      .collection("text_diary")
      .doc(textdiarydata.id.toString())
      .update(data);
}

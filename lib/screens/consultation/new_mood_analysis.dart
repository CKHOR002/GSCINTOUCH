import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'package:intouch_imagine_cup/constants.dart';
import 'package:intouch_imagine_cup/screens/consultation/main_screen.dart';
import 'package:intouch_imagine_cup/classes/room_data.dart';
import 'package:intouch_imagine_cup/classes/current_user.dart';
import 'package:intouch_imagine_cup/database/schemas/mood_analysis.dart';
import 'package:intouch_imagine_cup/database/schemas/consultation_request.dart';
import 'package:intouch_imagine_cup/components/report_dialog.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/bottom_navbar.dart';

class NewMoodAnalysis extends StatefulWidget {
  const NewMoodAnalysis({Key? key}) : super(key: key);

  static const String id = 'new_mood_analysis';

  @override
  State<NewMoodAnalysis> createState() => _NewMoodAnalysisState();
}

class _NewMoodAnalysisState extends State<NewMoodAnalysis> {
  late AuthClient client;
  late String gCloudAccessToken;
  late String roomId;
  late String sessionId;
  late List<String> imageList;
  String transcriptText = '';
  bool textAnalysis = true;
  bool imageAnalysis = false;

  List<Feature> features = [];
  List<String> labelX = [];
  final colorList = <Color>[
    kOrangeColor,
    kOrangeColor.withOpacity(0.75),
    kOrangeColor.withOpacity(0.5),
    kOrangeColor.withOpacity(0.25),
  ];
  Map<String, double> dataMap = {
    "Joy": 0,
    "Sorrow": 0,
    "Anger": 0,
    "Surprise": 0,
  };

  // final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

  Future<void> gCloudAuthentication() async {
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

    client = await clientViaServiceAccount(accountCredentials, scopes);
    gCloudAccessToken = client.credentials.accessToken.data;
    print('authentication done');
    // imageList length > 0 means target user got turn on camera at sometime of the consultation
    if (imageList.length > 0) {
      faceDetection();
    } else {
      imageAnalysis = true;
    }
    // convertToMP3();
  }

  void getRecordedFile() async {
    const platform =
        MethodChannel('com.example.intouch_imagine_cup/100ms_token');
    String managementAccessToken =
        await platform.invokeMethod('generateAccessToken');

    final http.Response httpResponse = await http.get(
      Uri.parse(
        "https://api.100ms.live/v2/analytics/events?type=recording.success&room_id=$roomId",
      ),
      headers: {'Authorization': 'Bearer $managementAccessToken'},
    );

    print('Recorded info : ${json.decode(httpResponse.body)}');
  }

  // void convertVideoToAudio() async {
  //   try {
  //     String currentDate = DateFormat('yMd').format(DateTime.now());
  //     await _flutterFFmpeg
  //         .execute(
  //             "-vn -sn -dn -i https://brytecam-prod-bucket-ap-south-1.s3.ap-south-1.amazonaws.com/recordings/640b23feedc7c8f3674c0d80/$roomId/$currentDate/$sessionId/Rec-640f1e77c93accaf011ba23b-1678712441810.mp4?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5QK5MFS4SMZONBH4%2F20230313%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Date=20230313T130514Z&X-Amz-Expires=259200&X-Amz-SignedHeaders=host&x-id=GetObject&X-Amz-Signature=5b38e9d8622ae05d2ef9d8b95ff25335ab5b609ba36b6fbdf51e39973c4ab146 -codec:a libmp3lame -qscale:a 4 /storage/emulated/0/download/${roomId}.mp3")
  //         .then((rc) => print("FFmpeg process exited with rc $rc"));
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  void faceDetection() async {
    try {
      print(
          'face detection started with imageList length : ${imageList.length}');

      List<dynamic> requests = [];
      for (int i = 0; i < imageList.length; i++) {
        requests.add({
          "image": {"content": imageList[i]},
          "features": [
            {"type": "FACE_DETECTION"}
          ]
        });
      }
      final http.Response response = await client.post(
        Uri.parse('https://vision.googleapis.com/v1/images:annotate'),
        body: json.encode({"requests": requests}),
      );

      print(json.decode(response.body));
      var jsonResult = json.decode(response.body);
      var result = jsonResult['responses'];
      print('result : $result');

      for (int i = 0; i < result.length; i++) {
        print(result[i]['faceAnnotations'][0]['joyLikelihood']);

        String joyLikelihood = result[i]['faceAnnotations'][0]['joyLikelihood'];
        if (joyLikelihood == 'POSSIBLE' ||
            joyLikelihood == 'LIKELY' ||
            joyLikelihood == 'VERY_LIKELY') {
          dataMap['Joy'] = dataMap['Joy']! + 1.0;
        }

        String sorrowLikelihood =
            result[i]['faceAnnotations'][0]['sorrowLikelihood'];
        if (sorrowLikelihood == 'POSSIBLE' ||
            sorrowLikelihood == 'LIKELY' ||
            sorrowLikelihood == 'VERY_LIKELY') {
          dataMap['Sorrow'] = dataMap['Sorrow']! + 1.0;
        }

        String angerLikelihood =
            result[i]['faceAnnotations'][0]['angerLikelihood'];
        if (angerLikelihood == 'POSSIBLE' ||
            angerLikelihood == 'LIKELY' ||
            angerLikelihood == 'VERY_LIKELY') {
          dataMap['Anger'] = dataMap['Anger']! + 1.0;
        }

        String surpriseLikelihood =
            result[i]['faceAnnotations'][0]['surpriseLikelihood'];
        if (surpriseLikelihood == 'POSSIBLE' ||
            surpriseLikelihood == 'LIKELY' ||
            surpriseLikelihood == 'VERY_LIKELY') {
          dataMap['Surprise'] = dataMap['Surprise']! + 1.0;
        }
      }

      if (result.length == 0) {
        print('no result for face detection');
      } else {
        insertSentimentToFirebase([], 0.00);
      }
      setState(() {
        imageAnalysis = true;
      });
    } catch (e) {
      print(e);
    }
  }

  // void convertToMP3() async {
  //   try {
  //     await _flutterFFmpeg
  //         .execute(
  //             "-vn -sn -dn -i /storage/emulated/0/download/$roomId.mp4 -codec:a libmp3lame -qscale:a 4 /storage/emulated/0/download/$roomId.mp3")
  //         .then((rc) => print("FFmpeg process exited with rc $rc"));
  //     uploadAudioFileToCloudStorage();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  void uploadAudioFileToCloudStorage() async {
    try {
      var uri = Uri.parse(
          "https://storage.googleapis.com/upload/storage/v1/b/audio_intouch/o?uploadType=media&name=$roomId.mp3");
      var request = http.MultipartRequest("POST", uri);
      request.headers['Authorization'] = 'Bearer ${gCloudAccessToken}';

      var multipartFile = await http.MultipartFile.fromPath(
          "package", '/storage/emulated/0/download/$roomId.mp3');
      request.files.add(multipartFile);

      http.StreamedResponse response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
      convertAudioToText();
    } catch (e) {
      print(e);
    }
  }

  void convertAudioToText() async {
    try {
      // Working encoding : LINEAR16 with 16000,  OGG_OPUS with 16000
      final http.Response response = await client.post(
        Uri.parse(
            'https://speech.googleapis.com/v1p1beta1/speech:longrunningrecognize'),
        body: json.encode({
          "audio": {"uri": "gs://audio_intouch/$roomId.mp3"},
          "config": {
            "encoding": "MP3",
            "sampleRateHertz": 16000,
            "languageCode": "en-US",
            "enableWordTimeOffsets": true,
            "useEnhanced": true,
            'model': "latest_long"
          },
          "outputConfig": {"gcsUri": "gs://transcription_intouch/$roomId.json"}
        }),
      );

      print(json.decode(response.body));

      Future.delayed(const Duration(minutes: 1), getFileFromCloudStorage);
    } catch (e) {
      print(e);
    }
  }

  void getFileFromCloudStorage() async {
    try {
      final http.Response response = await client.get(
        Uri.parse(
            'https://storage.googleapis.com/storage/v1/b/transcription_intouch/o/$roomId.json?alt=media'),
      );
      if (json.decode(response.body)['results'] != null) {
        List<dynamic> transcript = json.decode(response.body)['results'];
        print(transcript);
        for (var i = 0; i < transcript.length; i++) {
          transcriptText +=
              transcript[i]['alternatives'][0]['transcript'] + '. ';
        }
        print(transcriptText);
        sentimentAnalysis();
      } else {
        setState(() {
          textAnalysis = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> sentimentAnalysis() async {
    try {
      final http.Response response = await client.post(
          Uri.parse(
              'https://language.googleapis.com/v1/documents:analyzeSentiment'),
          body: json.encode({
            'document': {
              'type': 'PLAIN_TEXT',
              'language': 'en-GB',
              'content': transcriptText,
            },
            'encodingType': 'UTF8'
          }));

      print(json.decode(response.body));
      List<dynamic> sentences = json.decode(response.body)['sentences'];
      List<double> data = [];

      if (sentences.length < 2) {
        // TODO: Error
      } else {
        for (var i = 0; i < sentences.length; i++) {
          double value = sentences[i]['sentiment']['score'] / 2 + 0.5;
          data.add(value);
          labelX.add('');
        }

        setState(() {
          features.add(Feature(
            color: kOrangeColor,
            data: data,
          ));
          textAnalysis = true;
        });

        insertSentimentToFirebase(data,
            json.decode(response.body)['documentSentiment']['score'] / 2 + 0.5);
      }
    } catch (e) {
      print(e);
      // TODO: Error
    }
  }

  void insertSentimentToFirebase(
      List<double> sentimentList, double overallSentiment) async {
    try {
      final db = FirebaseFirestore.instance;

      MoodAnalysisData analysisReport = MoodAnalysisData(
          consultationId: Provider.of<RoomData>(context, listen: false)
              .consultationRequestId!,
          moodChart: dataMap);

      final docRef = db
          .collection('sentiment_report')
          .withConverter(
            fromFirestore: MoodAnalysisData.fromFirestore,
            toFirestore: (MoodAnalysisData moodAnalysisData, options) =>
                moodAnalysisData.toFirestore(),
          )
          .doc(analysisReport.id);
      await docRef.set(analysisReport);

      print('Document inserted to firebase storage');

      // removeObjectsFromCloudStorage();
    } catch (e) {
      print(e);
      // TODO : Error
    }
  }

  Future<void> removeObjectsFromCloudStorage() async {
    /* Delete audio from storage */
    await client.delete(Uri.parse(
        "https://storage.googleapis.com/storage/v1/b/audio_intouch/o/$roomId.mp3"));

    await client.delete(Uri.parse(
        "https://storage.googleapis.com/storage/v1/b/transcription_intouch/o/$roomId.json"));

    await File('storage/emulated/0/download/${roomId}.mp3').delete();
    await File('storage/emulated/0/download/${roomId}.mp4').delete();

    client.close();
    print('finish deleting');
  }

  /* To find out which first aider is in this session */
  Future<String> queryConsultationRequest() async {
    final db = FirebaseFirestore.instance;

    /* Find the current consultation request */
    final query = db
        .collection("consultation_request")
        .where("roomId", isEqualTo: roomId)
        .withConverter(
          fromFirestore: ConsultationRequest.fromFirestore,
          toFirestore: (ConsultationRequest consultationRequest, _) =>
              consultationRequest.toFirestore(),
        );

    final docSnap = await query.get();
    final consultationRequest = docSnap.docs.first;

    return consultationRequest.data().first_aider;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gCloudAuthentication();
    });
  }

  @override
  Widget build(BuildContext context) {
    roomId = Provider.of<RoomData>(context, listen: false).roomID;
    final routes =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    imageList = routes['imageList'];
    return Scaffold(
      appBar: WhiteAppBar(),
      body: (imageAnalysis == true && textAnalysis == true)
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Mood Report',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w700,
                            fontSize: 30.0,
                            color: Colors.black),
                      ),
                      Provider.of<CurrentUser>(context).currentUser!.userType ==
                              'User'
                          ? GestureDetector(
                              onTap: () async {
                                String firstAiderID =
                                    await queryConsultationRequest();
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ReportDialog(
                                        firstAiderID: firstAiderID,
                                      );
                                    });
                              },
                              child: Icon(
                                Icons.flag,
                                color: Colors.red,
                                size: 30.0,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.only(bottom: 16.0),
                          //       child: Text(
                          //         'Mood over Time',
                          //         style: kInputHeaderTextStyle,
                          //       ),
                          //     ),
                          //     Container(
                          //         decoration: BoxDecoration(
                          //             shape: BoxShape.rectangle,
                          //             color: Colors.white,
                          //             borderRadius: BorderRadius.circular(10.0),
                          //             boxShadow: [
                          //               BoxShadow(
                          //                   color: Colors.grey.shade300,
                          //                   blurRadius: 1,
                          //                   spreadRadius: 1,
                          //                   offset: Offset(0, 3.0))
                          //             ]),
                          //         child: Padding(
                          //           padding: EdgeInsets.only(
                          //               top: 28.0, left: 20.0, right: 16.0),
                          //           child: LineGraph(
                          //             features: features,
                          //             size: Size(340, 200),
                          //             labelX: labelX,
                          //             labelY: [
                          //               '0%',
                          //               '25%',
                          //               '50%',
                          //               '75%',
                          //               '100%'
                          //             ],
                          //             showDescription: false,
                          //             graphColor: kOrangeColor,
                          //             graphOpacity: 0.2,
                          //             verticalFeatureDirection: false,
                          //             fontFamily: 'Epilogue',
                          //           ),
                          //         )),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: 30.0,
                          // ),
                          if (imageList.length > 0)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Text(
                                    'Mood Chart',
                                    style: kInputHeaderTextStyle,
                                  ),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade300,
                                              blurRadius: 1,
                                              spreadRadius: 1,
                                              offset: Offset(0, 3.0))
                                        ]),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 20.0),
                                      child: PieChart(
                                        dataMap: dataMap,
                                        animationDuration:
                                            Duration(milliseconds: 800),
                                        chartRadius:
                                            MediaQuery.of(context).size.width /
                                                3.2,
                                        colorList: colorList,
                                        initialAngleInDegree: 0,
                                        legendOptions: LegendOptions(
                                          showLegendsInRow: false,
                                          legendPosition: LegendPosition.right,
                                          showLegends: true,
                                          legendShape: BoxShape.circle,
                                        ),
                                        chartValuesOptions: ChartValuesOptions(
                                          showChartValueBackground: false,
                                          showChartValues: true,
                                          showChartValuesInPercentage: true,
                                          showChartValuesOutside: false,
                                          decimalPlaces: 0,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          if (imageList.length > 0)
                            SizedBox(
                              height: 30.0,
                            ),
                          ElevatedButton(
                              style: kOrangeButtonStyle,
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    ConsultationScreen.id,
                                    (Route<dynamic> route) => false);
                              },
                              child: Text('Back to Consultation Page')),
                          SizedBox(
                            height: 10.0,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballClipRotate,
                    colors: [kOrangeColor],
                    strokeWidth: 5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    'The report might takes a few minutes to be generated.',
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
      bottomNavigationBar: BottomNavbar(selectedIndex: 1),
    );
  }
}

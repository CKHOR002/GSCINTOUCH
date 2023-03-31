// ignore_for_file: prefer_const_constructors

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/firstaider-bottom_navbar.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_a.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_d.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_end.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_i.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../classes/pfa-api2.dart';
import '../../database/crud_functions/updateprogresstable.dart';
import '../../database/schemas/user_answer.dart';
import 'pfa_lesson/pfa_p.dart';

class RValidation extends StatefulWidget {
  const RValidation({Key? key, required this.courseListID, required this.index})
      : super(key: key);
  final String? courseListID;
  final int index;
  static const String id = 'RValidation';

  @override
  State<RValidation> createState() => _RValidationState();
}

class _RValidationState extends State<RValidation> {
  bool isValidate = false;

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    //_initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
        onStatus: (status) => print('onStatus:$status'),
        onError: (errorNotification) => print('onError: $errorNotification'),
        debugLogging: true);
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textarea = TextEditingController();
    return ChangeNotifierProvider(
        create: (context) => QuizzesRead(),
        builder: ((context, child) {
          return Scaffold(
            appBar: WhiteAppBar(),
            body: FutureBuilder(
                future: Provider.of<QuizzesRead>(context, listen: false)
                    .open(widget.courseListID),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Question1(
                                index: widget.index,
                                lastword: _lastWords,
                                textarea: textarea,
                                isValidate: isValidate,
                              ),
                              Column(
                                children: [
                                  Center(
                                    child: AvatarGlow(
                                      animate: _speechToText.isListening,
                                      endRadius: 60.0,
                                      glowColor: Theme.of(context).primaryColor,
                                      duration:
                                          const Duration(milliseconds: 2000),
                                      repeatPauseDuration:
                                          const Duration(milliseconds: 100),
                                      repeat: true,
                                      child: GestureDetector(
                                        // backgroundColor: Color(0xFFFE8235),
                                        // onLongPress:
                                        //     _speechToText.isNotListening
                                        //         ? _startListening
                                        //         : _stopListening,
                                        onLongPressStart: (details) {
                                          _startListening();
                                        },
                                        onLongPressEnd: (details) {
                                          _stopListening();
                                        },
                                        child: FloatingActionButton(
                                          backgroundColor: Color(0xFFFE8235),
                                          onPressed: () {},
                                          child: Icon(
                                            _speechToText.isNotListening
                                                ? Icons.mic_off
                                                : Icons.mic,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'Hold To Speak',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      Provider.of<QuizzesRead>(context,
                                              listen: false)
                                          .apiResponseText
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Provider.of<QuizzesRead>(
                                                      context,
                                                      listen: false)
                                                  .isAccepted
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  (Provider.of<QuizzesRead>(context,
                                                  listen: true)
                                              .isAccepted ==
                                          true)
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0),
                                          child: Align(
                                              alignment: Alignment.topRight,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  if (!(Provider.of<
                                                                  QuizzesRead>(
                                                              context,
                                                              listen: false)
                                                          .progress! >
                                                      widget.index - 1)) {
                                                    await updateProgress(
                                                        widget.index);
                                                  }
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.pop(context);

                                                  switch (widget.index) {
                                                    case 3:
                                                      // ignore: use_build_context_synchronously
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              PFA_A(),
                                                        ),
                                                      );
                                                      break;

                                                    case 5:
                                                      // ignore: use_build_context_synchronously
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              PFA_P(),
                                                        ),
                                                      );
                                                      break;

                                                    case 7:
                                                      // ignore: use_build_context_synchronously
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              PFA_I(),
                                                        ),
                                                      );
                                                      break;

                                                    case 9:
                                                      // ignore: use_build_context_synchronously
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              PFA_D(),
                                                        ),
                                                      );
                                                      break;

                                                    default:
                                                      // ignore: use_build_context_synchronously
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              PFA_End(),
                                                        ),
                                                      );
                                                      break;
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color(0xFFFE8235),
                                                ),
                                                child: Text("Next"),
                                              )),
                                        )
                                      : SizedBox(
                                          height: 0,
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Provider.of<QuizzesRead>(context, listen: true)
                                .isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : SizedBox()
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })),
            bottomNavigationBar: BottomNavbar(selectedIndex: 1),
          );
        }));
  }
}

class Question1 extends StatelessWidget {
  const Question1({
    Key? key,
    required this.textarea,
    required this.isValidate,
    required this.lastword,
    required this.index,
  }) : super(key: key);

  final TextEditingController textarea;
  final bool isValidate;
  final String lastword;
  final int index;

  @override
  Widget build(BuildContext context) {
    textarea.text = lastword == ''
        ? Provider.of<QuizzesRead>(context, listen: false).answer.toString()
        : lastword;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 40, 16),
            child: Text(
              'Senario:\n${Provider.of<QuizzesRead>(context, listen: false).senario}',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16),
              child: TextField(
                controller: textarea,
                keyboardType: TextInputType.multiline,
                maxLines: 9,
                decoration: InputDecoration(
                  hintText: "....",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xFFCFCBCB),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xFFCFCBCB),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SubmitButton(textarea: textarea, index: index),
      ],
    );
  }
}

class SubmitButton extends StatefulWidget {
  const SubmitButton({
    Key? key,
    required this.textarea,
    required this.index,
  }) : super(key: key);
  final TextEditingController textarea;
  final int index;

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Align(
        alignment: Alignment.topRight,
        child: ElevatedButton(
          onPressed: () async {
            final userInput = widget.textarea.text;
            final db = FirebaseFirestore.instance;
            final apiResponse =
                await Provider.of<QuizzesRead>(context, listen: false)
                    .apiResponse(
              userInput,
              Provider.of<QuizzesRead>(context, listen: false).senario,
            );
            final quizID =
                // ignore: use_build_context_synchronously
                Provider.of<QuizzesRead>(context, listen: false).quizID;

            final userQuizAnswerList = await db
                .collection("user-answer")
                .where('userid',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where('quizid', isEqualTo: quizID)
                .withConverter(
                  fromFirestore: UserQuizAnswer.fromFirestore,
                  toFirestore: (UserQuizAnswer userQuizAnswer, _) =>
                      userQuizAnswer.toFirestore(),
                )
                .snapshots()
                .first;

            if (userQuizAnswerList.size == 0) {
              UserQuizAnswer newUserQuizAnswerData = UserQuizAnswer(
                  userid: FirebaseAuth.instance.currentUser!.uid,
                  answer: userInput,
                  isAccepted: false,
                  apiResponse: apiResponse,
                  quizid: quizID);

              final addNewUserQuizAnswer = db
                  .collection('user-answer')
                  .withConverter(
                    fromFirestore: UserQuizAnswer.fromFirestore,
                    toFirestore: (UserQuizAnswer userQuizAnswerData, options) =>
                        userQuizAnswerData.toFirestore(),
                  )
                  .doc();
              await addNewUserQuizAnswer
                  .set(newUserQuizAnswerData)
                  .then((value) {
                final id = Provider.of<QuizzesRead>(context, listen: false)
                    .courseListId;
                setState(() {
                  Provider.of<QuizzesRead>(context, listen: false).isLoading =
                      false;
                });
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RValidation(
                      courseListID: id,
                      index: widget.index,
                    ),
                  ),
                );
              });
            } else {
              final batch = db.batch();
              await db
                  .collection("user-answer")
                  .where('quizid', isEqualTo: quizID)
                  .where("userid",
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .get()
                  .then((snapshot) {
                String docid = snapshot.docs.first.id;

                final ref = db.collection("user-answer").doc(docid);
                batch.update(ref, {
                  'answer': userInput,
                  'apiResponse': apiResponse,
                  'isAccepted': apiResponse.contains('Yes') ? true : false
                });
                batch.commit().then((_) {
                  final id = Provider.of<QuizzesRead>(context, listen: false)
                      .courseListId;
                  setState(() {
                    Provider.of<QuizzesRead>(context, listen: false).isLoading =
                        false;
                  });
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RValidation(
                        courseListID: id,
                        index: widget.index,
                      ),
                    ),
                  );
                });
              });
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Color(0xFFFE8235),
          ),
          child: Text("Submit"),
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/firstaider-bottom_navbar.dart';
import 'package:intouch_imagine_cup/screens/first_aider/homepage.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../classes/pfa-api.dart';
import '../../database/crud_functions/updateprogresstable.dart';

class RValidation1 extends StatefulWidget {
  const RValidation1({Key? key}) : super(key: key);

  static const String id = 'RValidation1';

  @override
  State<RValidation1> createState() => _RValidation1State();
}

class _RValidation1State extends State<RValidation1> {
  bool isValidate = false;

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
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
        create: (context) => PFA1RequirementData(),
        builder: ((context, child) {
          return Scaffold(
            appBar: WhiteAppBar(),
            body: FutureBuilder(
                future: Provider.of<PFA1RequirementData>(context, listen: false)
                    .open(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Question1(
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
                                  duration: const Duration(milliseconds: 2000),
                                  repeatPauseDuration:
                                      const Duration(milliseconds: 100),
                                  repeat: true,
                                  child: FloatingActionButton(
                                    backgroundColor: Color(0xFFFE8235),
                                    onPressed: _speechToText.isNotListening
                                        ? _startListening
                                        : _stopListening,
                                    child: Icon(
                                      _speechToText.isNotListening
                                          ? Icons.mic_off
                                          : Icons.mic,
                                      size: 30,
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
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          RequirementField(),
                          (Provider.of<PFA1RequirementData>(context,
                                              listen: true)
                                          .requirement_1 ==
                                      true &&
                                  Provider.of<PFA1RequirementData>(context,
                                              listen: true)
                                          .requirement_2 ==
                                      true)
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0),
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (!(Provider.of<
                                                          PFA1RequirementData>(
                                                      context,
                                                      listen: false)
                                                  .progress! >
                                              2)) {
                                            await updateProgress(3);
                                            // ignore: use_build_context_synchronously
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FirstAiderHomePage(),
                                              ),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.deepOrange,
                                        ),
                                        child: Text("Done"),
                                      )),
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                        ],
                      ),
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

class RequirementField extends StatelessWidget {
  const RequirementField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          SizedBox(
            height: 20,
          ),
          PFARequirement(
              requirementText: 'Consists of self introduction',
              isValidate:
                  Provider.of<PFA1RequirementData>(context).requirement_1!),
          PFARequirement(
              requirementText: 'A statement of your purpose',
              isValidate:
                  Provider.of<PFA1RequirementData>(context).requirement_2!),
        ],
      ),
    );
  }
}

class PFARequirement extends StatelessWidget {
  const PFARequirement(
      {Key? key, required this.requirementText, required this.isValidate})
      : super(key: key);
  final String requirementText;
  final bool isValidate;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(
          image:
              AssetImage(isValidate ? 'images/tick.png' : 'images/close.png'),
          width: 40,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          requirementText,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        )
      ],
    );
  }
}

class Question1 extends StatelessWidget {
  const Question1({
    Key? key,
    required this.textarea,
    required this.isValidate,
    required this.lastword,
  }) : super(key: key);

  final TextEditingController textarea;
  final bool isValidate;
  final String lastword;

  @override
  Widget build(BuildContext context) {
    textarea.text = lastword == ''
        ? Provider.of<PFA1RequirementData>(context, listen: false)
            .answer
            .toString()
        : lastword;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: Text(
            '1)	How to begin in establishing rapport?',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
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
        SubmitButton(textarea: textarea),
      ],
    );
  }
}

class SubmitButton extends StatefulWidget {
  const SubmitButton({
    Key? key,
    required this.textarea,
  }) : super(key: key);
  final TextEditingController textarea;

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
            Provider.of<PFA1RequirementData>(context, listen: false)
                .validation(widget.textarea.text);

            await Future.delayed(Duration(seconds: 4));
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RValidation1(),
              ),
            );
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

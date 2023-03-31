// ignore_for_file: prefer_const_constructors
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/firstaider-bottom_navbar.dart';

class SkillValidationPage extends StatefulWidget {
  const SkillValidationPage({Key? key}) : super(key: key);

  static const String id = 'SkillValidation';

  @override
  State<SkillValidationPage> createState() => _SkillValidationPageState();
}

class _SkillValidationPageState extends State<SkillValidationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WhiteAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20),
              child: Text(
                'What should you do to help Alice ?',
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            QuestionField(),
            Column(
              children: [
                Center(
                  child: AvatarGlow(
                    animate: true,
                    endRadius: 60.0,
                    glowColor: Theme.of(context).primaryColor,
                    duration: const Duration(milliseconds: 2000),
                    repeatPauseDuration: const Duration(milliseconds: 100),
                    repeat: true,
                    child: FloatingActionButton(
                      backgroundColor: Color(0xFFFE8235),
                      child: Icon(
                        Icons.mic_none,
                        size: 30,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Hold To Speak',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                )
              ],
            ),
            RequirementList()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavbar(selectedIndex: 1),
    );
  }
}

class QuestionField extends StatelessWidget {
  const QuestionField({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController textarea = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: Text(
            'Write out how you talk to Alice.',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16),
          child: TextField(
            controller: textarea,
            keyboardType: TextInputType.multiline,
            maxLines: 9,
            decoration: InputDecoration(
                hintText: "....",
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xFFCFCBCB))),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1, color: Color(0xFFCFCBCB)))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Align(
            alignment: Alignment.topRight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFE8235),
              ),
              child: Text("Submit"),
            ),
          ),
        ),
      ],
    );
  }
}

class HoldToSpeakButton extends StatelessWidget {
  const HoldToSpeakButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: AvatarGlow(
            animate: true,
            endRadius: 60.0,
            glowColor: Theme.of(context).primaryColor,
            duration: const Duration(milliseconds: 2000),
            repeatPauseDuration: const Duration(milliseconds: 100),
            repeat: true,
            child: FloatingActionButton(
              backgroundColor: Color(0xFFFE8235),
              child: Icon(
                Icons.mic_none,
                size: 30,
              ),
              onPressed: () {},
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          'Hold To Speak',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}

class RequirementList extends StatelessWidget {
  const RequirementList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Image(
                image: AssetImage('images/tick.png'),
                width: 40,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'Show your care',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              )
            ],
          ),
          Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Image(
                image: AssetImage('images/tick.png'),
                width: 40,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'Ask the right question',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              )
            ],
          ),
          Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Image(
                image: AssetImage('images/close.png'),
                width: 40,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'Think about her',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              )
            ],
          ),
        ],
      ),
    );
  }
}

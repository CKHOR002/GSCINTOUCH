import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/firstaider-bottom_navbar.dart';
import 'package:intouch_imagine_cup/screens/first_aider/skill_validation.dart';

class RValidation2 extends StatefulWidget {
  const RValidation2({Key? key}) : super(key: key);

  static const String id = 'RValidation2';

  @override
  State<RValidation2> createState() => _RValidation2State();
}

class _RValidation2State extends State<RValidation2> {
  @override
  Widget build(BuildContext context) {
    TextEditingController textarea = TextEditingController();
    return Scaffold(
      appBar: WhiteAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            R_question_2(textarea: textarea),
            HoldToSpeakButton(),
            R_requirement_2(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavbar(selectedIndex: 1),
    );
  }
}

class R_requirement_2 extends StatelessWidget {
  const R_requirement_2({
    Key? key,
  }) : super(key: key);

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
                'Used encouraging words',
                // for eg.“alright, okay, uh-huh, hmm, yeah, I see, and really”
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
                'Restatement applied',
                // capture words that are closely related to the scenario given in the question
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class R_question_2 extends StatelessWidget {
  const R_question_2({
    Key? key,
    required this.textarea,
  }) : super(key: key);

  final TextEditingController textarea;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: Text(
            //insert a scenario
            '2) Imagine Bob is sharing his/her worries to you: '
            '\"Recently I failed my final exam even though I have put in a lot of effort. I have been very hard working and studying the whole time but things do not seem to work out\". '
            'Make use of reflective listening skills in your reply.',
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
                        borderSide:
                            BorderSide(width: 1, color: Color(0xFFCFCBCB))),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xFFCFCBCB)))),
              ),
            ),
          ],
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

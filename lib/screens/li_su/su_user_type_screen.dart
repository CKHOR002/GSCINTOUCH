import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:intouch_imagine_cup/screens/li_su/sign_up_screen.dart';

class SuUserTypeScreen extends StatefulWidget {
  const SuUserTypeScreen({Key? key}) : super(key: key);

  static const String id = 'user_type';

  @override
  State<SuUserTypeScreen> createState() => _SuUserTypeScreenState();
}

class _SuUserTypeScreenState extends State<SuUserTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightOrangeColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Join Now',
                    style: kIntouchTitleTextStyle,
                  ),
                  SizedBox(
                    height: 70.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SignUpScreen.id,
                          arguments: 'User');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 58.0, vertical: 21.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 1,
                            spreadRadius: 1,
                            offset: Offset(0, 3.0),
                          )
                        ],
                      ),
                      child: Text(
                        'I need assistance',
                        style: kInputHeaderTextStyle,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SignUpScreen.id,
                          arguments: 'First Aider');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 53.0, vertical: 21.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 1,
                            spreadRadius: 1,
                            offset: Offset(0, 3.0),
                          )
                        ],
                      ),
                      child: Text(
                        'I\'d like to volunteer',
                        style: kInputHeaderTextStyle,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 145.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

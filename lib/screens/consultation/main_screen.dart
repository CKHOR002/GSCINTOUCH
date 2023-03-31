// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:provider/provider.dart';

import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/bottom_navbar.dart';
import 'package:intouch_imagine_cup/components/select_first_aider_dialog.dart';
import 'package:intouch_imagine_cup/screens/consultation/consultation_option_screen.dart';

import 'package:intouch_imagine_cup/classes/user.dart';
import 'package:intouch_imagine_cup/classes/consultation_data.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({Key? key}) : super(key: key);

  static const String id = 'consultation';

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  User? selectedUser = null;

  @override
  void initState() {
    super.initState();
    Provider.of<ConsultationData>(context, listen: false)
        .removeSelectedFirstAider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WhiteAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 44.0),
              child: Text(
                'Share Your Thoughts',
                style: kTitleTextStyle,
              ),
            ),
          ),
          SizedBox(
            height: 60.0,
          ),
          Flexible(
            child: Image(
              image: AssetImage('images/consultation_main_page.png'),
            ),
          ),
          SizedBox(
            height: 60.0,
          ),
          ElevatedButton(
            style: kOrangeButtonStyle,
            onPressed: () {
              Navigator.pushNamed(context, ConsultationOptionScreen.id);
            },
            child: Text(
              'Start Consulting',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (Provider.of<ConsultationData>(context).selectedFirstAider ==
                  null)
                Text(
                  'Know someone?',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                )
              else
                Text(
                  'Selected ${Provider.of<ConsultationData>(context).selectedFirstAider!.name}!',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return SelectFirstAiderDialog();
                      });
                },
                child: Text(
                  Provider.of<ConsultationData>(context).selectedFirstAider !=
                          null
                      ? 'Change here'
                      : 'Choose here',
                  style: TextStyle(
                    color: kOrangeColor,
                    fontSize: 12.0,
                  ),
                ),
              )
            ],
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.pushNamed(context, NewMoodAnalysis.id);
          //   },
          //   child: Text('Go to mood analysis page'),
          // ),
          // ElevatedButton(
          //   onPressed: () {
          //     showDialog(
          //         context: context,
          //         builder: (context) {
          //           return ReportDialog(
          //             firstAiderID: '',
          //           );
          //         });
          //   },
          //   child: Text('Show report dialog'),
          // ),
        ],
      ),
      bottomNavigationBar: BottomNavbar(selectedIndex: 1),
    );
  }
}

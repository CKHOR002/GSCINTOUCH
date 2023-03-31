// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/firstaider-bottom_navbar.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_r.dart';
import 'package:provider/provider.dart';

import '../../../classes/pfadatabase.dart';
import '../../../database/crud_functions/updateprogresstable.dart';

class PFAOverview extends StatefulWidget {
  const PFAOverview({Key? key}) : super(key: key);
  static const String id = 'PFAOverview';

  @override
  State<PFAOverview> createState() => _PFAOverviewState();
}

class _PFAOverviewState extends State<PFAOverview> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: ((context) => PFADatabaseProvider()),
        builder: ((context, child) => Scaffold(
              appBar: WhiteAppBar(),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, //?
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
                        child: Text(
                          'Overview',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Expanded(
                              child: Text(
                                'Perhaps the best way to conceptualize PFA is as the mental health analogue to physical first aid. PFA may be simply defined as a supportive an '
                                'compassionate presence designed to stabilize and mitigate acute distress, as well as facilitate access to continued care. PFA does not entail diagnosis, nor does it entail treatment. PFA is a tactical variation within the 100-year-old field of psychological crisis intervention.'
                                '\n '
                                '\nIn this course, we describe the Johns Hopkins RAPID PFA model.'
                                '\n'
                                '\nR—Rapport and reflective listening. Effective psychological crisis intervention is predicated on gaining rapport with the person in distress. Consider rapport as a form of interpersonal connectedness that serves as a platform for the remaining aspects of the model.'
                                '\n'
                                '\nA—Assessment. The term assessment is used liberally here and consists of screening (Is there any evidence of need for PFA or other types of intervention?) and appraisal (What is the severity or gravity of need?). This information is generated, not through the use of psychological tests or mental status examinations, but, rather, through the process of listening to the person’s story of distress. The story consists of what happened (the stressor event) and the person’s reactions (signs and symptoms) in response to the event.'
                                '\n'
                                '\nP—Prioritization. Having heard the story, you must determine how urgent the need is for intervention. This becomes an exercise in psychological triage'
                                '\n'
                                '\nI—Intervention. Having heard the story and the associated reactions, some efforts toward stabilization and mitigation of adverse reactions is often recommended, if not expected. We shall review numerous practical crisis intervention techniques you can use.'
                                '\n'
                                '\nD—Disposition. Having heard the story and responded with an appropriate intervention, you now must determine what to do next. \“Where do we go from here?\” is a question you should ask yourself and might even ask the person you’ve assisted. Most behavioral outcomes are recovery or referral. We shall delineate guidelines for both.'
                                '\n'
                                '\nWe will begin with R in detail in the next lesson.'
                                '\n'
                                '\nMaterials are all obtained from \"THE JOHNS HOPKINS GUIDE TO PSYCHOLOGICAL FIRST AIRDE\"',
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: FutureBuilder(
                            future: Provider.of<PFADatabaseProvider>(context,
                                    listen: false)
                                .open(),
                            builder: ((context, snapshot) {
                              if (snapshot.hasData) {
                                return ElevatedButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PFA_R(),
                                      ),
                                    );
                                    if (!(Provider.of<PFADatabaseProvider>(
                                                context,
                                                listen: false)
                                            .progress! >
                                        0)) {
                                      await updateProgress(1);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFFE8235),
                                  ),
                                  child: Text("Next"),
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: BottomNavbar(selectedIndex: 1),
            )));
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/firstaider-bottom_navbar.dart';
import 'package:intouch_imagine_cup/screens/first_aider/course-list.dart';
import 'package:intouch_imagine_cup/screens/first_aider/r_validation_1.dart';
import 'package:provider/provider.dart';

import '../../../classes/pfadatabase.dart';
import '../../../database/crud_functions/updateprogresstable.dart';

class PFA_End extends StatefulWidget {
  const PFA_End({Key? key}) : super(key: key);
  static const String id = 'PFA_End';

  @override
  State<PFA_End> createState() => _PFA_EndState();
}

class _PFA_EndState extends State<PFA_End> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: ((context) => PFADatabaseProvider()),
        builder: ((context, child) {
          return Scaffold(
            appBar: WhiteAppBar(),
            body: FutureBuilder(
                future: Provider.of<PFADatabaseProvider>(context, listen: false)
                    .open(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, //?
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
                              child: Text(
                                'Self-Care: Taking Care of Others Begins (and Ends) with Taking Care of Yourself',
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Expanded(
                                    child: Text(
                                      'THE NEED FOR SELF-CARE',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Expanded(
                                    child: Text(
                                      'So, you’ve completed the Johns Hopkins RAPID PFA model intervention. If all goes well, you deserve to reflect, if not bask, fondly on a job well done. You were present, you developed rapport through empathy and reflective listening, you assessed thoroughly, you prioritized the relevance of the signs and symptoms you heard, you provided successful cognitive and stress management interventions, and you ended by leaving the person in a very good emotional place with referral and contact information if needed . . . You were the consummate helper'
                                      '\n'
                                      '\n'
                                      'What about you? Even if all goes well, and even if you’re successful in the majority of your future interventions, listening to others tell their traumatic experiences can take an emotional toll on you over time. No matter how wellintentioned you are, and no matter how resilient you envision yourself to be, repeated exposure to traumatic events, even if it’s only for short periods of time, can adversely affect you. You can’t help at times but absorb some of the sadness, picture the stories, and be affected by the hardship that you hear. You are not immune.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Expanded(
                                    child: Text(
                                      'SELF-CARE',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Self-care is a personal endeavor that will likely change over time. The suggestions that follow are not meant to be prescriptive or exhaustive. The important caveat to remember is that self-care is meant to be an enjoyable way to remove you from the pressures, challenges, and burdens of not only responding to a critical incident but of reacting to the daily stresses associated with your personal and professional life. Practicing self-care is not meant to be an additional obligation or another source of stress in your life. It is meant to create a balance. With this in mind, consider some of the following, many of which will enhance behavioral or spiritual well-being:'
                                      '\n'
                                      '\n'
                                      '• Take a quiet, relaxing walk'
                                      '\n'
                                      '• Write in a journal'
                                      '\n'
                                      '• Listen to music'
                                      '\n'
                                      '• Find opportunities to laugh'
                                      '\n'
                                      '• Take a bath instead of a quick shower'
                                      '\n'
                                      '• Connect with a friend via telephone or e-mail'
                                      '\n'
                                      '• Cultivate a hobby'
                                      '\n'
                                      '• Spend time outdoors'
                                      '\n'
                                      '• Play with your children'
                                      '\n'
                                      '• Take your vacation time'
                                      '\n'
                                      '• Manage your time better to schedule interruptions and breaks'
                                      '\n'
                                      '• Take time for reflection'
                                      '\n'
                                      '• Sleep in when you can'
                                      '\n'
                                      '• Maintain clear personal and professional boundaries',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Expanded(
                                    child: Text(
                                      'DEVELOPING A PLAN',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Expanded(
                                    child: Text(
                                      'That which is not planned does not get done! So be sure to make a plan for self-care. Consider using the following structure for prolonged service in the field (although these basic principles can be useful on short call-outs for service in the field as well): '
                                      '\n'
                                      '\n'
                                      '\n'
                                      '1. Preactivation/Deployment'
                                      '\n'
                                      '\n'
                                      'a. Establish a reliable means of communicating with family/friends,coworkers, supervisors.'
                                      '\n'
                                      '\n'
                                      'b. Identify transportation resources to and from the work site.'
                                      '\n'
                                      '\n'
                                      'c. If possible, anticipate and prepare for the situation in which you will be working.'
                                      '\n'
                                      '\n'
                                      '• What will be the physical challenges?'
                                      '\n'
                                      '• What will be the psychological challenges?'
                                      '\n'
                                      '• Will there be any cultural or communication challenges?'
                                      '\n'
                                      '• What will be the policy and means for referring those who needcustodial care?'
                                      '\n'
                                      '\n'
                                      '\n'
                                      '2. During Field Service'
                                      '\n'
                                      '\n'
                                      'a. Identify transportation resources.'
                                      '\n'
                                      '\n'
                                      'b. Identify any organizational or local resources for staff support, daily as well as extraordinary.'
                                      '\n'
                                      '\n'
                                      'c. Can you create a buddy system?'
                                      '\n'
                                      '\n'
                                      'd. Monitor your daily stress levels.'
                                      '\n'
                                      '\n'
                                      'e. Identify resources for stress management (e.g., spiritual, physical exercise, hobbies).'
                                      '\n'
                                      '\n'
                                      'f. Communicate with friends/family back home.'
                                      '\n'
                                      '\n'
                                      'g. Stay informed on hometown news.'
                                      '\n'
                                      '\n'
                                      'h. Keep a daily journal.'
                                      '\n'
                                      '\n'
                                      'i. Establish routines, especially someone to eat breakfast or dinner with on a regular basis.'
                                      '\n'
                                      '\n'
                                      '\n'
                                      '3. After Field Service (transitioning back home)'
                                      '\n'
                                      '\n'
                                      'a. Informally communicate your experiences.'
                                      '\n'
                                      '\n'
                                      'b. Use stress management techniques.'
                                      '\n'
                                      '\n'
                                      'c. Write a “lessons learned” summary of your experience.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //edit navigator
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CourseListPage(),
                                      ),
                                    );
                                    if (!(Provider.of<PFADatabaseProvider>(
                                                context,
                                                listen: false)
                                            .progress! >
                                        11)) {
                                      await updateProgress(12);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFFE8235),
                                  ),
                                  child: Text("Finish"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                })),
            bottomNavigationBar: BottomNavbar(selectedIndex: 1),
          );
        }));
  }
}

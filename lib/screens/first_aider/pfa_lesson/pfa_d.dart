// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/firstaider-bottom_navbar.dart';
import 'package:intouch_imagine_cup/screens/first_aider/d_validation.dart';
import 'package:provider/provider.dart';

import '../../../classes/pfadatabase.dart';
import '../../../database/crud_functions/updateprogresstable.dart';
import '../r_validation.dart';

class PFA_D extends StatefulWidget {
  const PFA_D({Key? key}) : super(key: key);
  static const String id = 'PFA_D';

  @override
  State<PFA_D> createState() => _PFA_DState();
}

class _PFA_DState extends State<PFA_D> {
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
                                'D—Disposition and Facilitating Access to Continued Care',
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
                                      'WHERE DO WE GO FROM HERE?',
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
                                      'The disposition phase follows the intervention phase wherein you employed various acute state-dependent mechanisms of action in an attempt to mitigate acute distress and dysfunction, not cure the problem!'
                                      '\n'
                                      '\n'
                                      'After your intervention, if the person seems more capable of taking care of herself or capable of discharging her responsibilities, then your intervention has ended. It is then recommended that you follow-up with the person at a time deemed most appropriate. Sometimes a second follow-up may be useful. However, if a third follow-up seems indicated, it’s probably time to facilitate access to another level of care.'
                                      '\n'
                                      '\n'
                                      'After your intervention, if the person seems more capable of taking care of himself and capable of discharging his responsibilities, but some form of informal support (friends, family, coworkers) would be helpful you can then serve to connect the person with those resources. Once again a follow-up may be useful.'
                                      '\n'
                                      '\n'
                                      'After your intervention, if it is determined that the person cannot function independently or requires significant and more formalized support from others (psychological, medical, logistical, financial, spiritual), then facilitate access to further support (referral), serving as a liaison or perhaps even an advocate for the person.',
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
                                      'ENCOURAGEMENT',
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
                                      'A big challenge associated with the disposition phase is encouraging people to seek further support. They are often hesitant because they might believe accepting further assistance is a sign of weakness or may be stigmatizing. At this point, it is often helpful to remind them that seeking further assistance may be a means of helping those who depend on them more than a form of direct assistance for them. Sometimes the timing is simply not right. Therefore, it may be advisable to follow up after a reasonable time and offer to facilitate access to continued care.',
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
                                        builder: (context) => RValidation(
                                          courseListID: 'DjXixauKyu68MU0XMtJO',
                                          index: 11,
                                        ),
                                      ),
                                    );
                                    if (!(Provider.of<PFADatabaseProvider>(
                                                context,
                                                listen: false)
                                            .progress! >
                                        9)) {
                                      await updateProgress(10);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFFE8235),
                                  ),
                                  child: Text("Next"),
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

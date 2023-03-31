// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/firstaider-bottom_navbar.dart';
import 'package:intouch_imagine_cup/screens/first_aider/a_validation.dart';
import 'package:provider/provider.dart';

import '../../../classes/pfadatabase.dart';
import '../../../database/crud_functions/updateprogresstable.dart';
import '../r_validation.dart';

class PFA_A extends StatefulWidget {
  const PFA_A({Key? key}) : super(key: key);
  static const String id = 'PFA_A';

  @override
  State<PFA_A> createState() => _PFA_AState();
}

class _PFA_AState extends State<PFA_A> {
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
                                'A—Assessment Listening to the Story',
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
                                      'ASSESSMENT OF BASIC PHYSICAL AND PSYCHOLOGICAL NEEDS',
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
                                      'Assessment encompasses two dynamic processes:(1) screening and (2) appraisal.',
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
                                      'SCREENING',
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
                                      'The first step in assessment entails screening. Screening consists of an attempt to answer prefatory, or qualifying, binary (yes-no) questions; for example, three key questions should be considered: '
                                      '\n'
                                      '\n'
                                      '1. Is there any evidence that this person needs assistance?'
                                      '\n'
                                      '2. Is there any evidence that this person’s ability to adaptively function and attend to her necessary responsibilities is being, or may be, compromised?'
                                      '\n'
                                      '3. Is further exploration into this person’s capacity for adaptive mental and behavioral functioning warranted? '
                                      '\n'
                                      '\n'
                                      'On the basis of an affirmative response to any of the three questions, you then progress to assessment.'
                                      '\n'
                                      '\n'
                                      'To assist in answering these three questions, you may draw inferences from the following domains: '
                                      '\n'
                                      '\n'
                                      '1. Integrity of physical health'
                                      '\n'
                                      '2. Physical safety'
                                      '\n'
                                      '3. Psychophysiological distress'
                                      '\n'
                                      '4. Cognitive and intellectual functioning'
                                      '\n'
                                      '5. Affective and behavioral expression'
                                      '\n'
                                      '6. Interpersonal resources'
                                      '\n'
                                      '7. Material resources',
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
                                      'APPRAISAL',
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
                                      'If the screening process indicates that additional inquiry is warranted, then you transition from binary screening to dimensional appraisal. Appraisal poses dimensional questions, for example: To what extent is there any evidence that this person needs assistance? or To what extent is there any evidence that this person’s ability to adaptively function and attend to his necessary responsibilities is being, or may be, compromised?'
                                      '\n'
                                      '\n'
                                      'Lists of potential signs, or indicia, of distress (significant but subimpairment stress arousal) and dysfunction (impaired stress arousal) follow. They are not comprehensive but, rather, list potential examples. They are divided into cognitive, emotional, behavioral, spiritual, and physiological indicia.',
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
                                          courseListID: 'EzJyMzznI3qXnSW3OrQE',
                                          index: 5,
                                        ),
                                      ),
                                    );
                                    if (!(Provider.of<PFADatabaseProvider>(
                                                context,
                                                listen: false)
                                            .progress! >
                                        3)) {
                                      await updateProgress(4);
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

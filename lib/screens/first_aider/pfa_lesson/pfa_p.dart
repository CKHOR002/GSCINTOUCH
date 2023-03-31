// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/firstaider-bottom_navbar.dart';
import 'package:intouch_imagine_cup/screens/first_aider/p_validation.dart';
import 'package:provider/provider.dart';

import '../../../classes/pfadatabase.dart';
import '../../../database/crud_functions/updateprogresstable.dart';
import '../r_validation.dart';

class PFA_P extends StatefulWidget {
  const PFA_P({Key? key}) : super(key: key);
  static const String id = 'PFA_P';

  @override
  State<PFA_P> createState() => _PFA_PState();
}

class _PFA_PState extends State<PFA_P> {
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
                                'P—Psychological Triage Prioritization',
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
                                      'TRAIGE',
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
                                      'In this chapter, we have delineated the nature and process of psychological triage as a constituent of the RAPID PFA model. We defined psychological triage as prioritizing attendance to people according to their relative urgency of need for PFA and psychosocial support.',
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
                                      'URGENCY!',
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
                                      'The specific criteria that determine urgency vary from person to person and situation to situation, but certain constants appear worth mentioning such as the following. Survivors with unmet needs (see list) or survivors who manifest posttraumatic illness/dysfunction would be considered as in need of urgent/higher-priority attention:'
                                      '\n'
                                      '\n'
                                      'a. Medical crises'
                                      '\n'
                                      '\n'
                                      '\n'
                                      'b. Maslovian physical needs (water, food, shelter)'
                                      '\n'
                                      '\n'
                                      '\n'
                                      'c. Safety'
                                      '\n'
                                      '\n'
                                      '\n'
                                      'd. Psychological/behavioral instability:'
                                      '\n'
                                      '\n'
                                      'i. Tendencies for behavioral impulsivity'
                                      '\n'
                                      '\n'
                                      'ii. Diminished cognitive capabilities (insight, recall, problem solving), but most important a diminished ability to understand the consequences of one’s actions'
                                      '\n'
                                      '\n'
                                      'iii. An acute loss of future orientation or a feeling of helplessness'
                                      '\n'
                                      '\n'
                                      '\n'
                                      'e. Predictors of posttraumatic illness/dysfunction:'
                                      '\n'
                                      '\n'
                                      'i. Severity (Intensity ×– Chronicity) of trauma exposure'
                                      '\n'
                                      '\n'
                                      'ii. Post-event-perceived guilt; negative appraisal of self'
                                      '\n'
                                      '\n'
                                      'iii. Peritraumatic dissociation'
                                      '\n'
                                      '\n'
                                      'iv. Peritraumatic depression'
                                      '\n'
                                      '\n'
                                      'v. Perceived life threat'
                                      '\n'
                                      '\n'
                                      'vi. Prior psychiatric history, especially acute stress disorder or posttraumatic stress disorder'
                                      '\n'
                                      '\n'
                                      'vii. Lack of perceived social support'
                                      '\n'
                                      '\n'
                                      'viii. Seeing human remains'
                                      '\n'
                                      '\n'
                                      'ix. Head injury (concussion, traumatic brain injury)',
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
                                            courseListID:
                                                'IvlBtfEyULrGT7fzB2HL',
                                            index: 7,
                                          ),
                                        ));
                                    if (!(Provider.of<PFADatabaseProvider>(
                                                context,
                                                listen: false)
                                            .progress! >
                                        5)) {
                                      await updateProgress(6);
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

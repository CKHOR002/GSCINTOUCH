// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/firstaider-bottom_navbar.dart';
import 'package:intouch_imagine_cup/screens/first_aider/i_validation.dart';
import 'package:provider/provider.dart';

import '../../../classes/pfadatabase.dart';
import '../../../database/crud_functions/updateprogresstable.dart';
import '../r_validation.dart';

class PFA_I extends StatefulWidget {
  const PFA_I({Key? key}) : super(key: key);
  static const String id = 'PFA_I';

  @override
  State<PFA_I> createState() => _PFA_IState();
}

class _PFA_IState extends State<PFA_I> {
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
                                'I—Intervention Tactics to Stabilize and Mitigate Acute Distress',
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
                                      'EXPLANATORY GUIDANCE',
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
                                      'People in distress often feel disempowered, even helpless. Thus, one of the best things you can do as a crisis interventionist is to empower them. One of the most effective ways to empower people is to give them information — knowledge about what happened to them, why it happened, and what reactions are common versus those that are not. This is called explanatory guidance.'
                                      '\n'
                                      '\n'
                                      'Some common questions a person may ask in the wake of a traumatic event or in the midst of a posttraumatic reaction are, “How did this happen?” Or “Why am I reacting this way?” “Why is this bothering me so much?” “What’s happening to me?” In the absence of credible external information, people answer their own questions. Their answers are sometimes wrong, or are far more negative, even catastrophic, than is reality. Anticipate these questions as you listen to the story in the assessment phase. Prepare to answer questions, if possible, before they are asked. When you do not know the answer, say so, but direct the person to sources that can assist them.',
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
                                      'ANTICIPATORY GUIDANCE',
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
                                      'Anticipatory guidance is making the person in crisis aware of possible psychological or physical stress reactions that may be experienced within the next few hours or days postincident. This form of mental preparation serves to set appropriate expectations, thus reducing the chance that someone might decompensate in reaction to a normal pattern of posttraumatic distress. So, for example, you might say to someone:'
                                      '\n'
                                      '\n'
                                      '“You might have some difficulty sleeping.”'
                                      '\n'
                                      '“Be aware that you may be more irritable than usual.”'
                                      '\n'
                                      '“It’s pretty common to replay this incident over and over in your mind.”',
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
                                      'COGNITIVE REFRAMING',
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
                                      'Cognitive reframing is a powerful tool for acute stabilization and mitigation. Just be careful not to argue with people. With time, they become more receptive to alternative interpretations of themselves and the critical incident. Consider using these types of cognitive reframes, or alterations, if they seem warranted based on assessment:'
                                      '\n'
                                      '\n'
                                      '• Correction of errors in fact.”'
                                      '\n'
                                      '• Disputing illogical thinking.'
                                      '\n'
                                      '• Challenging catastrophic (the worst will always happen) thinking.'
                                      '\n'
                                      '• Finding something positive.'
                                      '\n'
                                      '• Raise reasonable doubt.',
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
                                      'STRESS MANAGEMENT',
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
                                      'Below are some of the stress management: '
                                      '\n'
                                      '\n'
                                      '• Sleep'
                                      '\n'
                                      '• Nutrition'
                                      '\n'
                                      '• Relaxation techniques'
                                      '\n'
                                      '• Exercise',
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
                                                'r1x4HemwFq4RhWk0NIZ4',
                                            index: 9,
                                          ),
                                        ));
                                    if (!(Provider.of<PFADatabaseProvider>(
                                                context,
                                                listen: false)
                                            .progress! >
                                        7)) {
                                      await updateProgress(8);
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

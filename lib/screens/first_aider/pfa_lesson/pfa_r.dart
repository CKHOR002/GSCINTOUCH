// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/firstaider-bottom_navbar.dart';
import 'package:intouch_imagine_cup/screens/first_aider/r_validation_1.dart';
import 'package:provider/provider.dart';

import '../../../classes/pfadatabase.dart';
import '../../../database/crud_functions/updateprogresstable.dart';
import '../r_validation.dart';

class PFA_R extends StatefulWidget {
  const PFA_R({Key? key}) : super(key: key);
  static const String id = 'PFA_R';

  @override
  State<PFA_R> createState() => _PFA_RState();
}

class _PFA_RState extends State<PFA_R> {
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
                                'R—Rapport and Reflective Listening',
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
                                      'FIRST THINGS FIRST: THE PRACTICE OF PRESENCE',
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
                                      'Rapport begins with presence. Rapport is built on the perception of the present interventionist (i.e., having a physical and/or emotional presence) an is sometimes what the person in distress needs most. Many care providers have referred to this as a ministry of presence. Ministry does not refer to a religious presence but, rather, to caring attention for another person.'
                                      '\n'
                                      '\nDemonstrating equanimity, or the ability to emit calmness and display self-confidence under pressure, can be an important aspect of an effective ministry of presence',
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
                                      'THE EMPATHIC CASCADE: THE BRIDGE FROM RAPPORT TO ADHERENCE',
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
                                      'Establishing rapport often begins with an introduction of who you are and a statement of your purpose. For example, in a crisis situation, this might entail something like, \“I’m Jim from the local disaster relief team. I\’m here to listen and hopefully help you understand better the reactions you might be experiencing and to offer some suggestions that might help you better cope with this situation.\”',
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
                                      'REFLECTIVE LISTENING TECHNIQUES',
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
                                      'The most basic technique is to help those in distress to keep talking by using either nonlanguage words or simple, socially reinforcing or minimally encouraging words, such as uh-huh, hmm, yeah, I see, and really.'
                                      '\n'
                                      '\nAnother type of reflective listening technique is restatement. Restatements repeat back to the person in distress the words she used. Restatements often contain fewer words than what the person said and attempt to highlight the relevance of what the person said in a concrete and clear way. ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                            index: 3,
                                          ),
                                        ));
                                    if (!(Provider.of<PFADatabaseProvider>(
                                                context,
                                                listen: false)
                                            .progress! >
                                        1)) {
                                      await updateProgress(2);
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

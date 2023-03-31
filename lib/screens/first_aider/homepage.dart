// ignore_for_file: prefer_const_constructors, unnecessary_new
import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/classes/pfadatabase.dart';
import 'package:intouch_imagine_cup/components/firstaider-bottom_navbar.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_a.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_d.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_end.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_i.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_overview.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_p.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_r.dart';
import 'package:intouch_imagine_cup/screens/first_aider/r_validation.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../components/orange_appbar.dart';
import '../../constants.dart';
import 'consultation_request.dart';

class FirstAiderHomePage extends StatefulWidget {
  const FirstAiderHomePage({Key? key}) : super(key: key);

  static const String id = 'skill_validation';

  @override
  State<FirstAiderHomePage> createState() => _FirstAiderHomePageState();
}

class _FirstAiderHomePageState extends State<FirstAiderHomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PFADatabaseProvider(),
      builder: ((context, child) {
        return Scaffold(
          appBar: OrangeAppBar(),
          body: FutureBuilder(
            future:
                Provider.of<PFADatabaseProvider>(context, listen: false).open(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return Consumer<PFADatabaseProvider>(
                    builder: (context, database, _) {
                  return Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      //colors: [Color(0xFFFEF3E7), Colors.white])),
                      // ignore: prefer_const_literals_to_create_immutables
                      colors: [
                        Color(0xFFFEF3E7),
                        Color(0xFFFEF3E7),
                        Color(0xFFFEF3E7),
                        Color(0xFFFEF3E7),
                        Color(0xFFF9F9F9),
                        Color(0xFFF9F9F9),
                        Color(0xFFF9F9F9),
                        Color(0xFFF9F9F9),
                      ],
                    )),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                44.0, 44.0, 44.0, 20.0),
                            child: Text(
                              'Welcome back, Jack ! ',
                              style: kTitleTextStyle,
                            ),
                          ),
                          HomepageStatCard(),
                          (Provider.of<PFADatabaseProvider>(context,
                                          listen: false)
                                      .progress ==
                                  12)
                              ? StatusBadget()
                              : SizedBox(height: 0),
                          (Provider.of<PFADatabaseProvider>(context,
                                          listen: false)
                                      .progress ==
                                  12)
                              ? RevisitCourseDetail()
                              : CourseProgressDetail(),
                          (Provider.of<PFADatabaseProvider>(context,
                                          listen: false)
                                      .progress ==
                                  12)
                              ? ConsultationFeatureUnlock()
                              : ConsultationFeature(),
                        ],
                      ),
                    ),
                  );
                });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
          ),
          bottomNavigationBar: BottomNavbar(
            selectedIndex: 0,
          ),
        );
      }),
    );
  }
}

class StatusBadget extends StatelessWidget {
  const StatusBadget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Image(
            image: AssetImage('images/statusbadge.png'),
            width: 80,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Certified Helper',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HomepageStatCard extends StatelessWidget {
  const HomepageStatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: SizedBox(
          width: 300,
          height: 65,
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      '0',
                      style: kNumberTextStyle,
                    ),
                    Text(
                      'Consultations',
                      style: kSubtitleTextStyle,
                    )
                  ],
                ),
              ),
              VerticalDivider(
                thickness: 1,
                endIndent: 10,
                indent: 10,
              ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      '0',
                      style: kNumberTextStyle,
                    ),
                    Text(
                      'Hours of consultation',
                      style: kSubtitleTextStyle,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseProgressDetail extends StatelessWidget {
  const CourseProgressDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PFADatabaseProvider>(builder: (context, database, _) {
      return Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Center(
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Color(0XFFB5B5B5)),
            ),
            child: SizedBox(
              width: 360,
              height: 120,
              child: Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  CourseIconwithBackground(),
                  Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            'Psychological First Aid',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 8, 0, 0),
                          child: Text(
                            '1 Lessons',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Color(0xFF828282),
                              fontSize: 10.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LinearPercentIndicator(
                                  width: 100.0,
                                  lineHeight: 8.0,
                                  percent: database.progress!.toDouble() / 12,
                                  progressColor: Color(0xFF2D9CDB),
                                  barRadius: const Radius.circular(16),
                                  trailing: new Text(
                                    "${(database.progress!.toDouble() / 12 * 100).toStringAsPrecision(4)}%",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text(
                                    'Overall Progress',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xFFFE8235),
                                  textStyle: const TextStyle(fontSize: 10),
                                ),
                                onPressed: () {
                                  switch (database.progress) {
                                    case 1:
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PFAOverview(),
                                        ),
                                      );
                                      break;
                                    case 2:
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PFA_R(),
                                        ),
                                      );
                                      break;
                                    case 3:
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RValidation(
                                            courseListID:
                                                'IvlBtfEyULrGT7fzB2HL',
                                            index: 3,
                                          ),
                                        ),
                                      );
                                      break;
                                    case 4:
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PFA_A(),
                                        ),
                                      );
                                      break;
                                    case 5:
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RValidation(
                                            courseListID:
                                                'EzJyMzznI3qXnSW3OrQE',
                                            index: 5,
                                          ),
                                        ),
                                      );
                                      break;
                                    case 6:
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PFA_P(),
                                        ),
                                      );
                                      break;
                                    case 7:
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RValidation(
                                            courseListID:
                                                'SrqcjPpC4x3MiDvep6O1',
                                            index: 7,
                                          ),
                                        ),
                                      );
                                      break;
                                    case 8:
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PFA_I(),
                                        ),
                                      );
                                      break;
                                    case 9:
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RValidation(
                                            courseListID:
                                                'DjXixauKyu68MU0XMtJO',
                                            index: 9,
                                          ),
                                        ),
                                      );
                                      break;
                                    case 10:
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PFA_D(),
                                        ),
                                      );
                                      break;
                                    case 11:
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RValidation(
                                            courseListID:
                                                'r1x4HemwFq4RhWk0NIZ4',
                                            index: 11,
                                          ),
                                        ),
                                      );
                                      break;
                                    default:
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PFA_End(),
                                        ),
                                      );
                                      break;
                                  }
                                },
                                child: const Text(
                                  'CONTINUE',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class CourseIconwithBackground extends StatelessWidget {
  const CourseIconwithBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        color: Color(0xFFFEF3E7),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Icon(
            Icons.assignment_outlined,
            color: Color(0xFFFE8235),
            size: 50,
          ),
        ),
      ),
    );
  }
}

class ConsultationFeature extends StatelessWidget {
  const ConsultationFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Features',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
          Card(
            color: Color(0xFFD9D9D9),
            child: SizedBox(
              width: 350,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.support_agent,
                        color: Color.fromARGB(255, 203, 197, 197),
                        size: 45,
                      ),
                    ),
                  ),
                  Text(
                    'Consultation',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Color.fromARGB(255, 203, 197, 197),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Image(
                    image: AssetImage('images/Stamp.png'),
                    width: 90,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.lock_outline,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConsultationFeatureUnlock extends StatelessWidget {
  const ConsultationFeatureUnlock({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConsultationRequestScreen(),
            ))
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Features',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            Card(
              color: Color(0xFFFAEED8),
              child: SizedBox(
                width: 350,
                height: 80,
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Icon(
                          Icons.support_agent,
                          color: Color(0xFFB5B5B5),
                          size: 45,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Consultation',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RevisitCourseDetail extends StatelessWidget {
  const RevisitCourseDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0XFFB5B5B5)),
        ),
        child: SizedBox(
          width: 360,
          height: 120,
          child: Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              CourseIconwithBackground(),
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        'Psychological First Aid',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 0, 0),
                      child: Text(
                        '1 Lessons',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Color(0xFF828282),
                          fontSize: 10.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 140,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xFFFE8235),
                              textStyle: const TextStyle(fontSize: 10),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PFAOverview()));
                            },
                            child: const Text(
                              'REVISIT',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

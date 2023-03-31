// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:intouch_imagine_cup/components/bottom_navbar.dart';
import 'package:intouch_imagine_cup/database/schemas/textdiary.dart';
import 'package:intouch_imagine_cup/screens/meditation/meditation_main_page.dart';
import 'package:intouch_imagine_cup/screens/video_diary/video_diary_main_page.dart';

import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';

class TargetUserMainPage extends StatefulWidget {
  const TargetUserMainPage({super.key});
  static const String id = 'TargetUserMainPage';

  @override
  State<TargetUserMainPage> createState() => _TargetUserMainPageState();
}

class _TargetUserMainPageState extends State<TargetUserMainPage> {
  List<Feature> features = [];
  List<String> labelX = [];

  void querySentimentValue() async {
    final db = FirebaseFirestore.instance;
    DateTime todayDate = DateTime.now();
    DateTime currentMonth = DateTime(todayDate.year, todayDate.month);
    List<double> data = [];
    List<TextDiaryEntryData> diaryList = [];

    final query = await db
        .collection('text_diary')
        .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('datetime', isGreaterThanOrEqualTo: currentMonth)
        .orderBy('datetime', descending: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((diary) {
        data.add(diary['sentimentScore'].toDouble() / 100);
        print(diary['date']);
        labelX.add('');
      });
    });

    if (data.length > 0) {
      print('state set');
      setState(() {
        features.add(Feature(data: data, color: kOrangeColor));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    querySentimentValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WhiteAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Container(
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
                      padding:
                          const EdgeInsets.fromLTRB(44.0, 44.0, 44.0, 20.0),
                      child: Text(
                        'Welcome back, Jack !',
                        style: kTitleTextStyle,
                      ),
                    ),
                    HomepageStatCard(),
                    MoodChart(
                      features: features,
                      labelX: labelX,
                    ),
                    Features(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavbar(selectedIndex: 0),
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
                      'Points',
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
                      'Rewards',
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

class MoodChart extends StatelessWidget {
  MoodChart({required this.features, required this.labelX, super.key});

  List<Feature> features;
  List<String> labelX;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Mood over Time',
              style: kInputHeaderTextStyle,
            ),
          ),
          Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 1,
                        spreadRadius: 1,
                        offset: Offset(0, 3.0))
                  ]),
              child: Padding(
                padding: EdgeInsets.only(top: 28.0, left: 20.0, right: 16.0),
                child: features.length == 0
                    ? SizedBox(
                        child: Center(child: Text('No data for graph')),
                        width: 340,
                        height: 200,
                      )
                    : LineGraph(
                        features: features,
                        size: Size(340, 200),
                        labelX: labelX,
                        labelY: ['0%', '25%', '50%', '75%', '100%'],
                        showDescription: false,
                        graphColor: kOrangeColor,
                        graphOpacity: 0.2,
                        verticalFeatureDirection: false,
                        fontFamily: 'Epilogue',
                      ),
              )),
        ],
      ),
    );
  }
}

class Features extends StatelessWidget {
  const Features({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50.0),
            child: Text(
              'Features',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // first button
              GestureDetector(
                onTap: () {
                  print("Video diary clicked");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoDiaryMainPage(),
                    ),
                  );
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Image(
                          image: AssetImage('images/video_diary.png'),
                          width: 100,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Video Diary',
                            style: kSubtitleTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                //meditation button
                onTap: () {
                  print('meditation clicked');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MeditationMainPage(),
                    ),
                  );
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Image(
                          image: AssetImage('images/meditation.jpg'),
                          width: 100,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Meditation',
                            style: kSubtitleTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

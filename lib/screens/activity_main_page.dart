import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:intouch_imagine_cup/components/bottom_navbar.dart';
import 'package:intouch_imagine_cup/screens/text_diary/text_diary_main_page.dart';
import 'package:intouch_imagine_cup/screens/video_diary/video_diary_main_page.dart';
import 'package:intouch_imagine_cup/screens/meditation/meditation_main_page.dart';
import 'package:intouch_imagine_cup/screens/drawing/drawing_main_page.dart';

class ActivityMainPage extends StatefulWidget {
  const ActivityMainPage({Key? key}) : super(key: key);
  static const String id = 'activityMainPage';

  @override
  State<ActivityMainPage> createState() => _ActivityMainPageState();
}

class _ActivityMainPageState extends State<ActivityMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WhiteAppBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 44.0, horizontal: 125.0),
            child: Text(
              'Activities',
              style: kTitleTextStyle,
              textAlign: TextAlign.center,
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
                //text diary button
                onTap: () {
                  print('text diary clicked');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TextDiaryMainPage(),
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
                      children: [
                        Image(
                          image: AssetImage('images/text_diary1.jpg'),
                          width: 100,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Text Diary',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              GestureDetector(
                //drawing button
                onTap: () {
                  print('drawing clicked');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DrawingMainPage(),
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
                      children: [
                        Image(
                          image: AssetImage('images/drawing.png'),
                          width: 100,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Drawing',
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
      bottomNavigationBar: BottomNavbar(selectedIndex: 2),
    );
  }
}

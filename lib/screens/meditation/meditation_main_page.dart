import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/bottom_navbar.dart';
import 'package:intouch_imagine_cup/screens/text_diary/text_diary_main_page.dart';
import 'package:intouch_imagine_cup/screens/meditation/focused.dart';
import 'package:intouch_imagine_cup/screens/meditation/mindfulness.dart';
import 'package:intouch_imagine_cup/screens/meditation/mantra.dart';
import 'package:intouch_imagine_cup/screens/meditation/spiritual.dart';


class MeditationMainPage extends StatefulWidget {
  const MeditationMainPage({Key? key}) : super(key: key);
  static const String id = 'MeditationMainPage';
  @override
  State<MeditationMainPage> createState() => _MeditationMainPageState();
}

class _MeditationMainPageState extends State<MeditationMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WhiteAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 40.0,
                ),
                child: Text(
                  'Meditation',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
              )
          ),
          SizedBox(
            height: 10.0,
          ),
          Image(
            image: AssetImage('images/meditation-icon.jpg'),
            width: 100,
          ),
          SizedBox(
            height: 10.0,
          ),
          SizedBox(
            width: 200,
            height: 70,
              child: Text('Guided meditations to build your daily practice',
                textAlign: TextAlign.center,)
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // first button
              GestureDetector(
                onTap: () {
                  print("Mindfulness clicked");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MindfulnessMainPage(),
                    ),
                  );
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: Container(
                    width: 150,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius:  BorderRadius.all(
                      Radius.circular(30),
                      ),
                      image: DecorationImage(
                        image: AssetImage('images/sun_rise.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child:
                      Container(
                        child: Text('Mindfullness'),
                      )
                  ),
                ),
              ),
              GestureDetector(
                //text diary button
                onTap: () {
                  print('Focused clicked');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FocusedMainPage(),
                    ),
                  );
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: Container(
                    width: 150,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius:  BorderRadius.all(
                        Radius.circular(30),
                      ),
                      image: DecorationImage(
                        image: AssetImage('images/sun_rise.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Text('Focused'),
                  ),
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                //meditation button
                onTap: () {
                  print('Spiritual clicked');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpiritualMainPage(),
                    ),
                  );
                },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Container(
                      width: 150,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius:  BorderRadius.all(
                          Radius.circular(30),
                        ),
                        image: DecorationImage(
                          image: AssetImage('images/sun_rise.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Text('Spiritual'),
                    ),
                  ),
                ),
              GestureDetector(
                //drawing button
                onTap: () {
                  print('Mantra clicked');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MantraMainPage(),
                    ),
                  );
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: Container(
                    width: 150,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius:  BorderRadius.all(
                        Radius.circular(30),
                      ),
                      image: DecorationImage(
                        image: AssetImage('images/sun_rise.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Text('Mantra'),
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
import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/bottom_navbar.dart';
import 'package:intouch_imagine_cup/screens/text_diary/text_diary_main_page.dart';

class MindfulnessMainPage extends StatefulWidget {
  const MindfulnessMainPage({Key? key}) : super(key: key);
  static const String id = 'MindfulnessMainPagenMainPage';
  @override
  State<MindfulnessMainPage> createState() => _MindfulnessMainPageState();
}

class _MindfulnessMainPageState extends State<MindfulnessMainPage> {

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: WhiteAppBar(),
      body: Column(

      ),
      bottomNavigationBar: BottomNavbar(selectedIndex: 2),
    );
  }
}
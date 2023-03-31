// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/screens/consultation/main_screen.dart';
import 'package:intouch_imagine_cup/screens/activity_main_page.dart';
import 'package:intouch_imagine_cup/screens/rewards/rewards_mainpage.dart';
import 'package:intouch_imagine_cup/screens/targetuser_mainpage.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({
    Key? key,
    required int selectedIndex,
  })  : _selectedIndex = selectedIndex,
        super(key: key);

  final int _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // ignore: prefer_const_literals_to_create_immutables
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Consultation',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.content_paste),
          label: 'Activity Tracker',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: 'My Wallet',
        )
      ],
      currentIndex: _selectedIndex,
      onTap: (val) {
        if (val == 0) {
          Navigator.pushNamedAndRemoveUntil(
              context, TargetUserMainPage.id, (Route<dynamic> route) => false);
        } else if (val == 1) {
          Navigator.pushNamedAndRemoveUntil(
              context, ConsultationScreen.id, (Route<dynamic> route) => false);
        } else if (val == 2) {
          Navigator.pushNamedAndRemoveUntil(
              context, ActivityMainPage.id, (Route<dynamic> route) => false);
        } else if (val == 3) {
          Navigator.pushNamedAndRemoveUntil(
              context, RewardsMainPage.id, (Route<dynamic> route) => false);
        }
      },
    );
  }
}

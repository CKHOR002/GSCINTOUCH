// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/screens/first_aider/homepage.dart';
import 'package:intouch_imagine_cup/screens/first_aider/course-list.dart';
import 'package:intouch_imagine_cup/screens/first_aider/consultation_request.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({
    Key? key,
    required int selectedIndex,
    bool? isCompleted,
  })  : _selectedIndex = selectedIndex,
        _isCompleted = isCompleted,
        super(key: key);

  final int _selectedIndex;
  final bool? _isCompleted;

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
          icon: Icon(Icons.book_rounded),
          label: 'Course',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Consultation',
        )
      ],
      currentIndex: _selectedIndex,
      onTap: (val) {
        if (val == 0) {
          Navigator.pushNamedAndRemoveUntil(
              context, FirstAiderHomePage.id, (Route<dynamic> route) => false);
        } else if (val == 1) {
          Navigator.pushNamedAndRemoveUntil(
              context, CourseListPage.id, (Route<dynamic> route) => false);
        } else {
          print(_isCompleted);
          if (_isCompleted == true) {
            Navigator.pushNamedAndRemoveUntil(context,
                ConsultationRequestScreen.id, (Route<dynamic> route) => false);
          }
        }
      },
    );
  }
}

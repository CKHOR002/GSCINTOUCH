import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/bottom_navbar.dart';

class DrawingMainPage extends StatefulWidget {
  const DrawingMainPage({Key? key}) : super(key: key);
  static const String id = 'DrawingMainPage';
  @override
  State<DrawingMainPage> createState() => _DrawingMainPageState();
}

class _DrawingMainPageState extends State<DrawingMainPage> {
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
                    'Lets Colour',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                )
            ),
            SizedBox(
              height: 15.0,
            ),
            Container(
              width: 350,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search for drawing",
                ),
              ),
            )
          ]
      ),
      bottomNavigationBar: BottomNavbar(selectedIndex: 1),
    );
  }
}
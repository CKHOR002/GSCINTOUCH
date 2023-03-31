import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/constants.dart';

class VideoAnalyticsButton extends StatefulWidget {
  @override
  _VideoAnalyticsState createState() => _VideoAnalyticsState();
}

class _VideoAnalyticsState extends State<VideoAnalyticsButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        color: kOrangeColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.bar_chart,
        color: Colors.white,
      ),
    );
  }
}
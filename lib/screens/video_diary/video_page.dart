import 'dart:async';
import 'dart:io';

import 'package:intouch_imagine_cup/constants.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

// Video Recording Main Page
import 'package:intouch_imagine_cup/screens/video_diary/video_recording.dart';


class RecordButton extends StatefulWidget {
  const RecordButton({Key? key}) : super(key:key);

  @override
  _RecordButtonState createState() => _RecordButtonState();
}

// Main Functionalities
class _RecordButtonState extends State<RecordButton> {
  @override
  Widget build(BuildContext context) {

    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        color: kOrangeColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {
          // Camera Page
          // permission();
          Navigator.push
            (context,CupertinoPageRoute
            (builder: (context) => FlutterCamera(color: kOrangeColor,)));
        },
        icon: Icon(
          Icons.videocam,
          color: Colors.white,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/bottom_navbar.dart';

// month-year-picker packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intouch_imagine_cup/screens/video_diary/video_play.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:intouch_imagine_cup/screens/video_diary/calendar_view.dart';


// video-recording packages
import 'package:intouch_imagine_cup/screens/video_diary/video_recording.dart';
import 'package:intouch_imagine_cup/screens/video_diary/video_upload.dart';
import 'package:intouch_imagine_cup/screens/video_diary/video_analytics.dart';
import 'package:intouch_imagine_cup/screens/video_diary/camera_page.dart';
import 'package:intouch_imagine_cup/screens/video_diary/video_page.dart';

class VideoDiaryMainPage extends StatefulWidget {
  const VideoDiaryMainPage({Key? key}) : super(key: key);
  static const String id = 'videoDiaryMainPage';
  @override
  State<VideoDiaryMainPage> createState() => _VideoDiaryMainPageState();
}


class _VideoDiaryMainPageState extends State<VideoDiaryMainPage> {
  DateTime? _selected;
  void _handleFileSelected(dynamic file) {
    // Handle the selected file here
    print('Selected file: ${file.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WhiteAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Padding(
            padding: EdgeInsets.only(
              top: 40.0,
            ),
            child: Text(
              'Video Diary',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
              )
            ),
          ),
          SizedBox(
              width: 200,
              height: 50,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: Text(
                  'Record down your daily wonderful and amazing memories',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12.0,
                  ),
                ),
              )
            ),
          SizedBox(
            height: 10.0,
          ),
          //TODO: Add a month_year_picker
          // SingleChildScrollView(
          //   child: DatePickerExample()
          // ),
          // SizedBox(
          //  height: 20.0,
          // ),
          Expanded
            (child: TableBasicsExample())
          ,
          SizedBox(
          height: 30.0,
          ),
          //TODO: Upload Videos, Record Video, Generate Video Highlights
          Positioned(
          bottom: 0,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:[
              UploadButton(onFileSelected: _handleFileSelected,),
              RecordButton(),
              VideoAnalyticsButton(),
            ]
          ),
          )
           ],
          ),
      bottomNavigationBar: BottomNavbar(selectedIndex: 1),
    );
  }
}



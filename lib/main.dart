// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intouch_imagine_cup/screens/consultation/new_mood_analysis.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intouch_imagine_cup/classes/room_data.dart';
import 'package:intouch_imagine_cup/screens/drawing/drawing_main_page.dart';
import 'package:intouch_imagine_cup/screens/video_diary/video_diary_main_page.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'classes/consultation_data.dart';
import 'package:intouch_imagine_cup/screens/first_aider/course-list.dart';
import 'package:intouch_imagine_cup/screens/first_aider/homepage.dart';
import 'package:intouch_imagine_cup/screens/first_aider/skill_validation.dart';
import 'screens/li_su/log_in_screen.dart';
import 'screens/li_su/sign_up_screen.dart';
import 'screens/li_su/su_user_type_screen.dart';
import 'screens/consultation/main_screen.dart';
import 'screens/consultation/consultation_option_screen.dart';
//import 'screens/consultation/zego_video_call.dart';
//import 'screens/consultation/videosdk.dart';
import 'package:intouch_imagine_cup/screens/text_diary/text_diary_main_page.dart';
import 'package:intouch_imagine_cup/screens/text_diary/text_diary_field.dart';
import 'package:intouch_imagine_cup/screens/activity_main_page.dart';
import 'screens/consultation/communication_service.dart';
import 'package:intouch_imagine_cup/screens/first_aider/r_validation_1.dart';
import 'package:intouch_imagine_cup/screens/first_aider/r_validation_2.dart';
import 'package:intouch_imagine_cup/screens/first_aider/a_validation.dart';
import 'package:intouch_imagine_cup/screens/first_aider/p_validation.dart';
import 'classes/current_user.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_overview.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_r.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_a.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_p.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_i.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_d.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_end.dart';
import 'package:intouch_imagine_cup/screens/targetuser_mainpage.dart';
import 'screens/consultation/meeting_screen.dart';
import 'screens/first_aider/consultation_request.dart';
import 'screens/meditation/meditation_main_page.dart';
import 'package:intouch_imagine_cup/screens/rewards/rewards_mainpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/consultation/100ms.dart';
import 'package:intouch_imagine_cup/screens/video_diary/view_diary.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env", mergeWith: {
    'TEST_VAR': '5',
  });
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // checkPermission();
  }

  Future<void> checkPermission() async {
    while ((await Permission.storage.isDenied)) {
      await Permission.storage.request();
    }
    while ((await Permission.camera.isDenied)) {
      await Permission.camera.request();
    }
    while ((await Permission.microphone.isDenied)) {
      await Permission.microphone.request();
    }
    while ((await Permission.bluetoothConnect.isDenied)) {
      await Permission.bluetoothConnect.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ConsultationData()),
        ChangeNotifierProvider(create: (context) => DatabaseProvider()),
        ChangeNotifierProvider(create: (context) => CurrentUser()),
        ChangeNotifierProvider(create: (context) => RoomData())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Epilogue',
          scaffoldBackgroundColor: Color(0xFFF9F9F9),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            centerTitle: true,
            foregroundColor: kOrangeColor,
            elevation: 0.00,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: kOrangeColor,
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11.0,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11.0,
              ),
              unselectedItemColor: kLightGreyColor),
        ),
        initialRoute: LogInScreen.id,
        routes: {
          ConsultationScreen.id: (context) => ConsultationScreen(),
          ConsultationOptionScreen.id: (context) => ConsultationOptionScreen(),
          LogInScreen.id: (context) => LogInScreen(),
          SignUpScreen.id: (context) => SignUpScreen(),
          SuUserTypeScreen.id: (context) => SuUserTypeScreen(),
          TextDiaryMainPage.id: (context) => TextDiaryMainPage(),
          VideoDiaryMainPage.id: (context) => VideoDiaryMainPage(),
          StoryScreen.id: (context) => StoryScreen(
                stories: [],
              ),
          MeditationMainPage.id: (context) => MeditationMainPage(),
          DrawingMainPage.id: (context) => DrawingMainPage(),
          RewardsMainPage.id: (context) => RewardsMainPage(),
          SkillValidationPage.id: (context) => SkillValidationPage(),
          CourseListPage.id: (context) => CourseListPage(),
          FirstAiderHomePage.id: (context) => FirstAiderHomePage(),
          TextDiaryField.id: (context) => TextDiaryField(),
          CommunicationService.id: (context) => CommunicationService(),
          ActivityMainPage.id: (context) => ActivityMainPage(),
          RValidation1.id: (context) => RValidation1(),
          RValidation2.id: (context) => RValidation2(),
          AValidation.id: (context) => AValidation(),
          PValidation.id: (context) => PValidation(),
          TargetUserMainPage.id: (context) => TargetUserMainPage(),
          //VideoSDKSample.id: (context) => VideoSDKSample(),
          //VideoUpload.id: (context) => VideoUpload(),
          PFAOverview.id: (context) => PFAOverview(),
          PFA_R.id: (context) => PFA_R(),
          PFA_A.id: (context) => PFA_A(),
          PFA_P.id: (context) => PFA_P(),
          PFA_I.id: (context) => PFA_I(),
          PFA_D.id: (context) => PFA_D(),
          PFA_End.id: (context) => PFA_End(),
          MeetingScreen.id: (context) => MeetingScreen(),
          ConsultationRequestScreen.id: (context) =>
              ConsultationRequestScreen(),
          MeetingPage.id: (context) => MeetingPage(),
          NewMoodAnalysis.id: (context) => NewMoodAnalysis(),
        },
      ),
    );
  }
}

//some comment

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intouch_imagine_cup/database/schemas/user.dart';
import '../../database/schemas/courseprogress.dart';
import 'log_in_screen.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  static const String id = 'signup';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  late String selectedUserType;
  static const platform =
      MethodChannel('com.example.intouch_imagine_cup/communication_services');

  Future<UserCredential> createCredentials() async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text, password: passwordTextController.text);
  }

  Future<void> signUp() async {
    if (emailTextController.text == '' || passwordTextController.text == '') {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Email or password field is empty!'),
              content: Text('Please fill in both fields.'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                  style: kOrangeButtonStyle,
                )
              ],
            );
          });
    } else {
      try {
        /* Create a user in authentication */
        final credential = await createCredentials();

        print(selectedUserType);

        /* Generate access token for consultation */
        try {
          final accessToken = '';

          /* Insert user data into database */
          final db = FirebaseFirestore.instance;
          UserData signupUser = UserData(
              email: credential.user!.email!,
              userType: selectedUserType,
              id: credential.user!.uid,
              point: 0);

          final docRef = db
              .collection('users')
              .withConverter(
                fromFirestore: UserData.fromFirestore,
                toFirestore: (UserData userdata, options) =>
                    userdata.toFirestore(),
              )
              .doc(signupUser.id);

          await docRef.set(signupUser);
          if (selectedUserType == "First Aider") {
            CourseProgress newUsercourseProgressData = CourseProgress(
                progress: 0,
                answer: "",
                requirement_1: false,
                requirement_2: false,
                user_id: credential.user!.uid);
            final addNewUserCourseProgress = db
                .collection('course-progress')
                .withConverter(
                  fromFirestore: CourseProgress.fromFirestore,
                  toFirestore: (CourseProgress courseProgressData, options) =>
                      courseProgressData.toFirestore(),
                )
                .doc();

            await addNewUserCourseProgress.set(newUsercourseProgressData);
          }

          await FirebaseAuth.instance.signOut();

          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  // ignore: prefer_const_constructors
                  title: Text('Success!'),
                  // ignore: prefer_const_constructors
                  content: Text(
                      'Congratulations, your account has been successfully created.'),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          LogInScreen.id,
                          (Route<dynamic> route) => false),
                      // ignore: prefer_const_constructors
                      child: Text('Go to login'),
                      style: kOrangeButtonStyle,
                    )
                  ],
                );
              });
        } on PlatformException catch (e) {
          print(e);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Your password is too weak!'),
                  content: Text('Please use a stronger password.'),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                      style: kOrangeButtonStyle,
                    )
                  ],
                );
              });
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for this email.');
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Account already exists!'),
                  content: Text('Please go to login page.'),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                      style: kOrangeButtonStyle,
                    )
                  ],
                );
              });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    selectedUserType = ModalRoute.of(context)!.settings.arguments.toString();
    return Scaffold(
      backgroundColor: kLightOrangeColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 39.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'InTouch',
                    style: kIntouchTitleTextStyle,
                  ),
                  SizedBox(
                    height: 70.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: kInputBorder,
                      contentPadding: EdgeInsets.all(20.0),
                      focusedBorder: kInputBorder,
                    ),
                    controller: emailTextController,
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: kInputBorder,
                      contentPadding: EdgeInsets.all(20.0),
                      focusedBorder: kInputBorder,
                    ),
                    controller: passwordTextController,
                  ),
                  SizedBox(
                    height: 95.0,
                  ),
                  ElevatedButton(
                    style: kOrangeButtonStyle,
                    onPressed: signUp,
                    child: Text(
                      'Sign Up',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

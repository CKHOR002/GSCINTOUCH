import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/classes/current_user.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:intouch_imagine_cup/database/schemas/user.dart';
import 'package:intouch_imagine_cup/screens/first_aider/homepage.dart';
import 'package:intouch_imagine_cup/screens/consultation/main_screen.dart';
import 'package:intouch_imagine_cup/screens/targetuser_mainpage.dart';
import 'package:provider/provider.dart';

import 'su_user_type_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LogInScreen extends StatefulWidget {
  LogInScreen({Key? key}) : super(key: key);

  static const String id = 'login';

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final emailTextController = TextEditingController();

  final passwordTextController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //     if (user == null) {
  //       print('User is currently signed out!');
  //     } else {
  //       print('User is signed in!');
  //       queryCurrentUserInfo(user);
  //     }
  //   });
  // }

  Future<void> queryCurrentUserInfo(User user) async {
    final db = FirebaseFirestore.instance;
    final query = db.collection("users").doc(user.uid).withConverter(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userData, _) => userData.toFirestore(),
        );

    final docSnap = await query.get();
    final signedInUser = docSnap.data();
    Provider.of<CurrentUser>(context, listen: false).loggedIn(signedInUser!);

    if (signedInUser.userType == 'First Aider') {
      Navigator.popAndPushNamed(context, FirstAiderHomePage.id);
    } else {
      Navigator.popAndPushNamed(context, TargetUserMainPage.id);
    }
  }

  Future<UserCredential> logIn() async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text, password: passwordTextController.text);
  }

  Future<void> signUserIn() async {
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
        final credential = await logIn();

        queryCurrentUserInfo(credential.user!);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email');

          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('No user credential found for this email!'),
                  content:
                      Text('Please check your email or go to signup page.'),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                      style: kOrangeButtonStyle,
                    )
                  ],
                );
              });
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');

          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Incorrect password!'),
                  content: Text(
                      'Please make sure you have entered the correct password.'),
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
                    onPressed: signUserIn,
                    child: Text(
                      'Log In',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account yet?',
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SuUserTypeScreen.id);
                        },
                        child: Text(
                          'Sign up here',
                          style: TextStyle(
                            color: kOrangeColor,
                            fontSize: 12.0,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

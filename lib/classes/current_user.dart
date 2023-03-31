import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/database/schemas/user.dart';

class CurrentUser extends ChangeNotifier {
  UserData? currentUser = null;

  void loggedIn(UserData loggedInUser) {
    currentUser = loggedInUser;
  }

  void loggedOut() {
    currentUser = null;
  }
  //
  // String get accessToken {
  //   if (currentUser != null) {
  //     return currentUser!.accessToken;
  //   } else {
  //     return '';
  //   }
  // }
}

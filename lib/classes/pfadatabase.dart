import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PFADatabaseProvider extends ChangeNotifier {
  bool? requirement_1;
  bool? requirement_2;
  int? progress;
  PFADatabaseProvider() {
    open();
  }

  Future<int?> open() async {
    final db = FirebaseFirestore.instance;
    final ref = await db
        .collection("course-progress")
        .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((snapshot) async {
      final data = snapshot.docs.first;
      requirement_1 = data['requirement_1'];
      requirement_2 = data['requirement_2'];
      progress = data['progress'];
      notifyListeners();
      return progress;
    });
    return progress;
  }
}

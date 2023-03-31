import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> updateProgress(int progress) async {
  final db = FirebaseFirestore.instance;
  // Get a new write batch
  final batch = db.batch();
  final ref = db
      .collection("course-progress")
      .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .get()
      .then((snapshot) {
    String docid = snapshot.docs.first.id;
    final ref = db.collection("course-progress").doc(docid);
    batch.update(ref, {"progress": progress});
    // Commit the batch
    batch.commit().then((_) {
      print('updated the progress');
    });
  });
}

Future<void> updateRequirement(int requirementnumber, bool requirement) async {
  final db = FirebaseFirestore.instance;
  // Get a new write batch
  final batch = db.batch();
  final ref = db
      .collection("course-progress")
      .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .get()
      .then((snapshot) {
    String docid = snapshot.docs.first.id;
    final ref = db.collection("course-progress").doc(docid);
    batch.update(ref, {'requirement_$requirementnumber': requirement});
    batch.commit().then((_) {
      print('update requirement_$requirementnumber');
    });
  });
}

Future<void> updateAnswer(String answer) async {
  final db = FirebaseFirestore.instance;
  // Get a new write batch
  final batch = db.batch();
  final ref = db
      .collection("course-progress")
      .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .get()
      .then((snapshot) {
    String docid = snapshot.docs.first.id;
    final ref = db.collection("course-progress").doc(docid);
    batch.update(ref, {'answer': answer});
    batch.commit().then((_) {
      print('updated answer');
    });
  });
}

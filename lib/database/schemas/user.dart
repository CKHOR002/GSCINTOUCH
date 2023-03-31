import 'package:cloud_firestore/cloud_firestore.dart';

// class UserData {
//   UserData(
//       {required this.accessToken,
//       required this.email,
//       required this.userType,
//       required this.point,
//       String? id})
//       : id = id ?? 'demo_id_${DateTime.now().millisecondsSinceEpoch}';
//
//   final String id;
//   String accessToken;
//   String email;
//   String userType;
//   int point;
//
//   factory UserData.fromFirestore(
//     DocumentSnapshot<Map<String, dynamic>> snapshot,
//     SnapshotOptions? options,
//   ) {
//     final data = snapshot.data();
//     return UserData(
//       accessToken: data?['accessToken'],
//       email: data?['email'],
//       userType: data?['userType'],
//       id: data?['id'],
//       point: data?['point'],
//     );
//   }
//
//   Map<String, dynamic> toFirestore() {
//     return {
//       "id": id,
//       "accessToken": accessToken,
//       "email": email,
//       "userType": userType,
//       "point": point,
//     };
//   }
// }

class UserData {
  UserData(
      {required this.email,
      required this.userType,
      required this.point,
      String? id})
      : id = id ?? 'demo_id_${DateTime.now().millisecondsSinceEpoch}';

  final String id;
  String email;
  String userType;
  int point;

  factory UserData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserData(
      email: data?['email'],
      userType: data?['userType'],
      id: data?['id'],
      point: data?['point'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "email": email,
      "userType": userType,
      "point": point,
    };
  }
}

import 'package:flutter/foundation.dart';

class RoomData extends ChangeNotifier {
  late String roomID;
  late bool camEnabled;
  late String name;
  String? consultationRequestId;

  void updateRoomData(
      {required String id,
      required bool cam,
      required String userName,
      String? requestId}) {
    roomID = id;
    camEnabled = cam;
    name = userName;
    consultationRequestId = requestId;
  }
}

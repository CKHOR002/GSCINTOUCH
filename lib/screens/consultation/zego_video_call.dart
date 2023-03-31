// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// /// Note that the userID needs to be globally unique,
// final String localUserID = math.Random().nextInt(10000).toString();
// final String localStreamID = localUserID;
// final String remoteStreamID = 'ADS123';
// final int appID = 2115631271;
// final String appSign =
//     "682918b0044026243ec17935f84b412e08d898a57bc0f3f666391526596f2d27";
//
// class VideoCall extends StatefulWidget {
//   const VideoCall({
//     Key? key,
//   }) : super(key: key);
//
//   static const String id = 'video_call';
//
//   @override
//   State<VideoCall> createState() => _VideoCallState();
// }
//
// class _VideoCallState extends State<VideoCall> {
//   final String callID = 'ABC123';
//
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(minutes: 1), startRecord);
//   }
//
//   void startRecord() async {
//     try {
//       var url = Uri.https('zcloudrecord-api.zego.im', '', {
//         'Action': 'StartRecord',
//         'RoomId': callID,
//         'RecordInputParams': {
//           'RecordMode': 1,
//         }
//       });
//
//       print('Waiting response');
//       var response = await http.post(url);
//       print('Response object');
//       print(response.body);
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter Video Chat'),
//       ),
//       body: Center(
//         child: ZegoUIKitPrebuiltCall(
//           appID: appID,
//           appSign: appSign,
//           userID: localUserID,
//           userName: localUserID,
//           callID: callID,
//           config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
//             ..onHangUp = () async {},
//         ),
//       ),
//     );
//   }
// }

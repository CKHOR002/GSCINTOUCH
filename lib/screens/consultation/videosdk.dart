// import 'package:flutter/material.dart';
//
// /* For generating access token */
// import 'dart:async';
// import 'package:flutter/services.dart';
//
// /* For video calling */
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import "package:videosdk/videosdk.dart";
//
// String _accessToken =
//     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI0OTVkNjg2Yy1hNDc2LTQ0ZWUtODNkZC02MTgwZTRmYWM2NGMiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTY3NDYzNDk1NCwiZXhwIjoxNjc1MjM5NzU0fQ.WrOIsFm7vHD1_Ig53Rj1Rut2VdbPJpgwTFh-KFVhQkk';
// String _roomId = '';
//
// class VideoSDKSample extends StatefulWidget {
//   const VideoSDKSample({Key? key}) : super(key: key);
//
//   static const String id = 'videosdk';
//
//   @override
//   State<VideoSDKSample> createState() => _VideoSDKSampleState();
// }
//
// class _VideoSDKSampleState extends State<VideoSDKSample> {
//   // static const platform =
//   //     MethodChannel('com.example.intouch_imagine_cup/communication_services');
//   //
//   // Future<void> _getAccessToken() async {
//   //   String accessToken;
//   //   try {
//   //     accessToken = await platform.invokeMethod('generateAccessToken');
//   //
//   //     setState(() {
//   //       _accessToken = accessToken;
//   //     });
//   //   } on PlatformException catch (e) {
//   //     print(e);
//   //   }
//   // }
//
//   Future<void> createMeeting() async {
//     String roomId;
//     final http.Response httpResponse = await http.post(
//       Uri.parse("https://api.videosdk.live/v2/rooms"),
//       headers: {'Authorization': _accessToken},
//     );
//     roomId = json.decode(httpResponse.body)['roomId'];
//
//     setState(() {
//       _roomId = roomId;
//     });
//   }
//
//   void joinMeeting() {}
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: createMeeting,
//               child: Text('Create Room Id'),
//             ),
//             Text(_roomId),
//             // ElevatedButton(
//             //   onPressed: () {
//             //     Navigator.pushNamed(context, MeetingScreen.id);
//             //   },
//             //   child: Text('Join Meeting'),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

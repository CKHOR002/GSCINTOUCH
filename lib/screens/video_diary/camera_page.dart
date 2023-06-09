// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:intouch_imagine_cup/screens/video_diary/video_page.dart';
//
// class CameraPage extends StatefulWidget {
//   const CameraPage({Key? key}) : super(key: key);
//
//   @override
//   _CameraPageState createState() => _CameraPageState();
// }
//
// class _CameraPageState extends State<CameraPage> {
//   bool _isLoading = true;
//   late CameraController _cameraController;
//
//   @override
//   void dispose() {
//     _cameraController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Container(
//         color: Colors.white,
//         child: const Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     } else {
//       return Center(
//         child: Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             CameraPreview(_cameraController),
//             Padding(
//               padding: const EdgeInsets.all(25),
//               child: FloatingActionButton(
//                 backgroundColor: Colors.red,
//                 child: Icon(_isRecording ? Icons.stop : Icons.circle),
//                 onPressed: () => _recordVideo(),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }
//
// _initCamera() async {
//   final cameras = await availableCameras();
//   final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
//   _cameraController = CameraController(front, ResolutionPreset.max);
//   await _cameraController.initialize();
//   setState(() => _isLoading = false);
// }
//
// @override
// void initState() {
//   super.initState();
//   _initCamera();
// }
//
// bool _isRecording = false;
//
// _recordVideo() async {
//   if (_isRecording) {
//     final file = await _cameraController.stopVideoRecording();
//     setState(() => _isRecording = false);
//     final route = MaterialPageRoute(
//       fullscreenDialog: true,
//       builder: (_) => VideoPage(filePath: file.path),
//     );
//     Navigator.push(context, route);
//   } else {
//     await _cameraController.prepareForVideoRecording();
//     await _cameraController.startVideoRecording();
//     setState(() => _isRecording = true);
//   }


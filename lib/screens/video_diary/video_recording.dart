library flutter_camera;

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:intouch_imagine_cup/screens/video_diary/video_play.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intouch_imagine_cup/screens/video_diary/calendar_view.dart';

class FlutterCamera extends StatefulWidget {
  // final List<CameraDescription>? cameras;
  final Color? color;
  final Color? iconColor;
  Function(XFile)? onImageCaptured;
  Function(XFile)? onVideoRecorded;
  final Duration? animationDuration;
  FlutterCamera(
      {Key? key,
      this.onImageCaptured,
      this.animationDuration = const Duration(seconds: 1),
      this.onVideoRecorded,
      this.iconColor = Colors.white,
      required this.color})
      : super(key: key);
  @override
  _FlutterCameraState createState() => _FlutterCameraState();
}

class _FlutterCameraState extends State<FlutterCamera> {
  List<CameraDescription>? cameras;
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    // checkPermission();
    initCamera().then((_) {
      setCamera(0);
    });
  }

  // Future<void> checkPermission() async {
  //   while ((await Permission.storage.isDenied)) {
  //     await Permission.storage.request();
  //   }
  //   while ((await Permission.camera.isDenied)) {
  //     await Permission.camera.request();
  //   }
  //   while ((await Permission.microphone.isDenied)) {
  //     await Permission.microphone.request();
  //   }
  //   while ((await Permission.bluetoothConnect.isDenied)) {
  //     await Permission.bluetoothConnect.request();
  //   }
  // }

  Future initCamera() async {
    cameras = await availableCameras();
    setState(() {});
  }

  void setCamera(int index) {
    controller = CameraController(cameras![index], ResolutionPreset.max);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  void uploadRecordedFile(filepath) async {
    /// Upload Image
    if (filepath != null && filepath.contains('.jpg')) {
      File file = File(filepath);
      await FirebaseStorage.instance.ref('media/$filepath').putFile(file);
      showUploadCompleteDialog(context);
    }

    /// Upload Video
    else if (filepath != null && filepath.contains('.mp4')) {
      File file = File(filepath);
      await FirebaseStorage.instance.ref('media/$filepath').putFile(file);
      showUploadCompleteDialog(context);
    } else {
      print('File picker canceled');
    }
  }

  void showUploadCompleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload Complete'),
          content: Text('Your file has been successfully uploaded.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  bool _isTouchOn = false;
  bool _isFrontCamera = false;

  ///Switch
  bool _cameraView = true;

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: AnimatedSwitcher(
        duration: widget.animationDuration!,
        child: _cameraView == true ? cameraView() : videoView(),
      ),
    );
  }

  void captureImage() {
    controller!.takePicture().then((value) {
      final imagefilepath = value.path;
      print("::::::::::::::::::::::::::::::::: $imagefilepath");
      if (imagefilepath.contains('.jpg')) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Image.file(File(imagefilepath)),
                actions: [
                  TextButton(
                    onPressed: () {
                      uploadRecordedFile(imagefilepath);
                    },
                    child: Text('UPLOAD'),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(
                            horizontal:
                                25.0), // change this value to the desired horizontal padding amount
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                  ),
                ],
              );
            });
      }
    });
  }

  void setVideo() {
    controller!.startVideoRecording();
  }

  ///Camera View Layout
  Widget cameraView() {
    return Stack(
      key: const ValueKey(0),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: CameraPreview(
            controller!,
          ),
        ),

        ///Side controlls
        Positioned(
            top: 40,
            right: 0,
            child: Column(
              // close button, switch camera, flash
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.clear,
                      color: widget.iconColor,
                      size: 30,
                    )),
                cameraSwitcherWidget(),
                flashToggleWidget()
              ],
            )),

        ///Navigate Photo and Video
        Positioned(
          bottom: 70,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ///camera
                TextButton(
                  onPressed: () {
                    setState(() {
                      ///Show camera view
                      _cameraView = true;
                    });
                  },
                  child: Text('PHOTO'),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                          horizontal:
                              25.0), // change this value to the desired horizontal padding amount
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                ),

                ///video
                TextButton(
                  onPressed: () {
                    setState(() {
                      ///Show camera view
                      _cameraView = false;
                    });
                  },
                  child: Text('VIDEO'),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white)),
                ),
              ],
            ),
          ),
        ),

        ///Take Photo Button
        Positioned(
          bottom: 50,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: IconButton(
              onPressed: () {
                captureImage();
              },
              icon: Icon(
                Icons.fiber_manual_record,
                color: widget.iconColor,
                size: 80,
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _isRecording = false;
  bool _isPaused = false;

  ///Video View Layout
  Widget videoView() {
    return Stack(
      key: const ValueKey(1),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: CameraPreview(
            controller!,
          ),
        ),

        /// Side controlls
        Positioned(
          top: 0,
          child: Container(
            padding: const EdgeInsets.only(top: 40),
            width: MediaQuery.of(context).size.width,
            color: widget.color,
            height: 100,
            child: Row(
              children: [
                ///Front Camera toggle
                cameraSwitcherWidget(),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      _isRecording == false
                          ? 'Video recording is off'
                          : 'Video recording is on',
                      style: TextStyle(color: widget.iconColor, fontSize: 22),
                    ),
                  ),
                ),

                ///Flash toggle
                flashToggleWidget()
              ],
            ),
          ),
        ),

        /// Navigate Photo and Video
        Positioned(
          bottom: 70,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // camera
                TextButton(
                  onPressed: () {
                    setState(() {
                      ///Show camera view
                      _cameraView = true;
                    });
                  },
                  child: Text('PHOTO'),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                          horizontal:
                              25.0), // change this value to the desired horizontal padding amount
                    ),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                ),

                //video
                TextButton(
                  onPressed: () {
                    setState(() {
                      ///Show camera view
                      _cameraView = false;
                    });
                  },
                  child: Text('VIDEO'),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(
                            horizontal:
                                25.0), // change this value to the desired horizontal padding amount
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white)),
                ),
              ],
            ),
          ),
        ),

        ///Bottom Controls
        Positioned(
          bottom: 0,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// Left
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera,
                      color: widget.iconColor,
                      size: 30,
                    )),

                /// Center (Record,Stop)
                IconButton(
                  onPressed: () {
                    //Start and stop video
                    if (_isRecording == false) {
                      ///Start
                      controller!.startVideoRecording();
                      _isRecording = true;
                    } else {
                      ///Stop video recording
                      controller!.stopVideoRecording().then((value) {
                        final videofilepath = value.path;
                        print(
                            '::::::::::::::::::::::::;; dkdkkd $videofilepath');

                        ///Show video preview .mp4
                        if (videofilepath.contains('.mp4')) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: VideoApp(
                                    videoFilePath: videofilepath,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        uploadRecordedFile(videofilepath);
                                      },
                                      child: Text('UPLOAD'),
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        padding: MaterialStateProperty.all<
                                            EdgeInsets>(
                                          EdgeInsets.symmetric(
                                              horizontal:
                                                  25.0), // change this value to the desired horizontal padding amount
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.grey),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        }
                      });
                      _isRecording = false;
                    }
                    setState(() {});
                  },
                  icon: Icon(
                    _isRecording == false
                        ? Icons.radio_button_checked
                        : Icons.stop_circle,
                    color: widget.iconColor,
                    size: 50,
                  ),
                ),

                /// Right (Pause,Resume)
                IconButton(
                  onPressed: () {
                    //pause and resume video
                    if (_isRecording == true) {
                      //pause
                      if (_isPaused == true) {
                        ///resume
                        controller!.resumeVideoRecording();
                        _isPaused = false;
                      } else {
                        ///resume
                        controller!.pauseVideoRecording();
                        _isPaused = true;
                      }
                    }
                    setState(() {});
                  },
                  icon: Icon(
                    _isPaused == false ? Icons.pause_circle : Icons.play_circle,
                    color: widget.iconColor,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  //Side-Control - Flash
  Widget flashToggleWidget() {
    return IconButton(
      onPressed: () {
        if (_isTouchOn == false) {
          controller!.setFlashMode(FlashMode.torch);
          _isTouchOn = true;
        } else {
          controller!.setFlashMode(FlashMode.off);
          _isTouchOn = false;
        }
        setState(() {});
      },
      icon: Icon(_isTouchOn == false ? Icons.flash_on : Icons.flash_off,
          color: widget.iconColor, size: 30),
    );
  }

  //Side-control - Switch Camera
  Widget cameraSwitcherWidget() {
    return IconButton(
      onPressed: () {
        if (_isFrontCamera == false) {
          setCamera(1);
          _isFrontCamera = true;
        } else {
          setCamera(0);
          _isFrontCamera = false;
        }
        setState(() {});
      },
      icon:
          Icon(Icons.change_circle_outlined, color: widget.iconColor, size: 30),
    );
  }

//Video Player
// Widget videoPlayer(videofilepath) {
//   late VideoPlayerController _controller;
//
//   void initvideoState(videofilepath) {
//     super.initState();
//     _controller = VideoPlayerController.file(
//         videofilepath)
//       ..initialize().then((_) {
//         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//         setState(() {});
//       });
//   }
//
//   return MaterialApp(
//     title: 'Video Demo',
//     home: Scaffold(
//       body: Center(
//         child: _controller.value.isInitialized
//             ? AspectRatio(
//           aspectRatio: _controller.value.aspectRatio,
//           child: VideoPlayer(_controller),
//         )
//             : Container(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             _controller.value.isPlaying
//                 ? _controller.pause()
//                 : _controller.play();
//           });
//         },
//         child: Icon(
//           _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         ),
//       ),
//     ),
//   );
//   }
// }

}

class VideoApp extends StatefulWidget {
  VideoApp({required this.videoFilePath, super.key});

  String videoFilePath;

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    File videoFile = File(widget.videoFilePath);
    _controller = VideoPlayerController.file(videoFile)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

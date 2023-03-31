import 'dart:io';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
// import 'package:flutter/services.dart';

class UploadButton extends StatefulWidget {
  final Function(File) onFileSelected;
  const UploadButton({Key? key, required this.onFileSelected}) : super(key: key);

  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {

  // select file main function
  void selectFile() async {

    // Pick File
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String fileName = result.files.first.name;
      PlatformFile file = result.files.first;
      Uint8List? fileBytes = result.files.first.bytes;
      String? filepath = result.files.first.path;

      if (filepath != null) {
        File file = File(filepath);

        // Upload file
        await FirebaseStorage.instance.ref(''
            'gs://intouch-6d207.appspot.com/media/data/user/0/com.example.intouch_imagine_cup/$fileName').putFile(file);
        showUploadCompleteDialog(context);
      }
    }
    else {
      print('File picker canceled');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          color: kOrangeColor,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: selectFile,
          icon: Icon(
            Icons.cloud_upload,
            color: Colors.white,
          ),
        ),
      );
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
// TextButton(
// onPressed: _openFileExplorer,
// child:

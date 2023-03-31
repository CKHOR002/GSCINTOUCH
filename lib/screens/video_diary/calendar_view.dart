import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intouch_imagine_cup/screens/video_diary/view_diary.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';

// const storage = getStorage();

class TableBasicsExample extends StatefulWidget {
  @override
  _TableBasicsExampleState createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TableBasicsExample> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Initialization
  final FirebaseStorage storage = FirebaseStorage.instance;

  /// Retrieve Date and Time of Creation
  //   FirebaseStorage storage = FirebaseStorage.getInstance();
  //   StorageReference storageRef =  FirebaseStorage.getInstance();.getReference().child("path/to/file");
  //
  //   storageRef.getMetadata().addOnSuccessListener(new OnSuccessListener<StorageMetadata>() {
  //       @Override
  //       public void onSuccess(StorageMetadata storageMetadata) {
  //       // Handle successful retrieval of file metadata
  //       // The creation time can be obtained using the getCreationTimeMillis() method
  //       long creationTimeMillis = storageMetadata.getCreationTimeMillis();
  //       Date creationDate = new Date(creationTimeMillis);
  //       SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault());
  //       String creationTimeFormatted = sdf.format(creationDate);
  //       Log.d("CreationTime", "Creation Time: " + creationTimeFormatted);
  //       }
  //       }).addOnFailureListener(new OnFailureListener() {
  //       @Override
  //       public void onFailure(@NonNull Exception exception) {
  //       // Handle failed retrieval of file metadata
  //   }
  //   }),

  @override
  Widget build(BuildContext context) {
    Future<void> viewImage() async {
      Reference ref = storage.refFromURL(
          'gs://intouch-6d207.appspot.com/media/data/user/0/com.example.intouch_imagine_cup/cache');
      ListResult result = await ref.listAll();

      List<DateTime> createdDate = [];

      for (var item in result.items) {
        String url = await item.getDownloadURL();
        print('URL: $url');
        // Display the image using Image.network or SvgPicture.network
        FullMetadata metadata = await item.getMetadata();
        createdDate.add(metadata.timeCreated!);
      }

      print(createdDate);
    }

    // return
    //   FutureBuilder(
    //     future: viewImage(), // Call the function here
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         return Text('Images loaded successfully!');
    //       } else {
    //         return CircularProgressIndicator();
    //       }
    //     },
    //   );

    return SizedBox(
      child: TableCalendar(
        /// Range of Date
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),

        calendarFormat: _calendarFormat,

        /// Holiday
        selectedDayPredicate: (day) {
          // Use `selectedDayPredicate` to determine which day is currently selected.
          // If this returns true, then `day` will be marked as selected.

          // Using `isSameDay` is recommended to disregard
          // the time-part of compared DateTime objects.
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            // Call `setState()` when updating the selected day
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // Call `setState()` when updating calendar format
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
        },

        /// Style of Calendar
        calendarStyle: CalendarStyle(
          selectedDecoration: const BoxDecoration(
            color: kOrangeColor,
            shape: BoxShape.circle,
          ),
          // cellPadding: const EdgeInsets.all(0),
        ),

        /// Style of Day Cell
        calendarBuilders: CalendarBuilders(
          todayBuilder: (context, date, _) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context, CupertinoPageRoute(builder: (context) => MyApp()));
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    /// Need to run through all the images in the firebase storage
                    image: AssetImage('images/story_1.png'),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                ),
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: TextStyle(fontSize: 16, color: Color(0xFFFFFF)),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

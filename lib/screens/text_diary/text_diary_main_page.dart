// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/bottom_navbar.dart';
import 'package:intouch_imagine_cup/screens/text_diary/text_diary_detail.dart';
import 'package:intouch_imagine_cup/screens/text_diary/text_diary_field.dart';
import 'package:provider/provider.dart';
import '../../database/schemas/textdiary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TextDiaryMainPage extends StatefulWidget {
  //const TextDiaryMainPage({Key? key}) : super(key: key);
  static const String id = 'textDiaryMainPage';

  const TextDiaryMainPage({super.key});

  @override
  State<TextDiaryMainPage> createState() => _TextDiaryMainPageState();
}

class _TextDiaryMainPageState extends State<TextDiaryMainPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DatabaseProvider(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TextDiaryField(),
              ),
            );
          },
          backgroundColor: kOrangeColor,
          child: const Icon(Icons.add),
        ),
        appBar: WhiteAppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 44.0, horizontal: 0),
                child: Text(
                  'Text Diary',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
              ),
              Consumer<DatabaseProvider>(builder: (context, database, _) {
                return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: database.listOfMonth.length,
                    itemBuilder: (context, index) {
                      final item = database.listOfMonth[index];
                      return MonthAndTextDiary(
                        month: item.toString(),
                      );
                    });
              }),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavbar(selectedIndex: 2),
      ),
    );
  }
}

class MonthAndTextDiary extends StatelessWidget {
  const MonthAndTextDiary({super.key, required this.month});

  final String month;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                month,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          Consumer<DatabaseProvider>(builder: (context, database, _) {
            return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: database.items.length,
                itemBuilder: (context, index) {
                  final item = database.items[index];
                  if (month == item.monthyear) {
                    return TextDiaryEntry(
                        textDiaryDetail: item, date: item.day.toString());
                  } else {
                    return SizedBox(
                      height: 0,
                    );
                  }
                });
          }),
        ],
      ),
    );
  }
}

class TextDiaryEntry extends StatelessWidget {
  const TextDiaryEntry(
      {super.key, required this.textDiaryDetail, required this.date});

  final TextDiaryEntryData textDiaryDetail;
  final String date;

  @override
  Widget build(BuildContext context) {
    String diaryDetails = textDiaryDetail.details.toString();
    String truncatedText = "";
    if (diaryDetails.split(" ").length > 5) {
      truncatedText =
          // ignore: prefer_interpolation_to_compose_strings
          diaryDetails.split(" ").sublist(0, 5).join(" ") + "...";
    } else {
      truncatedText = diaryDetails;
    }

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Card(
                  margin: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                    left: 0,
                  ),
                  color: kOrangeColor,
                  child: SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: Center(
                      child: Text(
                        date,
                        style: kInputSmallHeaderTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TextDiaryDetail(textdiarydata: textDiaryDetail),
                      ),
                    );
                  },
                  //delete button
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          'Delete this diary?',
                          style: kInputHeaderTextStyle,
                        ),
                        actions: [
                          //delete button
                          TextButton(
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: kOrangeColor,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () {
                              deleteDocument(
                                textDiaryDetail.id.toString(),
                              );
                              Navigator.popAndPushNamed(
                                  context, TextDiaryMainPage.id);
                            },
                          ),
                          //cancel button
                          TextButton(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: kOrangeColor,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              print('Cancel');
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                      left: 10.0,
                    ),
                    color: kProfileOrangeColor,
                    child: SizedBox(
                      width: 40.0,
                      height: 40.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 14.0),
                        child: Text(
                          truncatedText, //diary detail from database
                          style: kInputSmallHeaderTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //delete button
  Future<void> deleteDocument(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('text_diary')
          .doc(documentId)
          .delete();
      print('Document deleted successfully');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }
}

class DatabaseProvider extends ChangeNotifier {
  List<TextDiaryEntryData> items = [];
  List<String> listOfMonth = [];
  DatabaseProvider() {
    open();
  }

  Future<void> open() async {
    //sorting of all the diary document
    FirebaseFirestore.instance
        .collection('text_diary')
        .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .orderBy('datetime', descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String date = doc["date"].toString();
        String monthyear = DateFormat.MMMM('en_US')
            .add_y()
            .format(DateFormat("MMMM d, y", "en_US").parse(date));
        String day = DateFormat.d('en_US')
            .format(DateFormat("MMMM d, y", "en_US").parse(date));

        items.add((TextDiaryEntryData(
          id: doc.id,
          details: doc["detail"],
          date: doc["date"],
          sentimentscore: doc["sentimentScore"].toInt(),
          monthyear: monthyear,
          day: day,
          time: doc["time"],
        )));
      });
      notifyListeners();
    });

    //sorting of the month
    FirebaseFirestore.instance
        .collection('text_diary')
        .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .orderBy('datetime', descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String date = doc["date"].toString();
        String formattedDate = DateFormat.MMMM('en_US')
            .add_y()
            .format(DateFormat("MMMM d, y", "en_US").parse(date));
        if (listOfMonth.isEmpty || !listOfMonth.contains(formattedDate)) {
          listOfMonth.add(formattedDate);
        }
      });
      notifyListeners();
    });
  }
}

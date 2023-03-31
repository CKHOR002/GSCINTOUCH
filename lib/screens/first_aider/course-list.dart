// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/classes/pfadatabase.dart';
import 'package:intouch_imagine_cup/components/white_appbar.dart';
import 'package:intouch_imagine_cup/components/firstaider-bottom_navbar.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_end.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_overview.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_r.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_a.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_p.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_i.dart';
import 'package:intouch_imagine_cup/screens/first_aider/pfa_lesson/pfa_d.dart';
import 'package:intouch_imagine_cup/screens/first_aider/r_validation.dart';
import 'package:provider/provider.dart';

class CourseListPage extends StatefulWidget {
  const CourseListPage({Key? key}) : super(key: key);

  static const String id = 'course_list';

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: ((context) => PFADatabaseProvider()),
        builder: ((context, child) {
          return FutureBuilder(
            future:
                Provider.of<PFADatabaseProvider>(context, listen: false).open(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                  appBar: WhiteAppBar(),
                  body: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: PFACourseList(),
                  ),
                  bottomNavigationBar: BottomNavbar(selectedIndex: 1),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
          );
        }));
  }
}

class PFACourseList extends StatelessWidget {
  const PFACourseList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PFADatabaseProvider>(builder: (context, database, _) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
              child: Text(
                'Psychological First Aid Course',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '12 Sections •  3 hours 30 mins',
              style: TextStyle(
                fontSize: 14.0,
                color: Color(0xFF8C8C8C),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CourseList(),
          ],
        ),
      );
    });
  }
}

class CourseList extends StatefulWidget {
  const CourseList({super.key});

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  final Stream<QuerySnapshot> _courseListStream = FirebaseFirestore.instance
      .collection('course-list')
      .orderBy('index')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
          stream: _courseListStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text("Loading"));
            }
            if (snapshot.data!.size == 0) {
              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(child: Text("No voucher available")),
              );
            }
            return Column(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return CourseListContainer(
                  index: data['index'],
                  name: data['name'],
                  courseListID: document.id,
                );
              }).toList(),
            );
          }),
    );
  }
}

class CourseListContainer extends StatelessWidget {
  const CourseListContainer(
      {super.key,
      required this.index,
      required this.name,
      required this.courseListID});
  final int index;
  final String name;
  final String courseListID;

  @override
  Widget build(BuildContext context) {
    return Consumer<PFADatabaseProvider>(builder: (context, database, _) {
      return GestureDetector(
        onTap: () {
          if (database.progress! >= index - 1) {
            switch (index) {
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PFAOverview(),
                  ),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PFA_R(),
                  ),
                );
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RValidation(
                      courseListID: courseListID,
                      index: 3,
                    ),
                  ),
                );
                break;
              case 4:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PFA_A(),
                  ),
                );
                break;
              case 5:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RValidation(
                      courseListID: courseListID,
                      index: 5,
                    ),
                  ),
                );
                break;
              case 6:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PFA_P(),
                  ),
                );
                break;
              case 7:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RValidation(
                      courseListID: courseListID,
                      index: 7,
                    ),
                  ),
                );
                break;
              case 8:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PFA_I(),
                  ),
                );
                break;
              case 9:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RValidation(
                      courseListID: courseListID,
                      index: 9,
                    ),
                  ),
                );
                break;
              case 10:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PFA_D(),
                  ),
                );
                break;
              case 11:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RValidation(
                      courseListID: courseListID,
                      index: 11,
                    ),
                  ),
                );
                break;
              default:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PFA_End(),
                  ),
                );
                break;
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Card(
            color: Color(0xFFFEF3E7),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              side: BorderSide(
                color: Color(0XFFFE8235),
              ),
            ),
            child: SizedBox(
              width: 360,
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      '$index.   $name ',
                      style: TextStyle(
                          color: database.progress! >= index
                              ? Color.fromARGB(255, 254, 7, 7)
                              : Color(0xFFFE8235),
                          fontWeight: FontWeight.w400),
                    ),
                    Icon(
                      database.progress! >= index
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: Color(0xFFFE8235),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

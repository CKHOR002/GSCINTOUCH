import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/classes/consultation_data.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:intouch_imagine_cup/database/schemas/courseprogress.dart';
import 'package:provider/provider.dart';
import 'first_aider_option.dart';
import 'package:intouch_imagine_cup/database/schemas/user.dart';

class SelectFirstAiderDialog extends StatefulWidget {
  const SelectFirstAiderDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectFirstAiderDialog> createState() => _SelectFirstAiderDialogState();
}

class _SelectFirstAiderDialogState extends State<SelectFirstAiderDialog> {
  bool isFirstAiderSelected = false;

  Future<void> queryFirstAider() async {
    final db = FirebaseFirestore.instance;

    final queryFirstAider = db
        .collection('course-progress')
        .where('progress', isEqualTo: 12)
        .withConverter(
            fromFirestore: CourseProgress.fromFirestore,
            toFirestore: (CourseProgress courseProgress, _) =>
                courseProgress.toFirestore());
    final faDocSnap = await queryFirstAider.get();
    final qualifiedFAId = [];
    faDocSnap.docs
        .forEach((element) => qualifiedFAId.add(element.data().user_id));

    final queryQualifiedFA = db
        .collection('users')
        .where('id', whereIn: qualifiedFAId)
        .withConverter(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userData, _) => userData.toFirestore(),
        );

    final qualifiedFADocSnap = await queryQualifiedFA.get();
    final qualifiedFirstAiders = qualifiedFADocSnap.docs;

    if (Provider.of<ConsultationData>(context, listen: false)
            .firstAiders
            .length ==
        0) {
      for (var firstAider in qualifiedFirstAiders) {
        Provider.of<ConsultationData>(context, listen: false)
            .addFirstAider(firstAider.data().email, null, firstAider.data().id);
      }

      Provider.of<ConsultationData>(context, listen: false).removeFilter();
    }
  }

  void selectedFirstAider() {
    setState(() {
      isFirstAiderSelected = true;
    });
  }

  @override
  void initState() {
    super.initState();
    queryFirstAider();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.0),
      backgroundColor: kLightOrangeColor,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 20.0,
      ),
      children: [
        Row(
          children: [
            TextButton(
              onPressed: () {
                Provider.of<ConsultationData>(context, listen: false)
                    .selectFirstAider(
                        Provider.of<ConsultationData>(context, listen: false)
                            .selectedFirstAider);
                Provider.of<ConsultationData>(context, listen: false)
                    .removeFilter();
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                size: 30.0,
                color: kOrangeColor,
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
        Text(
          'Choose Your Friend',
          textAlign: TextAlign.center,
          style: kTitleTextStyle,
        ),
        SizedBox(
          height: 15.0,
        ),
        TextField(
          onChanged: (value) =>
              Provider.of<ConsultationData>(context, listen: false)
                  .filterFirstAider(value),
          decoration: InputDecoration(
            hintText: 'Search',
            suffixIcon: Icon(
              Icons.search,
              color: kOrangeColor,
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: kInputBorder,
            contentPadding: EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 20.0,
            ),
            focusedBorder: kInputBorder,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          height: 320.0,
          width: 320.0,
          child: Consumer<ConsultationData>(
            builder: (context, userList, child) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final user = userList.firstAidersFiltered[index];
                  return FirstAiderOption(
                    imageUrl: user.imageUrl,
                    name: user.name,
                    isSelected: userList.tempFirstAider == user ? true : false,
                    selectUser: () {
                      userList.selectFirstAider(user);
                      selectedFirstAider();
                    },
                  );
                },
                itemCount: userList.firstAiderCount,
              );
            },
          ),
        ),
        SizedBox(
          height: 18.0,
        ),
        ElevatedButton(
          style: kOrangeButtonStyle,
          onPressed: isFirstAiderSelected
              ? () {
                  Provider.of<ConsultationData>(context, listen: false)
                      .tempToSelectedFirstAider();
                  Provider.of<ConsultationData>(context, listen: false)
                      .removeFilter();
                  Navigator.pop(context);
                }
              : null,
          child: Text(
            'Select',
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
    );
  }
}

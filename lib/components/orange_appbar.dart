// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/constants.dart';
import 'package:provider/provider.dart';
import 'package:intouch_imagine_cup/classes/current_user.dart';
import 'package:intouch_imagine_cup/screens/li_su/log_in_screen.dart';

class OrangeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OrangeAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFFEF3E7),
      title: Text(
        'InTouch',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        PopupMenuButton(
          onSelected: (String) async {
            await FirebaseAuth.instance.signOut();
            Provider.of<CurrentUser>(context, listen: false).loggedOut();
            Navigator.pushNamedAndRemoveUntil(
                context, LogInScreen.id, (Route<dynamic> route) => false);
          },
          // ignore: sort_child_properties_last
          child: Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // ignore: prefer_const_literals_to_create_immutables
                boxShadow: [
                  BoxShadow(
                      blurRadius: 1,
                      color: kProfileOrangeColor,
                      spreadRadius: 3)
                ],
              ),
              child: CircleAvatar(
                radius: 17.0,
                foregroundImage: AssetImage('images/profile_picture.jpg'),
              ),
            ),
          ),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'Logout',
              child: Text('Logout'),
            )
          ],
          position: PopupMenuPosition.under,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}

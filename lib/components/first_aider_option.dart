import 'package:flutter/material.dart';
import 'package:intouch_imagine_cup/constants.dart';

class FirstAiderOption extends StatelessWidget {
  const FirstAiderOption(
      {Key? key,
      required this.imageUrl,
      required this.name,
      required this.isSelected,
      this.selectUser})
      : super(key: key);

  final String imageUrl;
  final String name;
  final bool isSelected;
  final Function()? selectUser;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: selectUser,
      child: Container(
        padding: EdgeInsets.only(top: 10.0),
        child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: isSelected ? kOrangeColor.withOpacity(0.6) : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 17.0,
                foregroundImage: AssetImage(imageUrl),
              ),
              SizedBox(
                width: 20.0,
              ),
              Flexible(
                child: Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

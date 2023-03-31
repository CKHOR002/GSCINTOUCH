import 'package:flutter/material.dart';

const kTagetUserAccessToken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI0OTVkNjg2Yy1hNDc2LTQ0ZWUtODNkZC02MTgwZTRmYWM2NGMiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTY3NjI2NDc3NCwiZXhwIjoxNjkxODE2Nzc0fQ.6R_huzZTwbLKGWVgymrnzP8iqlPxPuvKsYf-vibokoY';

const kFirstAiderAccessToken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI0OTVkNjg2Yy1hNDc2LTQ0ZWUtODNkZC02MTgwZTRmYWM2NGMiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTY3NjI2NDgwMiwiZXhwIjoxNjkxODE2ODAyfQ.APTrgtlsi4BEhBVm_fmG9SJrO9u3VsQe6jVj06pDgIQ';

const kOrangeColor = Color(0xFFFE8235);

const kProfileOrangeColor = Color(0xFFF6CFAD);

const kLightOrangeColor = Color(0xFFFEF3E7);

const kLightGreyColor = Color(0xFFB5B5B5);

ButtonStyle kOrangeButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
    if (states.contains(MaterialState.disabled)) {
      return Color(0xFFDADADA); // Disabled color
    }
    return kOrangeColor; // Regular color
  }),
  textStyle: MaterialStateProperty.all<TextStyle>(
    TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
    ),
  ),
  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
      EdgeInsets.symmetric(vertical: 16.0, horizontal: 42.0)),
  shape: MaterialStateProperty.all<OutlinedBorder>(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  ),
);

ButtonStyle kOrangeSmallButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(kOrangeColor),
  textStyle: MaterialStateProperty.all<TextStyle>(
    TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
    ),
  ),
  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0)),
  shape: MaterialStateProperty.all<OutlinedBorder>(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  ),
);

const kTitleTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 30.0,
);

OutlineInputBorder kInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0),
  borderSide: BorderSide(
    color: Colors.white,
  ),
);

const kInputHeaderTextStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.w600,
);

const kInputSmallHeaderTextStyle = TextStyle(
  fontSize: 12.0,
  fontWeight: FontWeight.w600,
);

const kNumberTextStyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 25.0,
);
const kSubtitleTextStyle = TextStyle(
  fontSize: 12.0,
  fontWeight: FontWeight.w300,
);

const kIntouchTitleTextStyle = TextStyle(
  color: kOrangeColor,
  fontSize: 64.0,
  fontWeight: FontWeight.bold,
);

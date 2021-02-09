import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget getDefaultProfilePic(
    String url, String name, double radius, bool needBorder) {
  if (url.toString() == 'null') {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.green[300],
      child: Text(
        '${name[0].toUpperCase()}',
        style: GoogleFonts.arimo(
          fontSize: radius * 1.15,
          fontWeight: FontWeight.w400,
          color: Color(0xfff0ffeb),
        ),
      ),
    );
  } else {
    if (needBorder == true) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Color(0xffbbeaba),
        child: CircleAvatar(
          radius: 0.95 * radius,
          backgroundImage: NetworkImage(url),
        ),
      );
    } else {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(url),
      );
    }
  }
}

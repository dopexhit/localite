import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
Widget getDefaultProfilePic(String url,String name,double radius)
{
  if(url.toString()=='null'){
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.blueAccent,
      child: Text(
        '${name[0].toUpperCase()}',
        style: GoogleFonts.arimo(
          fontSize: radius*1.15,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );
  }
  else{
    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(url),
    );
  }
}
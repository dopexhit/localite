import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kLoginDecoration = InputDecoration(
  hintText: 'Enter ...',
  hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
);

// const kMessageContainerDecoration = BoxDecoration(
//   borderRadius: BorderRadius.circular(10),
//   border: Border(
//       // top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
//       ),
// );

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      borderSide: BorderSide.none),
);

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

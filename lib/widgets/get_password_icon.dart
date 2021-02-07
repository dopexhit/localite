import 'package:flutter/material.dart';
Icon getPasswordIcon(bool hide){
  if(hide == true) return Icon(Icons.remove_red_eye_sharp);
  else return Icon(Icons.remove_red_eye_outlined);
}
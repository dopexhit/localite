import 'package:flutter/material.dart';
import 'package:localite/models/custom_user.dart';
import 'package:provider/provider.dart';
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context);
    //if signed in then home else Login Signup
    print(user.toString());
    if(user == null) return Container(); //todo loginSignup page
    else {
      //todo extract user credentials from user
      return Container(); //todo home page
    }
  }
}

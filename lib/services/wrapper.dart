import 'package:flutter/material.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/screens/selection_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context);
    //if signed in then home else Login Signup
    print(user.toString());
    if (user == null)
      return SelectionScreen(); //todo loginSignup page
    else {
      //todo extract user credentials from user
      return Scaffold(
        body: Center(
          child: Text('user exists'),
        ),
      ); //todo home page
    }
  }
}

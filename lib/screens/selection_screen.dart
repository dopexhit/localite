import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localite/screens/login_or_register.dart';

class SelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LoginAndRegisterScreen(isServiceProvider: false)),
              );
            },
            child: Text('Continue as user'),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LoginAndRegisterScreen(isServiceProvider: true)),
              );
            },
            child: Text('Continue as service provider'),
          )
        ],
      ),
    );
  }
}

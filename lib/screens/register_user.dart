import 'package:flutter/material.dart';
import 'package:localite/models/user_data.dart';
import 'package:localite/screens/user_home.dart';
import 'package:localite/services/auth.dart';
import 'package:localite/services/shared_pref.dart';
import 'package:localite/widgets/toast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  String email;
  String password;
  String name;
  String contact;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  //Do something with the user input.
                  name = value;
                },
                style: TextStyle(color: Colors.black87),
                textAlign: TextAlign.center,
                decoration: kLoginDecoration.copyWith(
                  hintText: 'Enter your name',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.black87),
                textAlign: TextAlign.center,
                decoration: kLoginDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value) {
                  //Do something with the user input.
                  contact = value;
                },
                keyboardType: TextInputType.phone,
                style: TextStyle(color: Colors.black87),
                textAlign: TextAlign.center,
                decoration: kLoginDecoration.copyWith(
                  hintText: 'Enter your phone no',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                obscureText: true,
                style: TextStyle(
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                decoration:
                    kLoginDecoration.copyWith(hintText: 'Enter your Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async {
                      //user registration functionality.
                      if (email == null ||
                          password == null ||
                          contact == null ||
                          name == null) {
                        MyToast().getToast('Enter all the fields!');
                      } else {
                        setState(() {
                          showSpinner = true;
                        });

                        UserData data = UserData(name: name, contact: contact);
                        final newUser = await AuthService()
                            .userRegisterwithEmailandPassword(
                                email, password, data);

                        setState(() {
                          showSpinner = false;
                        });
                        if (newUser != null) {
                          MyToast().getToast('Registered successfully!');
                          // go to user home screen
                          SharedPrefs.preferences
                              .setBool('isServiceProvider', false);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserHomeScreen()));
                        }
                      }
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Register',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

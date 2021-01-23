import 'package:flutter/material.dart';
import 'package:localite/screens/register_service_provider.dart';
import 'package:localite/screens/register_user.dart';
import 'package:localite/screens/service_provider_home.dart';
import 'package:localite/screens/sp_navigator_home.dart';
import 'package:localite/screens/user_home.dart';
import 'package:localite/screens/user_navigator_home.dart';
import 'package:localite/services/auth.dart';
import 'package:localite/services/shared_pref.dart';
import 'package:localite/widgets/toast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../constants.dart';

//TODO: IMP: user can enter login page and vice-versa for service provider (make correction by using data snapshots)

class LoginAndRegisterScreen extends StatefulWidget {
  final bool isServiceProvider;

  LoginAndRegisterScreen({this.isServiceProvider});

  @override
  _LoginAndRegisterScreenState createState() => _LoginAndRegisterScreenState();
}

class _LoginAndRegisterScreenState extends State<LoginAndRegisterScreen> {
  String email;
  String password;
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
                      //Implement login functionality.

                      if (email == null || password == null) {
                        MyToast().getToast('Enter both email and password!');
                      } else {
                        setState(() {
                          showSpinner = true;
                        });

                        final newUser = await AuthService()
                            .signInwithEmailandPassword(email, password);
                        setState(() {
                          showSpinner = false;
                        });

                        if (newUser != null) {
                          MyToast().getToast('Signed in successfully!');

                          if (widget.isServiceProvider == true) {
                            // go to service provider home screen
                            SharedPrefs.preferences
                                .setBool('isServiceProvider', true);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SPNavigatorHome()),
                            );
                          } else {
                            // go to user home screen
                            SharedPrefs.preferences
                                .setBool('isServiceProvider', false);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserNavigatorHome()),
                            );
                          }
                        }
                      }
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Log In',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                child: Text('New user? register here',
                    style: TextStyle(color: Colors.blue)),
                onTap: () {
                  if (widget.isServiceProvider == true) {
                    // go to service provider register screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterServiceProvider()));
                  } else {
                    // go to user register screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterUser()));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

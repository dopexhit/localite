import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localite/animations/fade-animation.dart';
import 'package:localite/screens/register_service_provider.dart';
import 'package:localite/screens/register_user.dart';
import 'package:localite/screens/selection_screen.dart';
import 'package:localite/screens/service_provider_screens/sp_navigator_home.dart';
import 'package:localite/screens/user_screens/user_navigator_home.dart';
import 'package:localite/services/auth.dart';
import 'package:localite/services/shared_pref.dart';
import 'package:localite/widgets/toast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../constants.dart';

class LoginAndRegisterScreen extends StatefulWidget {
  final bool isServiceProvider;

  LoginAndRegisterScreen({this.isServiceProvider});

  @override
  _LoginAndRegisterScreenState createState() => _LoginAndRegisterScreenState();
}

class _LoginAndRegisterScreenState extends State<LoginAndRegisterScreen> {
  String email;
  String password;
  String error='';
  bool showSpinner = false,hidePassword=true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      error='';
      hidePassword=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0ffeb),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SingleChildScrollView(
            //padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 80.0,),
                  Hero(
                    tag: 'logoIcon',
                    child: SvgPicture.asset(
                      'assets/images/appIcon.svg',
                      height: 80,
                      width: 80,
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                      'sAmigo',
                      style: GoogleFonts.boogaloo(
                        fontSize: 40,
                        letterSpacing: 2,
                        color: Color(0xff515151),
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(50.0, 60.0, 50.0, 2.0),
                    child: TextFormField(
                      validator: (val) => val.isEmpty ? "Field can't be empty" : null,
                      onChanged: (value) {
                        //Do something with the user input.
                        email = value;
                      },
                      //keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.boogaloo(
                        fontSize: 18,
                        color: Color(0xff515151),
                      ),
                      textAlign: TextAlign.center,
                      decoration: kLoginDecoration.copyWith(hintText: 'Enter your email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(50.0, 2.0, 5.0, 2.0),
                        child: SizedBox(
                          width: 250.0,
                          child: TextFormField(
                            obscureText: hidePassword,
                            validator: (val) =>val.isEmpty ? "Field can't be empty" : val.length<6 ? 'A valid password must be at least 6 charcters' : null,
                            style: GoogleFonts.boogaloo(
                              fontSize: 18,
                              color: Color(0xff515151),
                            ),
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              //Do something with the user input.
                              password = value;
                            },
                            decoration: kLoginDecoration.copyWith(hintText: 'Enter password'),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.00,),
                      IconButton(icon: Icon(Icons.remove_red_eye_rounded), onPressed:(){
                        setState(() {
                          hidePassword = !(hidePassword);
                        });
                      },
                      focusColor: Color(0xffbbeaba),)
                    ],
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Material(
                      color: Color(0xffbbeaba),
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      elevation: 4.0,
                      child: MaterialButton(
                        onPressed: () async {
                          //Implement login functionality.

                          FocusScope.of(context).unfocus();

                          if (_formKey.currentState.validate()!=true){
                            setState(() {
                              error='';
                            });
                          }

                          if (_formKey.currentState.validate()) {
                            setState(() {
                              showSpinner = true;
                            });

                            final newUser = await AuthService()
                                .signInwithEmailandPassword(email, password);
                            setState(() {
                              showSpinner = false;
                              hidePassword = true;
                            });

                            if (newUser != null) {
                              bool isUser = false;
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(newUser.user.uid.toString())
                                  .get()
                                  .then((value) {
                                if (value.exists) {
                                  setState(() {
                                    isUser = true;
                                  });
                                }
                              });
                              if (widget.isServiceProvider == true) {
                                // go to service provider home screen
                                if (isUser == true) {
                                  await FirebaseAuth.instance.signOut();
                                  setState(() {
                                    error = "Can't continue as service provider with an user account";
                                  });
                                } else {
                                  MyToast().getToast('Signed in successfully!');
                                  SharedPrefs.preferences
                                      .setBool('isServiceProvider', true);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SPNavigatorHome()),
                                  );
                                }
                              } else {
                                // go to user home screen
                                if (isUser == false) {
                                  await FirebaseAuth.instance.signOut();
                                  setState(() {
                                    error = "Can't continue as user with service provider account";
                                  });
                                } else {
                                  MyToast().getToast('Signed in successfully!');
                                  SharedPrefs.preferences
                                      .setBool('isServiceProvider', false);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserNavigatorHome()),
                                  );
                                }
                              }
                            }
                            else{
                              setState(() {
                                error = 'Invalid email or password';
                              });
                            }
                          }
                        },
                        minWidth: 200.0,
                        height: 42.0,
                        child: Text(
                          'Log In',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.boogaloo(
                            fontSize: 25,
                            color: Color(0xff515151),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('New user? ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.boogaloo(
                      fontSize: 18,
                      color: Color(0xff515151),
                    ),),
                  SizedBox(height: 5.0,),
                  GestureDetector(
                    child: Text('Register here',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.boogaloo(
                        fontSize: 18,
                        color: Colors.lightBlueAccent[100],
                      ),),
                    onTap: () {
                      if (widget.isServiceProvider == true) {
                        // go to service provider register screen
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterServiceProvider()));
                      } else {
                        // go to user register screen
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterUser()));
                      }
                    },
                  ),
                  SizedBox(height: 30.0,),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

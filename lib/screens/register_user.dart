import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localite/models/user_data.dart';
import 'package:localite/screens/user_screens/user_navigator_home.dart';
import 'package:localite/services/auth.dart';
import 'package:localite/services/shared_pref.dart';
import 'package:localite/widgets/get_password_icon.dart';
import 'package:localite/widgets/toast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';
import 'login_or_register.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  String email;
  String password;
  String name;
  String error='';
  String contact;
  bool showSpinner = false,hidePassword=true,hideConfirmedPassword=true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      error='';
      hidePassword=true;
      hideConfirmedPassword=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0ffeb),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 40.0,),
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
                        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 2.0),
                        child: TextFormField(
                          onChanged: (value) {
                            //Do something with the user input.
                            name = value;
                          },
                          validator: (val) => val.isEmpty ? "Field can't be empty" : null,
                          style: GoogleFonts.boogaloo(
                            fontSize: 18,
                            color: Color(0xff515151),
                          ),
                          textAlign: TextAlign.center,
                          decoration: kLoginDecoration.copyWith(
                            hintText: 'Enter your name',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: TextFormField(
                          onChanged: (value) {
                            //Do something with the user input.
                            email = value;
                          },
                          validator: (val) => val.isEmpty ? "Field can't be empty" : null,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.boogaloo(
                            fontSize: 18,
                            color: Color(0xff515151),
                          ),
                          textAlign: TextAlign.center,
                          decoration: kLoginDecoration.copyWith(
                            hintText: 'Enter your email',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: TextFormField(
                          onChanged: (value) {
                            //Do something with the user input.
                            contact = value;
                          },
                          validator: (val) => val.isEmpty ? "Field can't be empty" : null,
                          keyboardType: TextInputType.phone,
                          style: GoogleFonts.boogaloo(
                            fontSize: 18,
                            color: Color(0xff515151),
                          ),
                          textAlign: TextAlign.center,
                          decoration: kLoginDecoration.copyWith(
                            hintText: 'Enter your phone no',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(30.0, 2.0, 5.0, 10.0),
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
                                decoration: kLoginDecoration.copyWith(hintText: 'Create a password'),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.00,),
                          IconButton(icon: getPasswordIcon(hidePassword), onPressed:(){
                            setState(() {
                              hidePassword = !(hidePassword);
                            });
                          },
                            focusColor: Color(0xffbbeaba),)
                        ],
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(30.0, 0.0, 5.0, 15.0),
                            child: SizedBox(
                              width: 250.0,
                              child: TextFormField(
                                obscureText: hideConfirmedPassword,
                                validator: (val) =>val.isEmpty ? "Field can't be empty" : val.length<6 ? 'A valid password must be at least 6 charcters' : val!=password ? "Passwords don't match":null,
                                style: GoogleFonts.boogaloo(
                                  fontSize: 18,
                                  color: Color(0xff515151),
                                ),
                                textAlign: TextAlign.center,
                                // onChanged: (value) {
                                //   //Do something with the user input.
                                //   password = value;
                                // },
                                decoration: kLoginDecoration.copyWith(hintText: 'Confirm password'),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.00,),
                          IconButton(icon: getPasswordIcon(hideConfirmedPassword), onPressed:(){
                            setState(() {
                              hideConfirmedPassword = !(hideConfirmedPassword);
                            });
                          },
                            focusColor: Color(0xffbbeaba),)
                        ],
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Material(
                          color: Color(0xffbbeaba),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          elevation: 4.0,
                          child: MaterialButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              //user registration functionality.
                              if (_formKey.currentState.validate()!=true) {
                                setState(() {
                                  error='';
                                });
                              }else {
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
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UserNavigatorHome()));
                                }
                                else{
                                  setState(() {
                                    error='The provided email is already registered';
                                  });
                                }
                              }
                            },
                            minWidth: 200.0,
                            height: 42.0,
                            child: Text(
                              'Get Started',
                              style: GoogleFonts.boogaloo(
                                fontSize: 18,
                                color: Color(0xff515151),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Already registered? ',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.boogaloo(
                          fontSize: 18,
                          color: Color(0xff515151),
                        ),),
                      SizedBox(height: 5.0,),
                      GestureDetector(
                        child: Text('Login here',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.boogaloo(
                            fontSize: 18,
                            color: Colors.lightBlueAccent[100],
                          ),),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginAndRegisterScreen()));
                        },
                      ),
                      SizedBox(height: 15.0,),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      SizedBox(height: 10.0,)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

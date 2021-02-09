import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localite/map/map_result.dart';
import 'package:localite/map/map_screen.dart';
import 'package:localite/models/offered_services.dart';
import 'package:localite/models/service_provider_data.dart';
import 'package:localite/screens/login_or_register.dart';
import 'package:localite/screens/service_provider_screens/sp_navigator_home.dart';
import 'package:localite/services/auth.dart';
import 'package:localite/services/shared_pref.dart';
import 'package:localite/widgets/get_password_icon.dart';
import 'package:localite/widgets/toast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';

class RegisterServiceProvider extends StatefulWidget {
  @override
  _RegisterServiceProviderState createState() =>
      _RegisterServiceProviderState();
}

class _RegisterServiceProviderState extends State<RegisterServiceProvider> {
  SimpleLocationResult selectedLocation;
  String email;
  String password;
  String name;
  String contact;
  String address;
  String error='';
  double latitude;
  double longitude;
  String service;
  bool showSpinner = false,hidePassword=true,hideConfirmedPassword=true;
  final _formKey = GlobalKey<FormState>();

  DropdownButton<String> getDropdownButton() {
    List<DropdownMenuItem<String>> myList = [];

    for (String serv in servicesList) {
      var dropdownitem = DropdownMenuItem<String>(
        child: Text(serv,style: GoogleFonts.boogaloo(
          fontSize: 18,), textAlign: TextAlign.center,),
        value: serv,
      );
      myList.add(dropdownitem);
    }

    return DropdownButton<String>(
      value: service,
      style: TextStyle(color: Color(0xff515151),),
      items: myList,
      dropdownColor: Color(0xffbbeaba),
      focusColor: Colors.grey,
      elevation: 3,
      underline: Container(color: Colors.transparent),
      onChanged: (value) {
        setState(() {
          service = value;
        });
      },
    );
  }
  @override
  void initState() {
    super.initState();
    setState(() {
      error='';
      hidePassword=true;
      hideConfirmedPassword=true;
      service=null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
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
                            fontSize: 20,
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
                            fontSize: 20,
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
                            fontSize: 20,
                            color: Color(0xff515151),
                          ),
                          textAlign: TextAlign.center,
                          decoration: kLoginDecoration.copyWith(
                            hintText: 'Enter your phone no',
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.fromLTRB(0.0, 13.0, 25.0, 15.0),
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 50.0),
                              child: Expanded(
                                child: Text('You are: ',
                                  style: GoogleFonts.boogaloo(
                                    fontSize: 20,
                                    color: Color(0xff515151),
                                  ),),
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                              child: SizedBox(height:30,child: getDropdownButton()),
                            ),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide( width:0.5,style: BorderStyle.solid,),
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: TextFormField(
                          onChanged: (value) {
                            //Do something with the user input.
                            address = value;
                          },
                          validator: (val) => val.isEmpty ? "Field can't be empty" : null,
                          style: GoogleFonts.boogaloo(
                            fontSize: 20,
                            color: Color(0xff515151),
                          ),
                          textAlign: TextAlign.center,
                          decoration: kLoginDecoration.copyWith(
                            hintText: 'Enter your address',
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          Padding(padding: EdgeInsets.fromLTRB(30.0, 13.0, 10.0, 15.0),
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 0.5*width),
                              child: Expanded(
                                child: Text('Select default location for service: ',
                                  style: GoogleFonts.boogaloo(
                                    fontSize: 20,
                                    color: Color(0xff515151),
                                  ),),
                              ),
                            ),
                          ),
                          Material(
                            color: Color(0xffbbeaba),
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            elevation: 4.0,
                            child: MaterialButton(
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 70.0,),
                                child: Expanded(
                                  child: Text('Go to Map',style: GoogleFonts.boogaloo(
                                    fontSize: 18,
                                    color: Color(0xff515151),),),
                                ),
                              ),
                              onPressed: () async {
                                double lat = 28.1, long = 77.1;

                                if (address == null || address == '') {
                                  MyToast().getToast('Please fill the address first!');
                                } else {
                                  List<Location> locations =
                                  await locationFromAddress(address);

                                  if (locations != null && locations != []) {
                                    lat = locations[0].latitude;
                                    long = locations[0].longitude;

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SimpleLocationPicker(
                                              initialLatitude: lat,
                                              initialLongitude: long,
                                              dest: false,
                                              appBarTitle: "Select Location",
                                            ))).then((value) {
                                      if (value != null) {
                                        setState(() {
                                          selectedLocation = value;
                                          latitude = selectedLocation.latitude;
                                          longitude = selectedLocation.longitude;
                                        });
                                      }
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        constraints: BoxConstraints(maxWidth: width),
                        child: Expanded(
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(30.0, 2.0, 0.0, 10.0),
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: 0.65*width),
                                  child: Expanded(
                                    child: TextFormField(
                                      obscureText: hidePassword,
                                      validator: (val) =>val.isEmpty ? "Field can't be empty" : val.length<6 ? 'A valid password must be at least 6 charcters' : null,
                                      style: GoogleFonts.boogaloo(
                                        fontSize: 20,
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
                              ),
                              Expanded(
                                child: IconButton(icon: getPasswordIcon(hidePassword), onPressed:(){
                                  setState(() {
                                    hidePassword = !(hidePassword);
                                  });
                                },
                                  focusColor: Color(0xffbbeaba),),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Container(
                        constraints: BoxConstraints(maxWidth: width),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 15.0),
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 0.65*width),
                                child: Expanded(
                                  child: TextFormField(
                                    obscureText: hideConfirmedPassword,
                                    validator: (val) =>val.isEmpty ? "Field can't be empty" : val.length<6 ? 'A valid password must be at least 6 charcters' : val!=password ? "Passwords don't match":null,
                                    style: GoogleFonts.boogaloo(
                                      fontSize: 20,
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
                            ),
                            Expanded(
                              child: IconButton(icon: getPasswordIcon(hideConfirmedPassword), onPressed:(){
                                setState(() {
                                  hideConfirmedPassword = !(hideConfirmedPassword);
                                });
                              },
                                focusColor: Color(0xffbbeaba),),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Material(
                          color: Color(0xffbbeaba),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          elevation: 4.0,
                          child: MaterialButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              //service provider login functionality.
                              if (_formKey.currentState.validate()!=true) {
                                setState(() {
                                  error='';
                                });
                              } else if (latitude == null || longitude == null) {
                                MyToast().getToast("Please confirm your location on map!");
                              }else if(service==null){
                                MyToast().getToast("Please select the service you may provide!");
                              } else {
                                setState(() {
                                  showSpinner = true;
                                });

                                ServiceProviderData data = ServiceProviderData(
                                    name: name,
                                    contact: contact,
                                    address: address,
                                    latitude: latitude,
                                    longitude: longitude,
                                    service: service);

                                final newUser = await AuthService()
                                    .serviceProviderRegisterwithEmailandPassword(
                                        email, password, data);

                                setState(() {
                                  showSpinner = false;
                                });

                                if (newUser != null) {
                                  MyToast().getToast('Registered successfully!');
                                  // go to service provider home screen
                                  SharedPrefs.preferences
                                      .setBool('isServiceProvider', true);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SPNavigatorHome()));
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
                                fontSize: 25,
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
                          fontSize: 20,
                          color: Color(0xff515151),
                        ),),
                      SizedBox(height: 5.0,),
                      GestureDetector(
                        child: Text('Login here',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.boogaloo(
                            fontSize: 20,
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
                        style: TextStyle(color: Colors.red, fontSize: 15.0),
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

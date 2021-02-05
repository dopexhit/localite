import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localite/map/map_result.dart';
import 'package:localite/map/map_screen.dart';
import 'package:localite/models/offered_services.dart';
import 'package:localite/models/service_provider_data.dart';
import 'package:localite/screens/service_provider_screens/sp_navigator_home.dart';
import 'package:localite/services/auth.dart';
import 'package:localite/services/shared_pref.dart';
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
  String service = 'Carpenter';
  bool showSpinner = false,hidePassword=true;
  final _formKey = GlobalKey<FormState>();

  DropdownButton<String> getDropdownButton() {
    List<DropdownMenuItem<String>> myList = [];

    for (String serv in servicesList) {
      var dropdownitem = DropdownMenuItem<String>(
        child: Text(serv),
        value: serv,
      );

      myList.add(dropdownitem);
    }

    return DropdownButton<String>(
      value: service,
      items: myList,
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
                      TextFormField(
                        onChanged: (value) {
                          //Do something with the user input.
                          name = value;
                        },
                        validator: (val) => val.isEmpty ? "Field can't be empty" : null,
                        style: TextStyle(color: Colors.black87),
                        textAlign: TextAlign.center,
                        decoration: kLoginDecoration.copyWith(
                          hintText: 'Enter your name',
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          //Do something with the user input.
                          email = value;
                        },
                        validator: (val) => val.isEmpty ? "Field can't be empty" : null,
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
                      TextFormField(
                        onChanged: (value) {
                          //Do something with the user input.
                          contact = value;
                        },
                        validator: (val) => val.isEmpty ? "Field can't be empty" : null,
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
                      TextFormField(
                        onChanged: (value) {
                          //Do something with the user input.
                          address = value;
                        },
                        validator: (val) => val.isEmpty ? "Field can't be empty" : null,
                        style: TextStyle(color: Colors.black87),
                        textAlign: TextAlign.center,
                        decoration: kLoginDecoration.copyWith(
                          hintText: 'Enter your address',
                        ),
                      ),
                      SizedBox(height: 8.0),
                      getDropdownButton(),
                      SizedBox(height: 8.0),
                      TextFormField(
                        onChanged: (value) {
                          //Do something with the user input.
                          password = value;
                        },
                        validator: (val) =>val.isEmpty ? "Field can't be empty" : val.length<6 ? 'A valid password must be at least 6 charcters' : null,
                        obscureText: true,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        decoration: kLoginDecoration.copyWith(
                            hintText: 'Enter your Password'),
                      ),
                      SizedBox(height: 8.0),
                      RaisedButton(
                        child: Text('Select default location for service'),
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
                      SizedBox(height: 24.0),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Material(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          elevation: 5.0,
                          child: MaterialButton(
                            onPressed: () async {
                              //service provider login functionality.
                              if (email == null ||
                                  password == null ||
                                  contact == null ||
                                  name == null ||
                                  address == null ||
                                  service == null) {
                                MyToast().getToast('Enter all the fields!');
                              } else if (latitude == null || longitude == null) {
                                MyToast().getToast("Please select a location!");
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
            ),
          ),
        ),
      ),
    );
  }
}

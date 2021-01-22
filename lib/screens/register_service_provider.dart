import 'package:flutter/material.dart';
import 'package:localite/models/offered_services.dart';
import 'package:localite/models/service_provider_data.dart';
import 'package:localite/screens/service_provider_home.dart';
import 'package:localite/services/auth.dart';
import 'package:localite/services/shared_pref.dart';
import 'package:localite/widgets/toast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:simple_location_picker/simple_location_picker_screen.dart';
import 'package:simple_location_picker/simple_location_result.dart';
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
  double latitude;
  double longitude;
  String service = 'Carpenter';
  bool showSpinner = false;

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
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
                      address = value;
                    },
                    style: TextStyle(color: Colors.black87),
                    textAlign: TextAlign.center,
                    decoration: kLoginDecoration.copyWith(
                      hintText: 'Enter your address',
                    ),
                  ),
                  SizedBox(height: 8.0),
                  getDropdownButton(),
                  SizedBox(height: 8.0),
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
                    decoration: kLoginDecoration.copyWith(
                        hintText: 'Enter your Password'),
                  ),
                  SizedBox(height: 8.0),
                  RaisedButton(
                    child: Text('Select default location for service'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SimpleLocationPicker(
                                    initialLatitude: 28.7,
                                    initialLongitude: 77.1,
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
                            MyToast().getToast("Couldn't sign in.. try again!");
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

                            final newUser = AuthService()
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ServiceProviderHomeScreen()));
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
    );
  }
}

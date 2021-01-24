import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:localite/widgets/toast.dart';
import 'package:simple_location_picker/simple_location_picker_screen.dart';

import '../constants.dart';

class UserRequestScreen extends StatefulWidget {
  @override
  _UserRequestScreenState createState() => _UserRequestScreenState();
}

class _UserRequestScreenState extends State<UserRequestScreen> {
  String address;
  double latitude;
  double longitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            children: [
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
              SizedBox(height: 20),
              RaisedButton(
                onPressed: () async {
                  if (address == null || address == '') {
                    MyToast().getToast('Add your address to continue!');
                  } else {
                    List<Location> locations =
                        await locationFromAddress(address);
                    if (locations == null) {
                      MyToast().getToast(
                          'An error occurred! Enter your location again');
                    } else {
                      double lat = locations[0].latitude;
                      double long = locations[0].longitude;

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SimpleLocationPicker(
                                    initialLatitude: lat,
                                    initialLongitude: long,
                                    appBarTitle: "Select Location",
                                  ))).then((value) {
                        if (value != null) {
                          setState(() {
                            latitude = value.latitude;
                            longitude = value.longitude;
                          });
                        }
                      });
                    }
                  }
                },
                child: Text(
                  'Mark location on map',
                ),
              ),
              SizedBox(height: 120),
              RaisedButton(
                  child: Text('Request service'),
                  onPressed: () {
                    if (address == null || address == '' || longitude == null) {
                      MyToast()
                          .getToast('All fields must be entered to continue!');
                    } else {
                      //todo add request
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}

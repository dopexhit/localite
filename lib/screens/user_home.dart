import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:localite/constants.dart';
import 'package:localite/models/offered_services.dart';
import 'package:localite/screens/nearby_providers.dart';
import 'package:localite/screens/selection_screen.dart';
import 'package:localite/services/auth.dart';
import 'package:localite/services/shared_pref.dart';
import 'package:localite/widgets/toast.dart';
import 'package:simple_location_picker/simple_location_picker_screen.dart';
import 'package:simple_location_picker/simple_location_result.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

double latitude;
double longitude;

class _UserHomeScreenState extends State<UserHomeScreen> {
  SimpleLocationResult selectedLocation;
  String location;
  String searchValue;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        location = value;
                      },
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      decoration: kLoginDecoration.copyWith(
                        hintText: 'Enter your location',
                        icon: Icon(Icons.location_on),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async {
                      List<Location> locations =
                          await locationFromAddress(location);
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
                              selectedLocation = value;
                              latitude = selectedLocation.latitude;
                              longitude = selectedLocation.longitude;
                              MyToast().getToast(latitude.toString() +
                                  '  ' +
                                  longitude.toString());
                            });
                          }
                        });
                      }
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  searchValue = value;
                },
                style: TextStyle(
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                decoration: kLoginDecoration.copyWith(
                  hintText: 'search',
                  icon: Icon(
                    Icons.person_search_sharp,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: getCards(),
                  ),
                ),
              ),
              RaisedButton(
                onPressed: () async {
                  SharedPrefs.preferences.remove('isServiceProvider');
                  await AuthService().signOut().whenComplete(
                    () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectionScreen()));
                    },
                  );
                },
                child: Text('SignOut'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<CustomCard> getCards() {
  List<CustomCard> myCards = [];

  for (var service in servicesList) {
    myCards.add(CustomCard(title: service));
  }
  return myCards;
}

class CustomCard extends StatelessWidget {
  final String title;
  CustomCard({this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=> NearbySP(title: title,userLatitude: latitude,userLongitude: longitude,)));},//todo
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

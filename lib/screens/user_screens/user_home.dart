import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:localite/constants.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/offered_services.dart';
import 'package:localite/screens/user_screens/nearby_providers.dart';
import 'package:localite/services/shared_pref.dart';
import 'package:localite/widgets/toast.dart';
import 'package:simple_location_picker/simple_location_picker_screen.dart';
import 'package:simple_location_picker/simple_location_result.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

double latitude = SharedPrefs.preferences.getDouble('latitude');
double longitude = SharedPrefs.preferences.getDouble('longitude');

String searchValue = '';

class _UserHomeScreenState extends State<UserHomeScreen> {
  SimpleLocationResult selectedLocation;
  String location = SharedPrefs.preferences.getString('address');
  String tempLocation;

  @override
  void initState() {
    super.initState();
    UserDetails();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.context = context;

    return WillPopScope(
      onWillPop: () {
        return SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: location,
                        onChanged: (value) {
                          tempLocation = value;
                        },
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        decoration: kLoginDecoration.copyWith(
                          hintText: 'Enter your location',
                          // icon: Icon(Icons.location_on),
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.location_on,
                          color: Colors.red[700],
                        ),
                        onPressed: () async {
                          if (tempLocation == null || tempLocation == '') {
                            MyToast().getToast('Please select a location!');
                          } else {
                            List<Location> locations =
                                await locationFromAddress(tempLocation);

                            if (locations == null || locations.isEmpty) {
                              MyToast().getToast(
                                  'An error occurred! Enter your location again');
                            } else {
                              double lat = locations[0].latitude;
                              double long = locations[0].longitude;

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SimpleLocationPicker(
                                            initialLatitude: lat,
                                            initialLongitude: long,
                                            appBarTitle: "Select Location",
                                          ))).then((value) {
                                if (value != null) {
                                  setState(() {
                                    location = tempLocation;
                                    selectedLocation = value;
                                    latitude = selectedLocation.latitude;
                                    longitude = selectedLocation.longitude;
                                    SharedPrefs.preferences
                                        .setString('address', location);
                                    SharedPrefs.preferences
                                        .setDouble('latitude', latitude);
                                    SharedPrefs.preferences
                                        .setDouble('longitude', longitude);
                                  });
                                }
                              });
                            }
                          }
                        }),
                  ],
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchValue = value;
                    });
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<CustomCard> getCards() {
  List<CustomCard> myCards = [];

  for (var service in servicesList) {
    if (searchValue == '') {
      myCards.add(CustomCard(title: service));
    } else if (service.toLowerCase().contains(searchValue.toLowerCase())) {
      myCards.add(CustomCard(title: service));
    }
  }
  return myCards;
}

class CustomCard extends StatelessWidget {
  final String title;
  CustomCard({this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (latitude == null || longitude == null) {
          MyToast().getToast('Please select a location!');
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NearbySP(
                        title: title,
                        userLatitude: latitude,
                        userLongitude: longitude,
                      )));
        }
      },
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

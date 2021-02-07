import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localite/constants.dart';
import 'package:localite/map/map_result.dart';
import 'package:localite/map/map_screen.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/offered_services.dart';
import 'package:localite/screens/user_screens/nearby_providers.dart';
import 'package:localite/services/shared_pref.dart';
import 'package:localite/widgets/toast.dart';

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
  String tempLocation = SharedPrefs.preferences.getString('address');

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
        backgroundColor: Colors.white70,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 10, left: 13, right: 13, bottom: 10),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 9, right: 9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: SvgPicture.asset(
                          'assets/images/location_smiley.svg',
                          height: 30,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          SizedBox(
                            width: 250,
                            height: 20,
                            child: Expanded(
                              child: TextFormField(
                                initialValue: location,
                                onChanged: (value) {
                                  tempLocation = value;
                                },
                                style: GoogleFonts.boogaloo(
                                  fontSize: 20,
                                  color: Color(0xff515151),
                                ),
                                keyboardType: TextInputType.streetAddress,
                                textAlign: TextAlign.start,
                                decoration: kLoginDecoration.copyWith(
                                    hintText: 'Enter your location',
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                          Text(
                            '   - - - - - - - - - - - - - - - - - - - - - - - - - -',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
                        child: Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: FloatingActionButton(
                              backgroundColor: Color(0xfff0ffeb),
                              child: SizedBox(
                                height: 38,
                                child: Image.asset('assets/images/loc.png'),
                              ),
                              onPressed: () async {
                                if (tempLocation == null ||
                                    tempLocation == '') {
                                  MyToast()
                                      .getToast('Please select a location!');
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
                                                  dest: false,
                                                  appBarTitle:
                                                      "Select Location",
                                                ))).then((value) {
                                      if (value != null) {
                                        setState(() {
                                          location = tempLocation;
                                          selectedLocation = value;
                                          latitude = selectedLocation.latitude;
                                          longitude =
                                              selectedLocation.longitude;
                                          SharedPrefs.preferences
                                              .setString('address', location);
                                          SharedPrefs.preferences
                                              .setDouble('latitude', latitude);
                                          SharedPrefs.preferences.setDouble(
                                              'longitude', longitude);
                                        });
                                      }
                                    });
                                  }
                                }
                              }),
                        ),
                      ),
                      // IconButton(
                      //     icon: Icon(
                      //       Icons.location_on,
                      //       color: Colors.red[700],
                      //     ),
                      //     onPressed: () async {
                      //       if (tempLocation == null || tempLocation == '') {
                      //         MyToast().getToast('Please select a location!');
                      //       } else {
                      //         List<Location> locations =
                      //             await locationFromAddress(tempLocation);
                      //
                      //         if (locations == null || locations.isEmpty) {
                      //           MyToast().getToast(
                      //               'An error occurred! Enter your location again');
                      //         } else {
                      //           double lat = locations[0].latitude;
                      //           double long = locations[0].longitude;
                      //
                      //           Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) =>
                      //                       SimpleLocationPicker(
                      //                         initialLatitude: lat,
                      //                         initialLongitude: long,
                      //                         dest: false,
                      //                         appBarTitle: "Select Location",
                      //                       ))).then((value) {
                      //             if (value != null) {
                      //               setState(() {
                      //                 location = tempLocation;
                      //                 selectedLocation = value;
                      //                 latitude = selectedLocation.latitude;
                      //                 longitude = selectedLocation.longitude;
                      //                 SharedPrefs.preferences
                      //                     .setString('address', location);
                      //                 SharedPrefs.preferences
                      //                     .setDouble('latitude', latitude);
                      //                 SharedPrefs.preferences
                      //                     .setDouble('longitude', longitude);
                      //               });
                      //             }
                      //           });
                      //         }
                      //       }
                      //     }),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 9),
                  child: Material(
                    borderRadius: BorderRadius.circular(30.0),
                    elevation: 5.0,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchValue = value;
                        });
                      },
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17),
                      decoration: InputDecoration(
                        hintText: "Search for service",
                        hintStyle: TextStyle(fontSize: 16),
                        prefixIcon: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(30.0),
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 12.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
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
        color: Color(0xfff0ffeb),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              height: 150,
              width: double.maxFinite,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  image: DecorationImage(
                      image: AssetImage('assets/images/$title.jpg'),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(11),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.boogaloo(
                  fontSize: 20,
                  color: Color(0xff515151),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

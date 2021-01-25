import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/service_provider_data.dart';
import 'package:localite/models/user_data.dart';
import 'package:localite/widgets/toast.dart';
import 'package:provider/provider.dart';
import 'package:simple_location_picker/simple_location_picker_screen.dart';
import '../../constants.dart';

final _firestore = FirebaseFirestore.instance;
User loggedUser;

class UserRequestScreen extends StatefulWidget {
  final ServiceProviderData receiver;
  final requestID;

  UserRequestScreen({this.receiver, this.requestID});

  @override
  _UserRequestScreenState createState() => _UserRequestScreenState();
}

class _UserRequestScreenState extends State<UserRequestScreen> {
  final _auth = FirebaseAuth.instance;
  String address;
  double latitude;
  double longitude;
  String description;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedUser = user;
        print(user.email);
      } else {
        MyToast().getToastBottom('failed!');
      }
    } catch (e) {
      MyToast().getToastBottom(e.message.toString());
    }
  }

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
                  description = value;
                },
                style: TextStyle(color: Colors.black87),
                textAlign: TextAlign.center,
                decoration: kLoginDecoration.copyWith(
                  hintText: 'Give description of service required',
                ),
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
                    if (address == null ||
                        address == '' ||
                        longitude == null ||
                        description == null) {
                      MyToast()
                          .getToast('All fields must be entered to continue!');
                    } else {
                      //todo add request
                      UserData user =
                          Provider.of<UserDetails>(GlobalContext.context)
                              .getUserDetails;
                      _firestore
                          .collection('requests')
                          .doc(widget.requestID)
                          .collection('pending')
                          .add({
                        'service': widget.receiver.service,
                        'description': description,
                        'service provider': widget.receiver.name,
                        'user name': user.name,
                        'address': address,
                        'latitude': latitude,
                        'longitude': longitude,
                        'contact': user.contact,
                        'timestamp': Timestamp.now(),
                      });

                      addUIDs(widget.receiver);
                      Navigator.pop(context);
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}

void addUIDs(ServiceProviderData receiver) {
  UserData loggedUserData =
      Provider.of<UserDetails>(GlobalContext.context).getUserDetails;

  var docRefUser = _firestore
      .collection('Users')
      .doc(loggedUser.uid)
      .collection('requests')
      .doc(receiver.uid);

  docRefUser.get().then((value) {
    if (value.exists) {
      docRefUser.update({'lastMsg': Timestamp.now(), 'pending': true});
    } else {
      docRefUser.set({
        'uid': receiver.uid,
        'name': receiver.name,
        'service': receiver.service,
        'pending': true,
        'completed': false,
        'lastRequest': Timestamp.now(),
      });
    }
  });

  var docRefSP = _firestore
      .collection('Service Providers')
      .doc(receiver.uid)
      .collection('requests')
      .doc(loggedUser.uid);

  docRefSP.get().then((value) {
    if (value.exists) {
      docRefSP.update({'lastMsg': Timestamp.now(), 'pending': true});
    } else {
      docRefSP.set({
        'uid': loggedUser.uid,
        'name': loggedUserData.name,
        'pending': true,
        'completed': false,
        'lastRequest': Timestamp.now(),
      });
    }
  });
}

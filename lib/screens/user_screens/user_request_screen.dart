import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localite/map/map_screen.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/service_provider_data.dart';
import 'package:localite/models/user_data.dart';
import 'package:localite/widgets/toast.dart';
import 'package:provider/provider.dart';
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
  final _formKey = GlobalKey<FormState>();

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
    final width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Column(
          children: [
            SizedBox(height: 7),
            AppBar(
              backgroundColor: Color(0xffbbeaba),
              iconTheme: IconThemeData(
                color: Color(0xff515151),
              ),
              automaticallyImplyLeading: false,
              leading: GestureDetector(
                  child: Icon(Icons.arrow_back_ios),
                  onTap: () {
                    Navigator.pop(context);
                  }),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: Svg('assets/images/appIcon.svg'),height: 20.0,width: 20.0,),
                  SizedBox(width: 10),
                  Text(
                    'sAmigo',
                    style: GoogleFonts.boogaloo(
                        fontSize: 29, color: Color(0xff515151)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        //width: width,
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: Svg('assets/images/details_background.svg'),
              fit: BoxFit.cover,
            ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.0,),
                    Text('Need Assistance!!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.boogaloo(
                        fontSize: 25,
                        color: Color(0xff515151),
                      ),),
                    SizedBox(height: 30.0,),
                    Text('Service Description:',
                      style: GoogleFonts.boogaloo(
                        fontSize: 20,
                        color: Color(0xff515151),
                      ),),
                    Container(
                      width: width*0.75,
                      constraints: BoxConstraints(maxHeight: 70.0),
                      child: Expanded(
                        child: TextFormField(
                          validator: (val) => val.isEmpty ? "Field can't be empty" : null,
                          onChanged: (value) {
                            //Do something with the user input.
                            description = value;
                          },
                          style: GoogleFonts.boogaloo(
                            fontSize: 20,
                            color: Color(0xff515151),
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xffbbeaba),
                                width: 1.5,
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color(0xffbbeaba),
                                  width: 1.5,
                                )
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0,),
                    Text('Address of Service:',
                      style: GoogleFonts.boogaloo(
                        fontSize: 20,
                        color: Color(0xff515151),
                      ),),
                    Container(
                      width: width*0.75,
                      constraints: BoxConstraints(maxHeight: 80.0),
                      child: Expanded(
                        child: TextFormField(
                          validator: (val) => val.isEmpty ? "Field can't be empty" : null,
                          onChanged: (value) {
                            //Do something with the user input.
                            address = value;
                          },
                          style: GoogleFonts.boogaloo(
                            fontSize: 20,
                            color: Color(0xff515151),
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Color(0xffbbeaba),
                                    width: 1.5,
                                  )
                              ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color(0xffbbeaba),
                                  width: 1.5,
                                )
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      constraints: BoxConstraints(maxWidth: width),
                      child: Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 2.0, 2.0, 2.0),
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 0.5*width),
                                child: Expanded(
                                  child: Text(
                                    'Mark Service Location: ',
                                    style: GoogleFonts.boogaloo(
                                      fontSize: 20,
                                      color: Color(0xff515151),
                                    ),
                                    textAlign: TextAlign.center,
                                    ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              child: Image.asset('assets/images/map_marker.png',width: 25.0,height: 25.0,),
                              onTap: ()async {
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
                                              dest: false,
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 120),
                    Material(
                      color: Color(0xffbbeaba),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      elevation: 4.0,
                      child: SizedBox(width: 150.0,height: 50.0,
                        child: MaterialButton(
                            child: Text('Get Assistance',textAlign: TextAlign.center,
                              style: GoogleFonts.boogaloo(
                                fontSize: 20,
                              ),),
                            onPressed: () {
                              if (address == null ||
                                  address == '' ||
                                  longitude == null ||
                                  description == null) {
                                MyToast()
                                    .getToast('All fields must be entered to continue!');
                              } else {
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
                                  'sp contact': widget.receiver.contact,
                                  'timestamp': Timestamp.now(),
                                });

                                addUIDs(widget.receiver);
                                Navigator.pop(context);
                              }
                            }),
                      ),
                    )
                  ],
                ),
              ),
            ),
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
      docRefUser.update({'lastRequest': Timestamp.now(), 'pending': true});
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
      docRefSP.update({'lastRequest': Timestamp.now(), 'pending': true});
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


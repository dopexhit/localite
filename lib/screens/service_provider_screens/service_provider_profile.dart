import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/service_provider_data.dart';
import 'package:localite/screens/service_provider_screens/service_prov_side_bar.dart';
import 'package:localite/services/database.dart';
import 'package:localite/widgets/def_profile_pic.dart';

class SPProfile extends StatefulWidget {
  @override
  _SPProfileState createState() => _SPProfileState();
}

class _SPProfileState extends State<SPProfile> {
  File _imageFile;
  ServiceProviderData currentSP;

  @override
  Widget build(BuildContext context) {
    SPDetails();
    currentSP = GlobalServiceProviderDetail.spData;
    return StreamBuilder<DocumentSnapshot>(
        stream:
            DatabaseService().getSPProfile(currentSP.uid, currentSP.service),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String photoUrl = snapshot.data.data()['photoUrl'].toString();
            String name = snapshot.data.data()['name'].toString();
            String contact = snapshot.data.data()['contact'].toString();
            String address = snapshot.data.data()['address'].toString();
            return Scaffold(
              endDrawer: SPDrawer(),
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(100),
                child: Column(
                  children: [
                    SizedBox(height: 7),
                    AppBar(
                      backgroundColor: Colors.white70,
                      iconTheme: IconThemeData(
                        color: Color(0xff515151),
                      ),
                      shadowColor: Colors.transparent,
                      automaticallyImplyLeading: false,
                      title: Row(
                        children: [
                          SizedBox(width: 23),
                          Text(
                            'Your Profile',
                            style: GoogleFonts.boogaloo(
                                fontSize: 29, color: Color(0xff515151)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.white70,
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50.0,
                    ),
                    // photo
                    Align(
                      alignment: Alignment.topCenter,
                      child: getDefaultProfilePic(photoUrl, name, 50, true),
                    ),

                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      name,
                      style: GoogleFonts.boogaloo(
                        fontSize: 25,
                        letterSpacing: 2,
                        color: Color(0xff515151),
                        fontWeight: FontWeight.w200,
                      ),
                    ),

                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Address: $address",
                      style: GoogleFonts.boogaloo(
                        fontSize: 25,
                        letterSpacing: 2,
                        color: Color(0xff515151),
                        fontWeight: FontWeight.w200,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          contact,
                          style: GoogleFonts.boogaloo(
                            fontSize: 25,
                            letterSpacing: 2,
                            color: Color(0xff515151),
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
            );
          } else
            return Container();
        });
  }
}

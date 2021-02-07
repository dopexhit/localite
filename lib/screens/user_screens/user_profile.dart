import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localite/constants.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/user_data.dart';
import 'package:localite/screens/user_screens/user_side_bar.dart';
import 'package:localite/services/database.dart';
import 'package:localite/widgets/def_profile_pic.dart';
import 'package:localite/widgets/toast.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserData currentUser;

  @override
  Widget build(BuildContext context) {
    currentUser = GlobalUserDetail.userData;
    return StreamBuilder<DocumentSnapshot>(
        stream: DatabaseService().getUserProfile(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String photoUrl = snapshot.data.data()['photoUrl'].toString();
            String name = snapshot.data.data()['name'].toString();
            String contact = snapshot.data.data()['contact'].toString();
            return Scaffold(
              endDrawer: UserDrawer(),
              appBar: AppBar(backgroundColor: Color(0xfff0ffeb),
                  iconTheme: IconThemeData(color: Color(0xff515151),),
                  shadowColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  title: Text(
                    'Your Profile',
                    style: GoogleFonts.boogaloo(
                        fontSize: 27,
                        color: Color(0xff3d3f3f)),
                  ),
              ),
              backgroundColor: Color(0xfff0ffeb),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 50.0,),
                    // photo
                    Align(
                      alignment: Alignment.topCenter,
                      child: getDefaultProfilePic(photoUrl, name, 50),
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
                    Row(
                      children: [
                        SizedBox(
                          width: 100.0,
                        ),
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

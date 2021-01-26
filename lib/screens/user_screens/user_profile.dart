import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/user_data.dart';
import 'package:localite/screens/user_screens/user_side_bar.dart';
import 'package:localite/services/database.dart';
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
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // photo
                      Align(
                        alignment: Alignment.topCenter,
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.blueAccent,
                          child: ClipOval(
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: (photoUrl == 'null')
                                  ? Image.asset(
                                      'assets/images/default_profile_pic.jpg')
                                  : Image.network(photoUrl, fit: BoxFit.fill),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        name,
                        style: GoogleFonts.gabriela(
                          letterSpacing: 4,
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(
                        height: 12.0,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 30.0,
                          ),
                          Icon(Icons.phone),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            contact,
                            style: GoogleFonts.gabriela(
                              letterSpacing: 4,
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
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
              ),
            );
          } else
            return Container();
        });
  }
}

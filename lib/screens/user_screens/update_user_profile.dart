import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localite/constants.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/user_data.dart';
import 'package:localite/services/database.dart';
import 'package:localite/widgets/def_profile_pic.dart';
import 'package:localite/widgets/toast.dart';
import 'package:rive/rive.dart';

class UpdateUserProfile extends StatefulWidget {
  @override
  _UpdateUserProfileState createState() => _UpdateUserProfileState();
}

class _UpdateUserProfileState extends State<UpdateUserProfile> {
  UserData currentUser = GlobalUserDetail.userData;
  File _imageFile;
  String name;
  String contact;
  String photoUrl;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    UserDetails();
  }

  _getImage(BuildContext context, ImageSource source) async {
    final image = await ImagePicker.pickImage(source: source, maxWidth: 400.0);
    if (image != null) {
      final croppedImage = await ImageCropper.cropImage(
        sourcePath: image.path,
        compressQuality: 100,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: "Edit Image",
          toolbarColor: Color(0xffbbeaba),
          backgroundColor: Color(0xfff0ffeb),
          statusBarColor: Color(0xffbbeaba),
          toolbarWidgetColor: Colors.black87,
          activeControlsWidgetColor: Colors.green,
        ),
      );
      setState(() {
        _imageFile = croppedImage;
      });
    }
    Navigator.pop(context);
  }

  uploadPic(BuildContext context) async {
    // if(counter==0)await FirebaseFirestore.instance.collection('Users').doc(currentUser.uid).get().then((value) => oldPhotoUrl=value.data()['photoUrl'].toString());
    // counter++;//counter to tell how many times the pic has been changed since activity has started
    String fileName = _imageFile.path;
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((newImageDownloadUrl) {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .update({
        'photoUrl': newImageDownloadUrl,
      });
    });
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Color(0xfff0ffeb),
            height: 175.0,
            width: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Pick an Image",
                  style: GoogleFonts.boogaloo(
                    fontSize: 25,
                    letterSpacing: 2,
                    color: Colors.black87,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                FlatButton(
                  child: Text(
                    "Use Camera",
                    style: GoogleFonts.boogaloo(
                      fontSize: 20,
                      color: Color(0xff515151),
                    ),
                  ),
                  onPressed: () {
                    _getImage(context, ImageSource.camera);
                  },
                ),
                Padding(
                  //to make a horizontal line
                  padding: EdgeInsets.fromLTRB(50.0, 2.5, 50.0, 2.5),
                  child: Container(
                    color: Color(0xff515151),
                    height: 0.5,
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                  },
                  child: Text(
                    "From Gallery",
                    style: GoogleFonts.boogaloo(
                      fontSize: 20,
                      color: Color(0xff515151),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: DatabaseService().getUserProfile(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            photoUrl = snapshot.data.data()['photoUrl'].toString();
            name = snapshot.data.data()['name'].toString();
            contact = snapshot.data.data()['contact'].toString();
            return Scaffold(
              backgroundColor: Color(0xfff0ffeb),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 100.0,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: (_imageFile == null)
                            ? getDefaultProfilePic(photoUrl, name, 40.0, true)
                            : CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.green[300],
                                child: CircleAvatar(
                                  radius: 0.95 * 40,
                                  backgroundImage: FileImage(_imageFile),
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, right: 10),
                              child: Material(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                                color: Color(0xffbbeaba),
                                elevation: 4,
                                child: SizedBox(
                                  // height: 40.0,
                                  child: MaterialButton(
                                    onPressed: () => _openImagePicker(context),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.cloud_upload_rounded,
                                          size: 17.0,
                                        ),
                                        SizedBox(
                                          width: 7.0,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Upload New Image',
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
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10, right: 20),
                              child: Material(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                                color: Color(0xffbbeaba),
                                elevation: 4,
                                child: SizedBox(
                                  child: MaterialButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(currentUser.uid)
                                          .update({
                                        'photoUrl': null,
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete_forever_sharp,
                                          size: 17.0,
                                        ),
                                        SizedBox(
                                          width: 7.0,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Delete Image',
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
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                        child: Row(
                          children: [
                            Text(
                              'Name: ',
                              style: GoogleFonts.boogaloo(
                                fontSize: 20,
                                color: Color(0xff515151),
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            SizedBox(
                              width: 200.0,
                              height: 30.0,
                              child: TextFormField(
                                initialValue: name,
                                style: GoogleFonts.boogaloo(
                                  fontSize: 20,
                                  color: Color(0xff515151),
                                ),
                                // decoration: InputDecoration(
                                //   border: InputBorder.none,
                                // ),
                                onChanged: (val) {
                                  name = val;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                        child: Row(
                          children: [
                            Text(
                              'Contact: ',
                              style: GoogleFonts.boogaloo(
                                fontSize: 20,
                                color: Color(0xff515151),
                              ),
                            ),
                            SizedBox(
                              width: 13.0,
                            ),
                            SizedBox(
                              width: 200.0,
                              height: 30.0,
                              child: TextFormField(
                                initialValue: contact,
                                style: GoogleFonts.boogaloo(
                                  fontSize: 20,
                                  color: Color(0xff515151),
                                ),
                                // decoration: InputDecoration(
                                //   border: InputBorder.none,
                                // ),
                                keyboardType: TextInputType.number,
                                onChanged: (val) {
                                  contact = val;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 75.0,
                      ),
                      Material(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        color: Color(0xffbbeaba),
                        elevation: 4,
                        child: SizedBox(
                          height: 40,
                          child: MaterialButton(
                              child: Text(
                                'Save',
                                style: GoogleFonts.boogaloo(
                                  fontSize: 20,
                                  color: Color(0xff515151),
                                ),
                              ),
                              elevation: 4,
                              onPressed: () async {
                                if (name == null || contact == null)
                                  MyToast().getToastBottom(
                                      'Fields cant be left empty');
                                else {
                                  await uploadPic(context);
                                  await FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(currentUser.uid)
                                      .update({
                                    'name': name,
                                    'contact': contact,
                                  });
                                  Navigator.pop(context);
                                }
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Material(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        color: Color(0xffF5C0AE),
                        elevation: 4,
                        child: SizedBox(
                          height: 40,
                          child: MaterialButton(
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.boogaloo(
                                  fontSize: 20,
                                  color: Color(0xff515151),
                                ),
                              ),
                              elevation: 4,
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
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

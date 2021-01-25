import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/service_provider_data.dart';
import 'package:localite/models/user_data.dart';
import 'package:localite/screens/service_provider_screens/service_prov_side_bar.dart';
import 'file:///D:/Android/localite/lib/screens/user_screens/user_side_bar.dart';
import 'package:localite/services/database.dart';
import 'package:localite/widgets/toast.dart';
import 'package:provider/provider.dart';

class SPProfile extends StatefulWidget {
  @override
  _SPProfileState createState() => _SPProfileState();
}

class _SPProfileState extends State<SPProfile> {
  File _imageFile;
  ServiceProviderData currentSP;

  _getImage(BuildContext context,ImageSource source) async{
    final image=await ImagePicker.pickImage(source: source, maxWidth: 400.0);
    setState(() {
      _imageFile=image;
    });
    await uploadPic(context);
    Navigator.pop(context);
  }
  uploadPic(BuildContext context) async {
    String fileName = _imageFile.path;
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((newImageDownloadUrl){
      FirebaseFirestore.instance.collection(currentSP.service).doc(currentSP.uid).update({
        'photoUrl': newImageDownloadUrl,
      });
    });
  }

  // user can choose camera as well as gallery to upload their profile picture
  void _openImagePicker(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return Container(
            height: 150.0,
            width: 300.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Pick an Image",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0,),
                FlatButton(
                  child: Text(
                    "Use Camera",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: (){
                    _getImage(context, ImageSource.camera);
                  },
                ),
                SizedBox(height: 5.0,),
                FlatButton(
                  onPressed: (){
                    _getImage(context, ImageSource.gallery);
                  },
                  child: Text(
                    "From Gallery",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    currentSP=GlobalServiceProviderDetail.spData;
    return StreamBuilder<DocumentSnapshot>(
        stream: DatabaseService().getSPProfile(currentSP.uid,currentSP.service),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            String photoUrl=snapshot.data.data()['photoUrl'].toString();
            return Scaffold(
              endDrawer: SPDrawer(),
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
                              child: (photoUrl=='null')?
                              Image.asset('assets/images/default_profile_pic.jpg'):
                              Image.network(photoUrl,fit: BoxFit.fill),
                            ),
                          ),
                        ),
                      ),

                      // icon button to pick image from camera or gallery
                      Align(
                        alignment: Alignment.topCenter,
                        child: FlatButton.icon(
                          onPressed: () {
                            _openImagePicker(context);
                          },
                          icon: Icon(Icons.add_a_photo),
                          label: Text(""),
                        ),
                      ),


                      SizedBox(height: 12.0,),
                      Text(
                        "${currentSP.name}",
                        style: GoogleFonts.gabriela(
                          letterSpacing: 4,
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 12.0,),
                      Text("Address: ${currentSP.address}",
                        style: GoogleFonts.gabriela(
                          letterSpacing: 4,
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 12.0,),
                      Row(
                        children: [
                          SizedBox(width: 50.0,),
                          Icon(Icons.phone),
                          SizedBox(width: 20.0,),
                          Text(
                            "${currentSP.contact}",
                            style: GoogleFonts.gabriela(
                              letterSpacing: 4,
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24,),
                    ],
                  ),
                ),
              ),
            );
          }
          else return Container();
        }
    );
  }
}

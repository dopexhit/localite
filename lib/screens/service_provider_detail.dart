import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/service_provider_data.dart';
import 'package:localite/models/user_data.dart';
import 'package:localite/screens/chat_room.dart';
import 'package:localite/screens/show_allrequest_user.dart';
import 'package:localite/screens/user_request_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:simple_location_picker/simple_location_picker_screen.dart';
import 'package:url_launcher/url_launcher.dart';

final _firestore = FirebaseFirestore.instance;
User loggedUser;

class SPDetail extends StatefulWidget {
  final ServiceProviderData currentSp;
  SPDetail({this.currentSp});
  @override
  _SPDetailState createState() => _SPDetailState();
}

_makePhoneCall(String contact) async {
  final url = 'tel:$contact';
  print(url);
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class _SPDetailState extends State<SPDetail> {
  bool pendingReq = false;
  bool asyncCall = true;

  @override
  void initState() {
    super.initState();
    checkRequest();
  }

  void checkRequest() {
    UserData data =
        Provider.of<UserDetails>(GlobalContext.context).getUserDetails;

    var docRef = _firestore
        .collection('requests')
        .doc(data.uid + '-' + widget.currentSp.uid)
        .collection('pending');

    docRef.get().then((value) {
      if (value.docs.isEmpty) {
        setState(() {
          pendingReq = false;
        });
      } else {
        setState(() {
          pendingReq = true;
        });
      }
    });

    asyncCall = false;
  }

  @override
  Widget build(BuildContext context) {
    final loggedUser = Provider.of<CustomUser>(context);
    return ModalProgressHUD(
      inAsyncCall: asyncCall,
      child: Scaffold(
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            children: [
              Text('Name: ' + widget.currentSp.name),
              SizedBox(height: 20),
              Text('Address: ' + widget.currentSp.address),
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 40),
                  IconButton(
                      icon: Icon(Icons.call),
                      onPressed: () async =>
                          _makePhoneCall(widget.currentSp.contact.toString())),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Icon(Icons.message),
                    onPressed: () {
                      String roomId =
                          loggedUser.uid + '-' + widget.currentSp.uid;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatRoom(
                                    roomId: roomId,
                                    receiver: widget.currentSp,
                                    userUid: loggedUser.uid,
                                    spUid: widget.currentSp.uid,
                                  )));
                    },
                  ),
                ],
              ),
              RaisedButton(
                  child: Text('Locate on map'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SimpleLocationPicker(
                                  initialLatitude: widget.currentSp.latitude,
                                  initialLongitude: widget.currentSp.longitude,
                                  appBarTitle: "Display Location",
                                  displayOnly: true,
                                )));
                  }),
              Visibility(
                visible: !pendingReq,
                child: RaisedButton(
                    child: Text('Request home service'),
                    onPressed: () {
                      String requestId =
                          loggedUser.uid + '-' + widget.currentSp.uid;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserRequestScreen(
                                  requestID: requestId,
                                  receiver: widget.currentSp))).then((result) {
                        checkRequest();
                      });
                      //  checkRequest();
                    }),
              ),
              Visibility(
                  visible: pendingReq,
                  child: Padding(
                    padding: EdgeInsets.only(top: 200),
                    child: Text(
                      'You have a pending request...',
                      style: TextStyle(color: Colors.red),
                    ),
                  )),
              RaisedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserRequests()));
                },
                child: Text('all requests'),
              )
            ],
          ),
        )),
      ),
    );
  }
}

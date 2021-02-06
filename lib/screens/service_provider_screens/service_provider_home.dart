import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localite/constants.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/screens/selection_screen.dart';
import 'package:localite/screens/service_provider_screens/sp_pending_request_detailed_screen.dart';
import 'package:localite/screens/service_provider_screens/sp_accepted_requests_detailed.dart';
import 'package:localite/services/auth.dart';
import 'package:localite/services/shared_pref.dart';
import 'package:localite/widgets/def_profile_pic.dart';
import 'package:localite/widgets/toast.dart';

final _firestore = FirebaseFirestore.instance;
User loggedUser;

class ServiceProviderHomeScreen extends StatefulWidget {
  @override
  _ServiceProviderHomeScreenState createState() =>
      _ServiceProviderHomeScreenState();
}

class _ServiceProviderHomeScreenState extends State<ServiceProviderHomeScreen> {
  final _auth = FirebaseAuth.instance;

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
      } else {
        MyToast().getToastBottom('failed!');
      }
    } catch (e) {
      MyToast().getToastBottom(e.message.toString());
    }
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
          child: Center(
              child: Column(
            children: [
              Expanded(
                  child: Container(
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                child: Padding(
                  padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Pending requests',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 25),
                      TileStreamPending(),
                    ],
                  ),
                ),
              )),
            ],
          )),
        ),
      ),
    );
  }
}

class TileStreamPending extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Service Providers')
          .doc(loggedUser.uid)
          .collection('requests')
          .orderBy('lastRequest', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userListOfRequests = snapshot.data.docs;
          List<MessageTile> tiles = [];

          for (var doc in userListOfRequests) {
            if (doc.data()['pending'] == true) {
              final tile = MessageTile(
                uid: doc.data()['uid'],
                name: doc.data()['name'],
                timestamp: doc.data()['lastRequest'],
                type: 'pending',
              );
              tiles.add(tile);
            }
          }
          return Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
              children: tiles,
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
      },
    );
  }
}

class MessageTile extends StatefulWidget {
  final uid;
  final Timestamp timestamp;
  final String name;
  final String type;

  MessageTile({this.uid, this.timestamp, this.name, this.type});

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  String url;
  @override
  void initState() {
    super.initState();
    getPhoto();
    SPDetails();
  }

  void getPhoto() {
    _firestore.collection('Users').doc(widget.uid).get().then((value) {
      String photo = value.data()['photoUrl'].toString();
      setState(() {
        url = photo;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int hour = widget.timestamp.toDate().hour.toInt();
    int minute = widget.timestamp.toDate().minute.toInt();
    final String time = (hour > 9 ? hour.toString() : '0' + hour.toString()) +
        ':' +
        (minute > 9 ? minute.toString() : '0' + minute.toString());

    return RawMaterialButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SPPendingRequestDetail(
                      requestID: widget.uid + '-' + loggedUser.uid,
                      userUID: widget.uid,
                      spUID: loggedUser.uid,
                    )));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Container(
          child: Column(
            children: [
              //todo: add profile image
              Row(
                children: [
                  getDefaultProfilePic(url, widget.name, 20),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 7),
                      ],
                    ),
                  ),
                  Text(time),
                ],
              ),
              SizedBox(height: 11),
              Divider(
                height: 5,
                color: Colors.black54,
              )
            ],
          ),
        ),
      ),
    );
  }
}

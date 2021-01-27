import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/screens/service_provider_screens/sp_accepted_requests_detailed.dart';

final _firestore = FirebaseFirestore.instance;

String serviceProviderUID = GlobalServiceProviderDetail.spData.uid;

class SPAcceptedRequests extends StatefulWidget {
  @override
  _SPAcceptedRequestsState createState() => _SPAcceptedRequestsState();
}

class _SPAcceptedRequestsState extends State<SPAcceptedRequests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Expanded(
            child: Padding(
          padding: EdgeInsets.only(top: 20, left: 8, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Accepted requests',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 20),
              TileStreamCompleted(),
            ],
          ),
        )),
      ),
    );
  }
}

class TileStreamCompleted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Service Providers')
          .doc(serviceProviderUID)
          .collection('requests')
          .orderBy('lastRequest', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userListOfRequests = snapshot.data.docs;
          List<MessageTile> tiles = [];

          for (var doc in userListOfRequests) {
            if (doc.data()['completed'] == true) {
              final tile = MessageTile(
                uid: doc.data()['uid'],
                name: doc.data()['name'],
                timestamp: doc.data()['lastRequest'],
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

  MessageTile({this.uid, this.timestamp, this.name});

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  String url;
  @override
  void initState() {
    super.initState();
    getPhoto();
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
                builder: (context) => SPShowAllCompletedRequests(
                      requestId: widget.uid + '-' + serviceProviderUID,
                      userUid: widget.uid,
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
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: (url.toString() == 'null')
                        ? AssetImage('assets/images/default_profile_pic.jpg')
                        : NetworkImage(url),
                  ),
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

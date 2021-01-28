import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localite/constants.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/screens/user_screens/user_accepted_request_detailed.dart';
import 'package:localite/screens/user_screens/user_pending_request_detailed.dart';
import 'package:localite/widgets/def_profile_pic.dart';

final _firestore = FirebaseFirestore.instance;

String userUID = GlobalUserDetail.userData.uid;

class UserPendingRequests extends StatefulWidget {
  @override
  _UserPendingRequestsState createState() => _UserPendingRequestsState();
}

class _UserPendingRequestsState extends State<UserPendingRequests> {
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
                'Pending requests',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 20),
              TileStreamPending(),
            ],
          ),
        )),
      ),
    );
  }
}

class TileStreamPending extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Users')
          .doc(userUID)
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
                service: doc.data()['service'],
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
  final service;
  final String type;

  MessageTile({this.uid, this.timestamp, this.name, this.service, this.type});

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
    _firestore.collection(widget.service).doc(widget.uid).get().then((value) {
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
                builder: (context) => UserPendingRequestDetailed(
                      requestId: userUID + '-' + widget.uid,
                      userUid: userUID,
                      spUid: widget.uid,
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
                        Text(
                          widget.service,
                          style: TextStyle(color: Colors.black54),
                        )
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

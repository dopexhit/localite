import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/screens/user_screens/user_accepted_request_detailed.dart';

final _firestore = FirebaseFirestore.instance;

String userUID = GlobalUserDetail.userData.uid;

class UserAcceptedRequests extends StatefulWidget {
  @override
  _UserAcceptedRequestsState createState() => _UserAcceptedRequestsState();
}

class _UserAcceptedRequestsState extends State<UserAcceptedRequests> {
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
            if (doc.data()['completed'] == true) {
              final tile = MessageTile(
                uid: doc.data()['uid'],
                name: doc.data()['name'],
                service: doc.data()['service'],
                timestamp: doc.data()['lastRequest'],
                type: 'completed',
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

class MessageTile extends StatelessWidget {
  final uid;
  final Timestamp timestamp;
  final String name;
  final service;
  final String type;

  MessageTile({this.uid, this.timestamp, this.name, this.service, this.type});

  @override
  Widget build(BuildContext context) {
    int hour = timestamp.toDate().hour.toInt();
    int minute = timestamp.toDate().minute.toInt();
    final String time = (hour > 9 ? hour.toString() : '0' + hour.toString()) +
        ':' +
        (minute > 9 ? minute.toString() : '0' + minute.toString());

    return RawMaterialButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserAcceptedRequestDetailed(
                      requestId: userUID + '-' + uid,
                      typeOfRequest: type,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 7),
                        Text(
                          service,
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localite/screens/request_detailed_user.dart';
import 'package:localite/widgets/toast.dart';

final _firestore = FirebaseFirestore.instance;
User loggedUser;

class UserRequests extends StatefulWidget {
  @override
  _UserRequestsState createState() => _UserRequestsState();
}

class _UserRequestsState extends State<UserRequests> {
  final _auth = FirebaseAuth.instance;

  bool pendingVisibility = true;
  bool completedVisibility = true;
  int flexPending = 1;
  int flexCompleted = 1;
  bool pendingIconDown = true;
  bool completedIconDown = true;
  IconData pendingIcon = Icons.keyboard_arrow_down_rounded;
  IconData completedIcon = Icons.keyboard_arrow_down_rounded;

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
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            Expanded(
                flex: flexPending,
                child: Visibility(
                    visible: pendingVisibility,
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 5),
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
                              SizedBox(height: 8),
                              TileStreamPending(),
                              SizedBox(
                                height: 30,
                                child: RawMaterialButton(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        pendingIcon,
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      flexCompleted = (flexCompleted + 1) % 2;
                                      completedVisibility =
                                          !completedVisibility;
                                      if (pendingIconDown == true) {
                                        pendingIconDown = false;
                                        pendingIcon =
                                            Icons.keyboard_arrow_up_rounded;
                                      } else {
                                        pendingIconDown = true;
                                        pendingIcon =
                                            Icons.keyboard_arrow_down_rounded;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))),
            Expanded(
                flex: flexCompleted,
                child: Visibility(
                    visible: completedVisibility,
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 5, bottom: 20),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'History',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(height: 8),
                              TileStreamCompleted(),
                              SizedBox(
                                height: 30,
                                child: RawMaterialButton(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        completedIcon,
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      flexPending = (flexPending + 1) % 2;
                                      pendingVisibility = !pendingVisibility;
                                      if (completedIconDown == true) {
                                        completedIconDown = false;
                                        completedIcon =
                                            Icons.keyboard_arrow_up_rounded;
                                      } else {
                                        completedIconDown = true;
                                        completedIcon =
                                            Icons.keyboard_arrow_down_rounded;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )))
          ],
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

class TileStreamCompleted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Users')
          .doc(loggedUser.uid)
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
                timestamp: doc.data()['lastMsg'],
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
                builder: (context) => UserRequestDetailed(
                      requestId: loggedUser.uid + '-' + uid,
                      typeOfRequest: type,
                    )));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Container(
          child: Column(
            children: [
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

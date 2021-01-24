import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/user_data.dart';
import 'package:localite/screens/user_home.dart';
import 'package:localite/widgets/toast.dart';
import 'package:provider/provider.dart';

import 'chat_room.dart';

final _firestore = FirebaseFirestore.instance;
User loggedUser;

class UserChatList extends StatefulWidget {
  @override
  _UserChatListState createState() => _UserChatListState();
}

class _UserChatListState extends State<UserChatList> {
  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();
  String message;

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
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Expanded(child: TileStream()),
      ),
    );
  }
}

class TileStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Users')
          .doc(loggedUser.uid)
          .collection('listOfChats')
          .orderBy('lastMsg', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userListOfChats = snapshot.data.docs;
          List<MessageTile> tiles = [];

          for (var chatDetail in userListOfChats) {
            final tile = MessageTile(
              uid: chatDetail.data()['uid'],
              name: chatDetail.data()['name'],
              service: chatDetail.data()['service'],
              timestamp: chatDetail.data()['lastMsg'],
            );
            tiles.add(tile);
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
  final String service;

  MessageTile({this.uid, this.timestamp, this.name, this.service});

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
                builder: (context) => ChatRoom(
                      roomId: loggedUser.uid + '-' + uid,
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
                        ),
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

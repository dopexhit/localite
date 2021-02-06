import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localite/constants.dart';
import 'package:localite/widgets/def_profile_pic.dart';
import 'package:localite/widgets/toast.dart';

import '../chat_room.dart';

final _firestore = FirebaseFirestore.instance;
User loggedUser;

class SPChatList extends StatefulWidget {
  @override
  _SPChatListState createState() => _SPChatListState();
}

class _SPChatListState extends State<SPChatList> {
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
      // appBar: AppBar(
      //   title: Text('Chats'),
      // ),
      backgroundColor: Color(0xfff0ffeb),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 5),
                child: Text(
                  'Your chats',
                  style: GoogleFonts.boogaloo(
                      fontSize: 27, color: Color(0xff3d3f3f)),
                ),
              ),
              TileStream(),
            ],
          ),
        ),
      ),
    );
  }
}

class TileStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Service Providers')
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

    int day = widget.timestamp.toDate().day;
    int month = widget.timestamp.toDate().month;
    int year = widget.timestamp.toDate().year;

    Timestamp todayStamp = Timestamp.now();
    int tday = todayStamp.toDate().day;
    int tmonth = todayStamp.toDate().month;
    int tyear = todayStamp.toDate().year;

    String date = (day > 9 ? day.toString() : '0' + day.toString()) +
        '/' +
        (month > 9 ? month.toString() : '0' + month.toString()) +
        '/' +
        year.toString();

    String todayDate = (tday > 9 ? tday.toString() : '0' + tday.toString()) +
        '/' +
        (tmonth > 9 ? tmonth.toString() : '0' + tmonth.toString()) +
        '/' +
        tyear.toString();

    return RawMaterialButton(
      onPressed: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatRoom(
                      roomId: widget.uid + '-' + loggedUser.uid,
                      userUid: widget.uid,
                      spUid: loggedUser.uid,
                      receiverName: widget.name,
                      url: url,
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
                  getDefaultProfilePic(url, widget.name, 20.0),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: GoogleFonts.boogaloo(
                              fontSize: 21,
                              color: Color(0xff3d3f3f),
                              letterSpacing: 0.8), //TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 7),
                      ],
                    ),
                  ),
                  Text(
                    date == todayDate ? time : date,
                    style: GoogleFonts.boogaloo(
                        color: Colors.black54,
                        // fontSize: 14.5,
                        letterSpacing: 0.5),
                  ),
                ],
              ),
              SizedBox(height: 11),
              Divider(
                height: 5,
                color: Colors.black54,
                indent: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}

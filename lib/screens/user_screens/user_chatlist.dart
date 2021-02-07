import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localite/constants.dart';
import 'package:localite/widgets/def_profile_pic.dart';
import 'package:localite/widgets/toast.dart';

import '../chat_room.dart';

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
      backgroundColor: Colors.white70,
      body: SafeArea(
        child: Stack(
          children: [
            SvgPicture.asset('assets/images/design.svg'),
            Padding(
              padding: EdgeInsets.only(left: 4, right: 4, top: 7),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 15, bottom: 5, left: 35, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your chats',
                          style: GoogleFonts.boogaloo(
                              fontSize: 29, color: Color(0xff515151)),
                        ),
                        SizedBox(
                            height: 32,
                            width: 32,
                            child:
                                SvgPicture.asset('assets/images/appIcon.svg'))
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  TileStream(),
                ],
              ),
            ),
          ],
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
            child: Scrollbar(
              radius: Radius.circular(5),
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
                children: tiles,
              ),
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
  final String service;

  MessageTile({this.uid, this.timestamp, this.name, this.service});

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
    int day = widget.timestamp.toDate().day;
    int month = widget.timestamp.toDate().month;
    int year = widget.timestamp.toDate().year;

    Timestamp todayStamp = Timestamp.now();
    int tday = todayStamp.toDate().day;
    int tmonth = todayStamp.toDate().month;
    int tyear = todayStamp.toDate().year;
    final String time = (hour > 9 ? hour.toString() : '0' + hour.toString()) +
        ':' +
        (minute > 9 ? minute.toString() : '0' + minute.toString());

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
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatRoom(
                      roomId: loggedUser.uid + '-' + widget.uid,
                      userUid: loggedUser.uid,
                      spUid: widget.uid,
                      receiverName: widget.name,
                      url: url,
                    )));
      },
      child: Padding(
        padding: EdgeInsets.only(left: 7, right: 7),
        child: Card(
          color: Color(0xfff0ffeb),
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.only(left: 12.0, right: 12, top: 8, bottom: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    getDefaultProfilePic(url, widget.name, 20),
                    SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: GoogleFonts.boogaloo(
                                fontSize: 21,
                                color: Color(0xff515151),
                                letterSpacing: 0.5), //TextStyle(fontSize: 20),
                          ),
                          Text(
                            widget.service,
                            style: GoogleFonts.boogaloo(
                                color: Colors.black54,
                                fontSize: 14.5,
                                letterSpacing: 0.5),
                          ),
                          SizedBox(height: 5)
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

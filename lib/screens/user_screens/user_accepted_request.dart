import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localite/constants.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/screens/user_screens/user_accepted_request_detailed.dart';
import 'package:localite/widgets/def_profile_pic.dart';

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
        child: Stack(
          children: [
            SvgPicture.asset('assets/images/design.svg'),
            Padding(
              padding: EdgeInsets.only(top: 7, left: 4, right: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 15, bottom: 5, left: 35, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Accepted requests',
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
                  TileStreamCompleted(),
                ],
              ),
            ),
          ],
        ),
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
            child: Padding(
              padding: EdgeInsets.only(bottom: 14),
              child: Scrollbar(
                radius: Radius.circular(5),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  children: tiles,
                ),
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
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserAcceptedRequestDetailed(
                      requestId: userUID + '-' + widget.uid,
                      typeOfRequest: widget.type,
                      spUid: widget.uid,
                      url: url,
                      name: widget.name,
                      service: widget.service,
                    )));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 0),
        child: Card(
          elevation: 3,
          color: Color(0xfff0ffeb),
          child: Padding(
            padding: EdgeInsets.only(left: 12.0, right: 12, top: 8, bottom: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    getDefaultProfilePic(url, widget.name, 20, false),
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
                                letterSpacing: 0.5),
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

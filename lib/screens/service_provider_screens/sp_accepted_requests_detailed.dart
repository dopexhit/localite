import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localite/widgets/def_profile_pic.dart';
import 'package:url_launcher/url_launcher.dart';

final _firestore = FirebaseFirestore.instance;

String userUID;

String contact = '';

class SPShowAllCompletedRequests extends StatelessWidget {
  final String requestId;
  final String userUid;
  final String url;
  final String name;

  SPShowAllCompletedRequests(
      {this.requestId, this.userUid, this.url, this.name});

  _makePhoneCall(String contact) async {
    final url = 'tel:$contact';
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    userUID = userUid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffbbeaba),
        iconTheme: IconThemeData(color: Colors.black54),
        leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.pop(context);
            }),
        title: Text(
          'History',
          style: GoogleFonts.boogaloo(
            fontSize: 26,
            color: Colors.black54,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 15, left: 10, right: 10, top: 20),
          child: Column(
            children: [
              getDefaultProfilePic(url, name, 33, true),
              SizedBox(height: 5),
              Text(
                name,
                style: GoogleFonts.boogaloo(
                  fontSize: 22,
                  color: Colors.black54,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Reach Out:',
                    style: GoogleFonts.boogaloo(
                      fontSize: 22,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    child: Image.asset(
                      'assets/images/call_icon.png',
                      width: 23.0,
                      height: 30.0,
                    ),
                    onTap: () async {
                      _makePhoneCall(contact);
                    },
                  ),
                ],
              ),
              SizedBox(height: 15),
              TileStream(
                id: requestId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TileStream extends StatelessWidget {
  final String id;

  TileStream({this.id});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('requests')
          .doc(id)
          .collection('completed')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userListOfRequests = snapshot.data.docs;
          List<MessageTile> tiles = [];

          for (var doc in userListOfRequests) {
            contact = doc.data()['contact'];
            final tile = MessageTile(
              address: doc.data()['address'],
              description: doc.data()['description'],
              timestamp: doc.data()['timestamp'],
            );
            tiles.add(tile);
          }
          return Expanded(
            child: Scrollbar(
              radius: Radius.circular(5),
              child: ListView(
                padding: EdgeInsets.only(left: 15, right: 15),
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

class MessageTile extends StatelessWidget {
  final String address;
  final Timestamp timestamp;

  final String description;

  MessageTile({
    this.address,
    this.timestamp,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    int hour = timestamp.toDate().hour.toInt();
    int minute = timestamp.toDate().minute.toInt();
    int day = timestamp.toDate().day;
    int month = timestamp.toDate().month;
    int year = timestamp.toDate().year;
    final String time = (hour > 9 ? hour.toString() : '0' + hour.toString()) +
        ':' +
        (minute > 9 ? minute.toString() : '0' + minute.toString());
    String date = (day > 9 ? day.toString() : '0' + day.toString()) +
        '/' +
        (month > 9 ? month.toString() : '0' + month.toString()) +
        '/' +
        year.toString();

    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 15),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text('$date, $time',
                    style: GoogleFonts.boogaloo(
                      fontSize: 15,
                      color: Colors.black54,
                    )),
              ),
              SizedBox(height: 10),
              Text('Work description: $description',
                  style: GoogleFonts.boogaloo(
                    fontSize: 17,
                    color: Colors.black54,
                  )),
              SizedBox(height: 10),
              Text('Your service address: $address',
                  style: GoogleFonts.boogaloo(
                    fontSize: 17,
                    color: Colors.black54,
                  )),
              SizedBox(height: 15),
              Center(
                child: SizedBox(
                  width: 220,
                  child: Divider(thickness: 1, color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

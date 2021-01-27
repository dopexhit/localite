import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localite/widgets/toast.dart';

final _firestore = FirebaseFirestore.instance;

String spUID;

class UserAcceptedRequestDetailed extends StatefulWidget {
  final String requestId;
  final String typeOfRequest;
  final String spUid;

  UserAcceptedRequestDetailed({this.requestId, this.typeOfRequest, this.spUid});
  @override
  _UserAcceptedRequestDetailedState createState() =>
      _UserAcceptedRequestDetailedState();
}

class _UserAcceptedRequestDetailedState
    extends State<UserAcceptedRequestDetailed> {
  @override
  Widget build(BuildContext context) {
    spUID = widget.spUid;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: TileStream(
            type: widget.typeOfRequest,
            id: widget.requestId,
          ),
        ),
      ),
    );
  }
}

class TileStream extends StatelessWidget {
  final String type;
  final String id;
  TileStream({this.type, this.id});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('requests')
          .doc(id)
          .collection(type)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userListOfRequests = snapshot.data.docs;
          List<MessageTile> tiles = [];

          for (var doc in userListOfRequests) {
            final tile = MessageTile(
              address: doc.data()['address'],
              description: doc.data()['description'],
              providerName: doc.data()['service provider'],
              service: doc.data()['service'],
              spContact: doc.data()['sp contact'],
              timestamp: doc.data()['timestamp'],
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
  final String address;
  final Timestamp timestamp;
  final String providerName;
  final String service;
  final String description;
  final String spContact;

  MessageTile(
      {this.address,
      this.timestamp,
      this.providerName,
      this.service,
      this.description,
      this.spContact});

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
    _firestore.collection(widget.service).doc(spUID).get().then((value) {
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
    final String time = (hour > 9 ? hour.toString() : '0' + hour.toString()) +
        ':' +
        (minute > 9 ? minute.toString() : '0' + minute.toString());
    String date = (day > 9 ? day.toString() : '0' + day.toString()) +
        '/' +
        (month > 9 ? month.toString() : '0' + month.toString()) +
        '/' +
        year.toString();

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //todo: add profile image
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: (url.toString() == 'null')
                            ? AssetImage(
                                'assets/images/default_profile_pic.jpg')
                            : NetworkImage(url),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        widget.providerName,
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                  SizedBox(height: 7),
                  Text(
                    widget.service,
                    style: TextStyle(color: Colors.black54, fontSize: 17),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Work description: ${widget.description}',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your service address: ${widget.address}',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.call),
                      SizedBox(width: 10),
                      Text(
                        widget.spContact,
                        style: TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(date),
                SizedBox(height: 5),
                Text(time),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

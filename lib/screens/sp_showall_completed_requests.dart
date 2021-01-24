import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;

class SPShowAllCompletedRequests extends StatelessWidget {
  final String requestId;

  SPShowAllCompletedRequests({this.requestId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: TileStream(
            id: requestId,
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
            final tile = MessageTile(
              address: doc.data()['address'],
              description: doc.data()['description'],
              userName: doc.data()['user name'],
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

class MessageTile extends StatelessWidget {
  final String address;
  final Timestamp timestamp;
  final String userName;
  final String description;

  MessageTile({this.address, this.timestamp, this.userName, this.description});

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
    String date = (day > 9 ? hour.toString() : '0' + day.toString()) +
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Work description: $description',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your service address: $address',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
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
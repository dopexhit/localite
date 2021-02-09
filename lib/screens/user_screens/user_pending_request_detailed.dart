import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localite/constants.dart';
import 'package:localite/widgets/def_profile_pic.dart';
import 'package:url_launcher/url_launcher.dart';

import '../chat_room.dart';

final _firestore = FirebaseFirestore.instance;
String userUID;
String spUID;
String requestID;

class UserPendingRequestDetailed extends StatefulWidget {
  final String requestId;
  final String userUid;
  final String spUid;

  UserPendingRequestDetailed({this.requestId, this.userUid, this.spUid});
  @override
  _UserPendingRequestDetailedState createState() =>
      _UserPendingRequestDetailedState();
}

class _UserPendingRequestDetailedState
    extends State<UserPendingRequestDetailed> {
  @override
  void initState() {
    super.initState();
    userUID = widget.userUid;
    spUID = widget.spUid;
    requestID = widget.requestId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Column(
          children: [
            SizedBox(height: 7),
            AppBar(
              backgroundColor: Color(0xffbbeaba),
              iconTheme: IconThemeData(
                color: Color(0xff515151),
              ),
              automaticallyImplyLeading: false,
              leading: GestureDetector(
                  child: Icon(Icons.arrow_back_ios),
                  onTap: () {
                    Navigator.pop(context);
                  }),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: Svg('assets/images/appIcon.svg'),height: 20.0,width: 20.0,),
                  SizedBox(width: 10),
                  Text(
                    'sAmigo',
                    style: GoogleFonts.boogaloo(
                        fontSize: 29, color: Color(0xff515151)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xfff0ffeb),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical:0, horizontal: 0),
          child: TileStream(
            type: 'pending',
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
              //padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
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

    //todo: add profile image
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: Svg('assets/images/details_background.svg'),
            fit: BoxFit.cover,
          )
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(date,style: GoogleFonts.boogaloo(
                    color: Color(0xff3d3f3f)),),
                SizedBox(height: 5),
                Text(time,style: GoogleFonts.boogaloo(
                    color: Color(0xff3d3f3f)),),
              ],
            ),
            Align(
                alignment: Alignment.topLeft,
                child: getDefaultProfilePic(url, widget.providerName, 40,true)),
            SizedBox(
              height: 10.0,
            ),
            Text(
              widget.providerName,
              style: GoogleFonts.boogaloo(
                  fontSize: 30,
                  color: Color(0xff3d3f3f)),
            ),
            SizedBox(height: 7),
            Text(
              widget.service,
              style: GoogleFonts.boogaloo(
                  fontSize: 20,
                  color: Color(0xff3d3f3f)),
            ),
            SizedBox(height: 40),
            Text(
              'Work description :  ${widget.description}',
              style: GoogleFonts.boogaloo(
                  fontSize: 18,
                  color: Color(0xff3d3f3f)),
            ),
            SizedBox(height: 10),
            Text(
              'Your service address :  ${widget.address}',
              style: GoogleFonts.boogaloo(
                  fontSize: 18,
                  color: Color(0xff3d3f3f)),
            ),
            SizedBox(height: 30,),
            Text('Reach Out :',
              textAlign: TextAlign.center,
              style: GoogleFonts.boogaloo(
                fontSize: 20,
                color: Color(0xff3d3f3f),
            ),),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                    child: GestureDetector(
                      child: Image.asset('assets/images/call_icon.png',width: 30.0, height: 30.0,),
                      onTap: ()async{
                        _makePhoneCall(widget.spContact.toString());
                      },
                    )),
                Expanded(
                    child:GestureDetector(
                      child: Image.asset('assets/images/message_bubble.png',width: 30.0, height:30.0,),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatRoom(
                                    roomId: requestID,
                                    userUid: userUID,
                                    receiverName: widget.providerName,
                                    url: url,
                                    spUid: spUID)));
                      },
                    ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

_makePhoneCall(String contact) async {
  final url = 'tel:$contact';
  print(url);
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

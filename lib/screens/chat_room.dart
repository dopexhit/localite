import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;
import 'package:google_fonts/google_fonts.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/service_provider_data.dart';
import 'package:localite/models/user_data.dart';
import 'package:localite/services/shared_pref.dart';
import 'package:localite/services/wrapper.dart';
import 'package:localite/widgets/def_profile_pic.dart';
import 'package:localite/widgets/toast.dart';
import '../constants.dart';

final _firestore = FirebaseFirestore.instance;
User loggedUser;
String userUID;
String spUID;

class ChatRoom extends StatefulWidget {
  final String roomId;
  final receiver;
  final userUid;
  final spUid;
  final String receiverName;
  final String url;

  ChatRoom(
      {this.roomId,
      this.receiver,
      this.userUid,
      this.spUid,
      this.url = '',
      this.receiverName = ''});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();
  String message;

  @override
  void initState() {
    super.initState();

    userUID = widget.userUid;
    spUID = widget.spUid;
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedUser = user;
        print(user.email);
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
        backgroundColor: Color(0xffbbeaba),
        iconTheme: IconThemeData(color: Colors.black54),
        leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.pop(context);
            }),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            getDefaultProfilePic(widget.url, widget.receiverName, 18.5),
            SizedBox(
              width: 12,
            ),
            Text(
              widget.receiverName,
              style: GoogleFonts.boogaloo(fontSize: 25, color: Colors.black54),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xfff0ffeb),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/chatbg.png'),
            ),
          ),
          constraints: BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ChatStream(id: widget.roomId),
              Padding(
                padding:
                    EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: TextField(
                            controller: messageTextController,
                            onChanged: (value) {
                              //Do something with the user input.
                              setState(() {
                                message = value;
                              });
                            },
                            style: TextStyle(color: Colors.black),
                            decoration: kMessageTextFieldDecoration.copyWith(
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              fillColor: Colors.grey[300],
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: (message != null && message.length > 0)
                              ? Colors.grey[700]
                              : Colors.grey[500],
                        ),
                        onPressed: () {
                          //Implement send functionality.
                          messageTextController.clear();
                          if (message != null && message != '') {
                            _firestore
                                .collection('chatRoom')
                                .doc(widget.roomId)
                                .collection('chat')
                                .add({
                              'text': message,
                              'sender': loggedUser.email,
                              'timestamp': Timestamp.now(),
                            });
                            setState(() {
                              message = null;
                            });

                            addUIDs(widget.receiver);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatStream extends StatelessWidget {
  final String id;
  ChatStream({this.id});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('chatRoom')
          .doc(id)
          .collection('chat')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data.docs.reversed;
          List<MessageBubble> msgBubbles = [];

          String lastMsgDate = '';
          for (var message in messages) {
            final currentUser = loggedUser.email;
            final sender = message.data()['sender'];

            final timestamp = message.data()['timestamp'];
            int day = timestamp.toDate().day;
            int month = timestamp.toDate().month;
            int year = timestamp.toDate().year;

            String date = (day > 9 ? day.toString() : '0' + day.toString()) +
                '/' +
                (month > 9 ? month.toString() : '0' + month.toString()) +
                '/' +
                year.toString();
            bool newDate;
            if (lastMsgDate == date || lastMsgDate == '') {
              newDate = false;
            } else {
              newDate = true;
            }

            final bubble = MessageBubble(
              text: message.data()['text'],
              sender: sender,
              isMe: sender == currentUser,
              timestamp: message.data()['timestamp'],
              newDate: newDate,
              date: lastMsgDate,
              transparencyOfLastMsg: true,
            );

            lastMsgDate = date;
            msgBubbles.add(bubble);
          }
          msgBubbles.add(MessageBubble(
            date: lastMsgDate,
            newDate: true,
            timestamp: Timestamp.now(),
            text: '',
            isMe: true,
            sender: spUID,
            transparencyOfLastMsg: false,
          ));

          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
              children: msgBubbles,
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

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  final Timestamp timestamp;
  final bool newDate;
  final String date;
  final bool transparencyOfLastMsg;

  MessageBubble(
      {this.text,
      this.sender,
      this.isMe,
      this.timestamp,
      this.newDate,
      this.date,
      this.transparencyOfLastMsg});

  @override
  Widget build(BuildContext context) {
    int hour = timestamp.toDate().hour.toInt();
    int minute = timestamp.toDate().minute.toInt();
    final String time = (hour > 9 ? hour.toString() : '0' + hour.toString()) +
        ':' +
        (minute > 9 ? minute.toString() : '0' + minute.toString());
    if (newDate == false) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Material(
              color: isMe ? Color(0xffbbeaba) : Colors.white,
              elevation: 3.5,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(22),
                topRight: isMe ? Radius.circular(6) : Radius.circular(22),
                topLeft: isMe ? Radius.circular(22) : Radius.circular(6),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 10, right: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 220),
                        child: Text(
                          text,
                          softWrap: true,
                          style: GoogleFonts.boogaloo(
                            fontSize: 16,
                            letterSpacing: 0.35,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5, bottom: 2),
                      child: Text(time,
                          style: GoogleFonts.boogaloo(
                              fontSize: 10, color: Colors.black54)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(
            visible: transparencyOfLastMsg,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Material(
                    color: isMe ? Color(0xffbbeaba) : Colors.white,
                    elevation: 3.5,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(22),
                      bottomRight: Radius.circular(22),
                      topRight: isMe ? Radius.circular(6) : Radius.circular(22),
                      topLeft: isMe ? Radius.circular(22) : Radius.circular(6),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 10, right: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 220),
                              child: Expanded(
                                child: Text(
                                  text,
                                  style: GoogleFonts.boogaloo(
                                    fontSize: 16,
                                    letterSpacing: 0.35,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, bottom: 2),
                            child: Text(time,
                                style: GoogleFonts.boogaloo(
                                    fontSize: 10, color: Colors.black54)),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Center(
              child: Container(
                width: 85,
                height: 21,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: Colors.grey[300]),
                child: Center(
                  child: Text(
                    date,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.boogaloo(color: Colors.black54),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}

void addUIDs(var receiver) async {
  bool isServiceProvider = SharedPrefs.preferences.getBool('isServiceProvider');

  if (isServiceProvider == true) {
    ServiceProviderData loggedSPData = GlobalServiceProviderDetail.spData;
    receiver = await getUserOnTap();

    var docRefUser = _firestore
        .collection('Service Providers')
        .doc(loggedUser.uid)
        .collection('listOfChats')
        .doc(receiver.uid);

    docRefUser.get().then((value) {
      if (value.exists) {
        docRefUser.update({'lastMsg': Timestamp.now()});
      } else {
        docRefUser.set({
          'uid': receiver.uid,
          'name': receiver.name,
          'lastMsg': Timestamp.now(),
        });
      }
    });

    var docRefSP = _firestore
        .collection('Users')
        .doc(receiver.uid)
        .collection('listOfChats')
        .doc(loggedUser.uid);

    docRefSP.get().then((value) {
      if (value.exists) {
        docRefSP.update({'lastMsg': Timestamp.now()});
      } else {
        docRefSP.set({
          'uid': loggedUser.uid,
          'name': loggedSPData.name,
          'service': loggedSPData.service,
          'lastMsg': Timestamp.now(),
        });
      }
    });
  } else {
    UserData loggedUserData = GlobalUserDetail.userData;

    receiver = await getSPOnTap();
    var docRefUser = _firestore
        .collection('Users')
        .doc(loggedUser.uid)
        .collection('listOfChats')
        .doc(receiver.uid);

    docRefUser.get().then((value) {
      if (value.exists) {
        docRefUser.update({'lastMsg': Timestamp.now()});
      } else {
        docRefUser.set({
          'uid': receiver.uid,
          'name': receiver.name,
          'service': receiver.service,
          'lastMsg': Timestamp.now(),
        });
      }
    });

    var docRefSP = _firestore
        .collection('Service Providers')
        .doc(receiver.uid)
        .collection('listOfChats')
        .doc(loggedUser.uid);

    docRefSP.get().then((value) {
      if (value.exists) {
        docRefSP.update({'lastMsg': Timestamp.now()});
      } else {
        docRefSP.set({
          'uid': loggedUser.uid,
          'name': loggedUserData.name,
          'lastMsg': Timestamp.now(),
        });
      }
    });
  }
}

Future<UserData> getUserOnTap() async {
  UserData data;

  var userDetail = await _firestore.collection('Users').doc(userUID).get();
  var name = userDetail.data()['name'];
  var contact = userDetail.data()['contact'];
  var uid = userDetail.data()['uid'];

  data = UserData(uid: uid, name: name, contact: contact);
  return data;
}

Future<ServiceProviderData> getSPOnTap() async {
  ServiceProviderData data;

  var doc =
      await _firestore.collection('Service Provider Type').doc(spUID).get();
  var service = doc.data()['service'];

  var spDetail = await _firestore.collection(service).doc(spUID).get();

  var name = spDetail.data()['name'];
  var contact = spDetail.data()['contact'];
  var uid = spDetail.data()['uid'];
  var address = spDetail.data()['address'];
  var latitude = spDetail.data()['latitude'];
  var longitude = spDetail.data()['longitude'];

  data = ServiceProviderData(
      uid: uid,
      name: name,
      contact: contact,
      address: address,
      longitude: longitude,
      latitude: latitude,
      service: service);
  return data;
}

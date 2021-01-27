import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localite/screens/chat_room.dart';
import 'package:localite/widgets/toast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:simple_location_picker/simple_location_picker_screen.dart';
import 'package:url_launcher/url_launcher.dart';

final _firestore = FirebaseFirestore.instance;

class SPPendingRequestDetail extends StatefulWidget {
  final String spUID;
  final String userUID;
  final String requestID;

  SPPendingRequestDetail({this.requestID, this.spUID, this.userUID});

  @override
  _SPPendingRequestDetailState createState() => _SPPendingRequestDetailState();
}

class _SPPendingRequestDetailState extends State<SPPendingRequestDetail> {
  bool asyncCall = true;
  String userName = '';
  String address = '';
  String description = '';
  double latitude = 0;
  double longitude = 0;
  String contact = '';
  String spContact = '';
  String spName = '';
  Timestamp requestTime = Timestamp.now();
  String service = '';
  String time = '';
  String date = '';
  String url;

  @override
  void initState() {
    super.initState();
    updateScreen();
    getPhoto();
  }

  void updateScreen() {
    var docRef = _firestore
        .collection('requests')
        .doc(widget.requestID)
        .collection('pending');

    docRef.get().then((value) {
      if (value.docs.isEmpty) {
        MyToast().getToast('No request found!');
      } else {
        for (var doc in value.docs) {
          setState(() {
            userName = doc.data()['user name'];
            spName = doc.data()['service provider'];
            latitude = doc.data()['latitude'];
            longitude = doc.data()['longitude'];
            address = doc.data()['address'];
            description = doc.data()['description'];
            contact = doc.data()['contact'];
            service = doc.data()['service'];
            requestTime = doc.data()['timestamp'];
            spContact = doc.data()['sp contact'];

            //get date and time from timestamp
            int hour = requestTime.toDate().hour;
            int minute = requestTime.toDate().minute;
            int day = requestTime.toDate().day;
            int month = requestTime.toDate().month;
            int year = requestTime.toDate().year;
            time = (hour > 9 ? hour.toString() : '0' + hour.toString()) +
                ':' +
                (minute > 9 ? minute.toString() : '0' + minute.toString());
            date = (day > 9 ? day.toString() : '0' + day.toString()) +
                '/' +
                (month > 9 ? month.toString() : '0' + month.toString()) +
                '/' +
                year.toString();
            asyncCall = false;
          });
          break;
        }
      }
    });
  }

  void getPhoto() {
    _firestore.collection('Users').doc(widget.userUID).get().then((value) {
      String photo = value.data()['photoUrl'].toString();
      setState(() {
        url = photo;
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: false,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                //todo: add profile image
                CircleAvatar(
                  radius: 30,
                  backgroundImage: (url.toString() == 'null')
                      ? AssetImage('assets/images/default_profile_pic.jpg')
                      : NetworkImage(url),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text('name: $userName'),
                Text('description: $description'),
                Text('address: $address'),
                Text('Request made at $time on $date'),
                Row(
                  children: [
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: Icon(Icons.call),
                            onPressed: () async =>
                                _makePhoneCall(contact.toString())),
                        Text(contact),
                      ],
                    )),
                    Expanded(
                        child: IconButton(
                            icon: Icon(Icons.message),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatRoom(
                                          roomId: widget.requestID,
                                          userUid: widget.userUID,
                                          spUid: widget.spUID)));
                            })),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Icon(Icons.location_on),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SimpleLocationPicker(
                                        initialLatitude: latitude,
                                        initialLongitude: longitude,
                                        appBarTitle: "Display Location",
                                        displayOnly: true,
                                      )));
                        }),
                    Text('Find on map')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: RawMaterialButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.close, color: Colors.red),
                            Text('Decline'),
                          ],
                        ),
                        onPressed: () async {
                          // delete pending request
                          var docRef = _firestore
                              .collection('requests')
                              .doc(widget.requestID)
                              .collection('pending');

                          docRef.get().then((value) {
                            if (value.docs.isEmpty) {
                              MyToast().getToast('No request found!');
                            } else {
                              _firestore.runTransaction((transaction) async {
                                transaction.delete(value.docs.first.reference);
                              });
                            }
                          });

                          // make user pending request false
                          _firestore
                              .collection('Users')
                              .doc(widget.userUID)
                              .collection('requests')
                              .doc(widget.spUID)
                              .update({
                            'pending': false,
                          });

                          // make service provider pending request false
                          _firestore
                              .collection('Service Providers')
                              .doc(widget.spUID)
                              .collection('requests')
                              .doc(widget.userUID)
                              .update({
                            'pending': false,
                          });

                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                        child: RawMaterialButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, color: Colors.green),
                          Text('Accept'),
                        ],
                      ),
                      onPressed: () {
                        // delete pending request
                        var docRef = _firestore
                            .collection('requests')
                            .doc(widget.requestID)
                            .collection('pending');

                        docRef.get().then((value) {
                          if (value.docs.isEmpty) {
                            MyToast().getToast('No request found!');
                          } else {
                            _firestore.runTransaction((transaction) async {
                              transaction.delete(value.docs.first.reference);
                            });
                          }
                        });

                        // push pending data in completed request list
                        _firestore
                            .collection('requests')
                            .doc(widget.requestID)
                            .collection('completed')
                            .add({
                          'service': service,
                          'description': description,
                          'service provider': spName,
                          'user name': userName,
                          'address': address,
                          'latitude': latitude,
                          'longitude': longitude,
                          'contact': contact,
                          'sp contact': spContact,
                          'timestamp': requestTime,
                        });
                        // make user pending request = false and completed = true
                        _firestore
                            .collection('Users')
                            .doc(widget.userUID)
                            .collection('requests')
                            .doc(widget.spUID)
                            .update({'pending': false, 'completed': true});

                        // make service provider pending request = false completed = true
                        _firestore
                            .collection('Service Providers')
                            .doc(widget.spUID)
                            .collection('requests')
                            .doc(widget.userUID)
                            .update({'pending': false, 'completed': true});

                        Navigator.pop(context);
                      },
                    )),
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

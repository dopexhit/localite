import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localite/map/map_screen.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/screens/chat_room.dart';
import 'package:localite/widgets/def_profile_pic.dart';
import 'package:localite/widgets/toast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
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
  String url = '';

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
    final width=MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: false,
      child: Scaffold(
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
                    Image(
                      image: Svg('assets/images/appIcon.svg'),
                      height: 20.0,
                      width: 20.0,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'sAmigo',
                      style: GoogleFonts.boogaloo(
                          fontSize: 29, color: Color(0xff515151)),
                    ),
                    SizedBox(width: 60),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Color(0xfff0ffeb),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50.0,
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: getDefaultProfilePic(url, userName, 40, true)),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 0.8*width),
                      child: Expanded(
                        child: Text('Name: $userName',
                          style: GoogleFonts.boogaloo(
                            fontSize: 20,
                            color: Color(0xff515151),
                          ),),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Text('Description: $description',
                      style: GoogleFonts.boogaloo(
                        fontSize: 20,
                        color: Color(0xff515151),
                      ),),
                    SizedBox(height: 10.0,),
                    Text('address: $address',
                      style: GoogleFonts.boogaloo(
                        fontSize: 20,
                        color: Color(0xff515151),
                      ),),
                    SizedBox(height: 30.0,),
                    Text('Request made at $time on $date',
                      style: GoogleFonts.boogaloo(
                        fontSize: 15,
                        color: Color(0xff515151),
                      ),),
                    SizedBox(height: 30.0,),
                    Text('Reach Out:',
                      style: GoogleFonts.boogaloo(
                        fontSize: 20,
                        color: Color(0xff515151),
                      ),),
                    SizedBox(height: 10.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Image.asset(
                            'assets/images/call_icon.png',
                            width: 30.0,
                            height: 30.0,
                          ),
                            onTap: () async =>
                                _makePhoneCall(contact.toString())
                        ),
                        SizedBox(width: 30),
                        GestureDetector(
                          child: Image.asset(
                            'assets/images/message_bubble.png',
                            width: 30.0,
                            height: 30.0,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatRoom(
                                        roomId: widget.requestID,
                                        userUid: widget.userUID,
                                        receiverName: userName,
                                        url: url,
                                        spUid: widget.spUID)));
                          },
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        GestureDetector(
                          child: Image.asset(
                            'assets/images/map_marker.png',
                            width: 30.0,
                            height: 30.0,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SimpleLocationPicker(
                                      initialLatitude:
                                      GlobalServiceProviderDetail
                                          .spData.latitude,
                                      initialLongitude:
                                      GlobalServiceProviderDetail
                                          .spData.longitude,
                                      destLatitude: latitude,
                                      destLongitude: longitude,
                                      appBarTitle: "Location",
                                      dest: true,
                                      displayOnly: true,
                                    )));
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 60.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0.5,2.0,35,0.0),
                            child: Material(
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              color: Color(0xffF5C0AE),
                              elevation: 4,
                              child: MaterialButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.close, color: Colors.red),
                                    Text('Decline',style: GoogleFonts.boogaloo(
                                      fontSize: 20,
                                      color: Color(0xff515151),)),
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
                          ),
                        ),
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15,2.0,30,0.0),
                              child: Material(
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                color: Color(0xffbbeaba),
                                elevation: 4,
                                child: MaterialButton(
                          child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check, color: Colors.green),
                                  Text('Accept',style: GoogleFonts.boogaloo(
                                    fontSize: 20,
                                    color: Color(0xff515151),)),
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
                        ),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

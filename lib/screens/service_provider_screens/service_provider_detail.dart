import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localite/constants.dart';
import 'package:localite/map/map_screen.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/service_provider_data.dart';
import 'package:localite/models/user_data.dart';
import 'package:localite/screens/chat_room.dart';
import 'package:localite/screens/user_screens/user_request_screen.dart';
import 'package:localite/services/shared_pref.dart';
import 'package:localite/widgets/def_profile_pic.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

final _firestore = FirebaseFirestore.instance;
User loggedUser;

class SPDetail extends StatefulWidget {
  final ServiceProviderData currentSp;
  SPDetail({this.currentSp});
  @override
  _SPDetailState createState() => _SPDetailState();
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

class _SPDetailState extends State<SPDetail> {
  bool pendingReq = false;
  bool asyncCall = true;

  @override
  void initState() {
    super.initState();
    checkRequest();
  }

//todo: change status when request accepted
  void checkRequest() {
    UserData data =
        Provider.of<UserDetails>(GlobalContext.context).getUserDetails;

    var docRef = _firestore
        .collection('requests')
        .doc(data.uid + '-' + widget.currentSp.uid)
        .collection('pending');

    docRef.get().then((value) {
      if (value.docs.isEmpty) {
        setState(() {
          pendingReq = false;
        });
      } else {
        setState(() {
          pendingReq = true;
        });
      }
    });

    asyncCall = false;
  }

  @override
  Widget build(BuildContext context) {
    final loggedUser = Provider.of<CustomUser>(context);
    String photoUrl = widget.currentSp.photoUrl.toString();
    return ModalProgressHUD(
      inAsyncCall: asyncCall,
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
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 100.0,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: getDefaultProfilePic(
                    photoUrl, widget.currentSp.name, 40, true),
              ),
              SizedBox(height: 20),
              Text(
                'Name :  ' + widget.currentSp.name,
                style: GoogleFonts.boogaloo(
                    fontSize: 25, color: Color(0xff3d3f3f)),
              ),
              SizedBox(height: 20),
              Text(
                'Address :  ' + widget.currentSp.address,
                style: GoogleFonts.boogaloo(
                    fontSize: 25, color: Color(0xff3d3f3f)),
              ),
              SizedBox(height: 40),
              Text(
                'Reach Out :',
                style: GoogleFonts.boogaloo(
                    fontSize: 25, color: Color(0xff3d3f3f)),
              ),
              SizedBox(
                height: 25.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Image.asset(
                      'assets/images/call_icon.png',
                      width: 30.0,
                      height: 30.0,
                    ),
                    onTap: () async {
                      _makePhoneCall(widget.currentSp.contact.toString());
                    },
                  ),
                  SizedBox(width: 30),
                  GestureDetector(
                    child: Image.asset(
                      'assets/images/message_bubble.png',
                      width: 30.0,
                      height: 30.0,
                    ),
                    onTap: () {
                      String roomId =
                          loggedUser.uid + '-' + widget.currentSp.uid;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatRoom(
                                    roomId: roomId,
                                    receiverName: widget.currentSp.name,
                                    url: photoUrl,
                                    receiver: widget.currentSp,
                                    userUid: loggedUser.uid,
                                    spUid: widget.currentSp.uid,
                                  )));
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
                                    initialLatitude: SharedPrefs.preferences
                                        .getDouble(
                                            'latitude'), // widget.currentSp.latitude,
                                    initialLongitude: SharedPrefs.preferences
                                        .getDouble(
                                            'longitude'), //widget.currentSp.longitude,
                                    destLatitude: widget.currentSp.latitude,
                                    destLongitude: widget.currentSp.longitude,

                                    appBarTitle: "Location",
                                    dest: true,
                                    displayOnly: true,
                                  )));
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 50.0,
              ),
              Visibility(
                visible: !pendingReq,
                child: Material(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  color: Color(0xffbbeaba),
                  elevation: 4,
                  child: SizedBox(
                    height: 40.0,
                    child: MaterialButton(
                        child: Text(
                          'Request home service',
                          style: GoogleFonts.boogaloo(
                              fontSize: 27, color: Color(0xff3d3f3f)),
                        ),
                        onPressed: () {
                          String requestId =
                              loggedUser.uid + '-' + widget.currentSp.uid;
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserRequestScreen(
                                          requestID: requestId,
                                          receiver: widget.currentSp)))
                              .then((result) {
                            checkRequest();
                          });
                          //  checkRequest();
                        }),
                  ),
                ),
              ),
              Visibility(
                  visible: pendingReq,
                  child: Padding(
                    padding: EdgeInsets.only(top: 200),
                    child: Container(
                      height: 40.0,
                      width: 260.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        color: Color(0xffF5C0AE),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Awaiting confirmation on your request!',
                          style: GoogleFonts.boogaloo(
                              fontSize: 22, color: Color(0xff3d3f3f)),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        )),
      ),
    );
  }
}

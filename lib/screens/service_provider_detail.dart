import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/service_provider_data.dart';
import 'package:localite/models/user_data.dart';
import 'package:localite/screens/chat_room.dart';
import 'package:localite/widgets/toast.dart';
import 'package:provider/provider.dart';

final _firestore = FirebaseFirestore.instance;
UserData loggedUserDetails;
User loggedUser;

class SPDetail extends StatefulWidget {
  final ServiceProviderData currentSp;
  SPDetail({this.currentSp});
  @override
  _SPDetailState createState() => _SPDetailState();
}

class _SPDetailState extends State<SPDetail> {
  final _auth = FirebaseAuth.instance;

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

        var userDetail =
            await _firestore.collection('Users').doc(loggedUser.uid).get();
        var name = userDetail.data()['name'];
        var contact = userDetail.data()['contact'];
        var uid = userDetail.data()['uid'];
        loggedUserDetails = UserData(uid: uid, name: name, contact: contact);

        print(loggedUserDetails.name);
      } else {
        MyToast().getToastBottom('failed!');
      }
    } catch (e) {
      MyToast().getToastBottom(e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final loggedUser = Provider.of<CustomUser>(context);

    return Scaffold(
      body: Center(
          child: IconButton(
        icon: Icon(Icons.message),
        onPressed: () {
          String roomId = loggedUser.uid + '-' + widget.currentSp.uid;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatRoom(
                        roomId: roomId,
                        receiver: widget.currentSp,
                      )));
        },
      )),
    );
  }
}

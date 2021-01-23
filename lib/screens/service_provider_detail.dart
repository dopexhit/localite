import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/service_provider_data.dart';
import 'package:localite/models/user_data.dart';
import 'package:localite/screens/chat_room.dart';
import 'package:localite/widgets/toast.dart';
import 'package:provider/provider.dart';

class SPDetail extends StatefulWidget {
  final ServiceProviderData currentSp;
  SPDetail({this.currentSp});
  @override
  _SPDetailState createState() => _SPDetailState();
}

class _SPDetailState extends State<SPDetail> {
  @override
  Widget build(BuildContext context) {
    final loggedUser = Provider.of<CustomUser>(context);

    return ChangeNotifierProvider(
      create: (context) => UserDetails(),
      child: Scaffold(
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
      ),
    );
  }
}

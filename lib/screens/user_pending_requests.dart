import 'package:flutter/material.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/user_data.dart';
import 'package:localite/widgets/toast.dart';
import 'package:provider/provider.dart';

class UserPendingRequests extends StatefulWidget {
  @override
  _UserPendingRequestsState createState() => _UserPendingRequestsState();
}

class _UserPendingRequestsState extends State<UserPendingRequests> {
  @override
  Widget build(BuildContext context) {
    UserData data = Provider.of<UserDetails>(context).getUserDetails;
    MyToast().getToast(data.uid);
    return Container(
      child: Text('neha'),
    );
  }
}

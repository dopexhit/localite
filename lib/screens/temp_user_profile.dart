import 'package:flutter/material.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/user_data.dart';
import 'package:localite/widgets/toast.dart';
import 'package:provider/provider.dart';

class TempUserProfile extends StatefulWidget {
  @override
  _TempUserProfileState createState() => _TempUserProfileState();
}

class _TempUserProfileState extends State<TempUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('UserProfile'),
    );
  }
}

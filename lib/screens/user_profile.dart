import 'package:flutter/material.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/user_data.dart';
import 'package:localite/widgets/toast.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('UserProfile'),
    );
  }
}

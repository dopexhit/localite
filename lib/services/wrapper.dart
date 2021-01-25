import 'package:flutter/material.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/screens/login_or_register.dart';
import 'package:localite/screens/selection_screen.dart';
import 'file:///D:/Android/localite/lib/screens/service_provider_screens/service_provider_home.dart';
import 'file:///D:/Android/localite/lib/screens/service_provider_screens/sp_navigator_home.dart';
import 'file:///D:/Android/localite/lib/screens/user_screens/user_home.dart';
import 'file:///D:/Android/localite/lib/screens/user_screens/user_navigator_home.dart';
import 'package:localite/services/auth.dart';
import 'package:localite/services/shared_pref.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context);
    //if signed in then home else Login Sign up

    //if user doesn't exist
    if (user == null) {
      return SelectionScreen();
    }
    //user already exists
    else {
      bool isServiceProvider =
          SharedPrefs.preferences.getBool('isServiceProvider');

      if (isServiceProvider == true) {
        return SPNavigatorHome();
      } else {
        return UserNavigatorHome();
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/screens/selection_screen.dart';
import 'package:localite/services/auth.dart';
import 'package:localite/services/shared_pref.dart';

class ServiceProviderHomeScreen extends StatefulWidget {
  @override
  _ServiceProviderHomeScreenState createState() =>
      _ServiceProviderHomeScreenState();
}

class _ServiceProviderHomeScreenState extends State<ServiceProviderHomeScreen> {
  @override
  Widget build(BuildContext context) {
    GlobalContext.context = context;
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            Text('Service provider screen'),
            RaisedButton(
              onPressed: () async {
                SharedPrefs.preferences.remove('isServiceProvider');
                await AuthService().signOut().whenComplete(
                  () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectionScreen()));
                  },
                );
              },
              child: Text('SignOut'),
            ),
          ],
        )),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:localite/screens/selection_screen.dart';
import 'package:localite/screens/user_screens/user_accepted_request.dart';
import 'package:localite/services/auth.dart';
import 'package:localite/services/shared_pref.dart';

class UserDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://www.computerhope.com/jargon/n/navigate.jpg"),
                    fit: BoxFit.cover)),
            child: Text("Localite"),
          ),
          SizedBox(
            height: 10.0,
          ),
          ListTile(
            title: Text("Update Profile"),
            onTap: () {},
          ),
          SizedBox(
            height: 10.0,
          ),
          ListTile(
            title: Text("Confirmed Requests"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserAcceptedRequests()));
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          ListTile(
            title: Text("About Us"),
            onTap: () {},
          ),
          SizedBox(
            height: 10.0,
          ),
          ListTile(
            title: Text("Sign Out"),
            onTap: () async {
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
          )
        ],
      ),
    );
  }
}

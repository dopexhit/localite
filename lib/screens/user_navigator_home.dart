import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/screens/temp_user_chat.dart';
import 'package:localite/screens/temp_user_profile.dart';
import 'package:localite/screens/user_home.dart';
import 'package:provider/provider.dart';

class UserNavigatorHome extends StatefulWidget {
  @override
  _UserNavigatorHomeState createState() => _UserNavigatorHomeState();
}

class _UserNavigatorHomeState extends State<UserNavigatorHome> {
  int pageIndex = 0;
  final UserHomeScreen _userHomeScreen = UserHomeScreen();
  final TempUserChat _userChat = TempUserChat();
  final TempUserProfile _userProfile = TempUserProfile();

  Widget _showPage = new UserHomeScreen();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _userHomeScreen;
        break;

      case 1:
        return _userChat;
        break;

      default:
        return _userProfile;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserDetails(),
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          color: Colors.white70,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          animationCurve: Curves.decelerate,
          animationDuration: Duration(
            milliseconds: 390,
          ),
          height: 50,
          items: [
            Icon(
              Icons.home_filled,
              size: 20,
            ),
            Icon(
              Icons.chat,
              size: 20,
            ),
            Icon(
              Icons.person,
              size: 20,
            ),
          ],
          onTap: (index) {
            setState(() {
              _showPage = _pageChooser(index);
            });
          },
        ),
        body: Center(
          child: _showPage,
        ),
      ),
    );
  }
}

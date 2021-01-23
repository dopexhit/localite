import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:localite/screens/service_provider_home.dart';
import 'package:localite/screens/temp_user_chat.dart';
import 'package:localite/screens/temp_user_profile.dart';

class SPNavigatorHome extends StatefulWidget {
  @override
  _SPNavigatorHomeState createState() => _SPNavigatorHomeState();
}

class _SPNavigatorHomeState extends State<SPNavigatorHome> {


  int pageIndex = 0;
  final ServiceProviderHomeScreen _spHomeScreen = ServiceProviderHomeScreen();
  final TempUserChat _userChat = TempUserChat();
  final TempUserProfile _userProfile = TempUserProfile();


  Widget _showPage =  new ServiceProviderHomeScreen();

  Widget _pageChooser(int page)
  {
    switch (page)
    {
      case 0:
        return _spHomeScreen;
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
    return Scaffold(
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
          Icon(Icons.home_filled,size: 20,),
          Icon(Icons.chat,size: 20,),
          Icon(Icons.person,size: 20,),
        ],
        onTap: (index){
          setState(() {
            _showPage = _pageChooser(index);
          });
        },
      ),
      body: Center(
        child: _showPage,
      ),
    );
  }
}
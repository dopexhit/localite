import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/screens/service_provider_screens/service_provider_home.dart';
import 'package:localite/screens/service_provider_screens/service_provider_profile.dart';
import 'package:localite/screens/service_provider_screens/sp_chatlist.dart';
import 'package:provider/provider.dart';

class SPNavigatorHome extends StatefulWidget {
  @override
  _SPNavigatorHomeState createState() => _SPNavigatorHomeState();
}

class _SPNavigatorHomeState extends State<SPNavigatorHome> {
  int pageIndex = 0;
  final ServiceProviderHomeScreen _spHomeScreen = ServiceProviderHomeScreen();
  final SPChatList _spChat = SPChatList();
  final SPProfile _spProfile = SPProfile();

  Widget _showPage = new ServiceProviderHomeScreen();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _spHomeScreen;
        break;

      case 1:
        return _spChat;
        break;

      default:
        return _spProfile;
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    SPDetails();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SPDetails(),
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          color: Color(0xffbbeaba),
          buttonBackgroundColor: Colors.white,
          backgroundColor: Color(0xffbbeaba),
          animationCurve: Curves.decelerate,
          animationDuration: Duration(
            milliseconds: 390,
          ),
          height: 50,
          items: [
            SvgPicture.asset('assets/images/appIcon.svg',height: 20, width: 20,),
            // SvgPicture.asset('assets/images/message_bubble.svg',height: 20, width: 20,),
            // SvgPicture.asset('assets/images/pending_req_icon.svg',height: 20, width: 20,),
            // SvgPicture.asset('assets/images/default_profile_pic.svg',height: 20, width: 20,),
            //todo change icons
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

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localite/screens/selection_screen.dart';
import 'package:localite/screens/service_provider_screens/service_provider_accepted_requests.dart';
import 'package:localite/screens/service_provider_screens/update_service_provider_profile.dart';
import 'package:localite/services/auth.dart';
import 'package:localite/services/shared_pref.dart';

class SPDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xfff0ffeb),//todo change drawer color
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          "assets/images/drawer_head.png"),
                      fit: BoxFit.contain)),
              child: Row(
                children: [
                  SvgPicture.asset('assets/images/appIcon.svg',width: 30,height: 30,),
                  SizedBox(width: 10.0,),
                  Text(
                    'sAmigo',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.boogaloo(
                      fontSize: 30,
                      color: Color(0xff515151),
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text("Confirmed Requests",style: GoogleFonts.boogaloo(
                fontSize: 20,
                color: Color(0xff515151),
              ),),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SPAcceptedRequests()));
              },
            ),
            Padding(
              //to make a horizontal line
              padding: EdgeInsets.fromLTRB(15.0, 5.0, 30.0, 5.0),
              child: Container(color: Color(0xff515151),height: 0.5,),
            ),
            ListTile(
              title: Text("Update Profile",style: GoogleFonts.boogaloo(
                fontSize: 20,
                color: Color(0xff515151),
              ),),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (_) => UpdateSPProfile()
                    ));
              },
            ),
            Padding(
              //to make a horizontal line
              padding: EdgeInsets.fromLTRB(15.0, 5.0, 30.0, 5.0),
              child: Container(color: Color(0xff515151),height: 0.5,),
            ),
            ListTile(
              title: Text("About Us",style: GoogleFonts.boogaloo(
                fontSize: 20,
                color: Color(0xff515151),
              ),),
              onTap: () {},
            ),
            Padding(
              //to make a horizontal line
              padding: EdgeInsets.fromLTRB(15.0, 5.0, 30.0, 5.0),
              child: Container(color: Color(0xff515151),height: 0.5,),
            ),
            ListTile(
              title: Text("Sign Out",style: GoogleFonts.boogaloo(
                fontSize: 20,
                color: Color(0xff515151),
              ),),
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
      ),
    );
  }
}

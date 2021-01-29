import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localite/animations/fade-animation.dart';
import 'package:localite/screens/login_or_register.dart';

class SelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xfff0ffeb),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Hero(
                  tag: 'logoIcon',
                  child: Image(image: AssetImage('assets/images/homeIcon.png'),
                  height: 80,width: 80,),
                ),
                SizedBox(width: 20.0,),
                FadeAnimation(
                  0.5, Text(
                    'sAmigo',
                    style: GoogleFonts.boogaloo(
                      fontSize: 40,
                      letterSpacing: 2,
                      color: Color(0xff515151),
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
              ],
            ),
          ),
          FadeAnimation(
            1.5, Text(
              'Hey there, sAmigo at your service,\n'
                  'continue as:',
              style: GoogleFonts.boogaloo(
                fontSize: 25,
                color: Color(0xff515151),
              ),
            ),
          ),
          FadeAnimation(
            1.5, SizedBox(height: 50.0, width: 0.6*width,
              child: RaisedButton(
                color: Color(0xffbbeaba),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                padding: EdgeInsets.all(8.0),
                elevation: 4,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginAndRegisterScreen(isServiceProvider: false)),
                  );
                },
                child:  Text(
                  'Our Precious Customer',
                  style: GoogleFonts.boogaloo(
                    fontSize: 25,
                    color: Color(0xff515151),
                  ),
                ),
              ),
            ),
          ),
          FadeAnimation(
            1.5, Text(
              '--------- or ---------',
              style: GoogleFonts.boogaloo(
                fontSize: 25,
                color: Color(0xff515151),
              ),
            ),
          ),
          FadeAnimation(
            1.5, SizedBox(height: 50.0, width: 0.75*width,
              child: RaisedButton(
                color: Color(0xffbbeaba),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                padding: EdgeInsets.all(8.0),
                elevation: 4,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginAndRegisterScreen(isServiceProvider: true)),
                  );
                },
                child: Text(
                  'Our valuable Service Provider',
                  style: GoogleFonts.boogaloo(
                    fontSize: 25,
                    color: Color(0xff515151),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 30.0,),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localite/animations/fade-animation.dart';
import 'package:localite/screens/selection_screen.dart';
import 'package:localite/services/wrapper.dart';
import 'package:page_transition/page_transition.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin{
  AnimationController controller;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade,duration: Duration(seconds: 1),child: SelectionScreen()));
    });
    super.initState();
    controller=AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    controller.forward();
    controller.addListener(() {
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffbbeaba),
      body: Container(
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -130,
              left: 0,
              child: FadeAnimation(1,
                Container(
                  width: width,
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/splashImage.png'),
                          fit: BoxFit.cover
                      ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -180,
              left: 0,
              child: FadeAnimation(
                1.5, Container(
                  width: width,
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/splashImage.png'),
                          fit: BoxFit.cover
                      ),
                  ),
                ),
              ),
            ),Positioned(
              top: -230,
              left: 0,
              child: FadeAnimation(
                2, Container(
                  width: width,
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/splashImage.png'),
                          fit: BoxFit.cover
                      )
                  ),
                ),
              ),
            ),
            Positioned(
              top: -280,
              left: 0,
              child: FadeAnimation(
                2.5, Container(
                  width: width,
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/splashImage.png'),
                          fit: BoxFit.cover
                      )
                  ),
                ),
              ),
            ),
            Positioned(
              top: 300,
              left: 10,
              child: Opacity(
                opacity: controller.value,
                child: Hero(
                  tag: 'logoIcon',
                  child: Container(
                    width: width,
                    height: 125,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/homeIcon.png'),
                            fit: BoxFit.contain,
                        )
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 420,
              left: 130,
              child: Opacity(
                opacity: controller.value,
                child: Hero(
                  tag: 'logoText',
                  child: Container(
                    width: width,
                    child: Text(
                      'sAmigo',
                      style: GoogleFonts.boogaloo(
                        fontSize: 60,
                        letterSpacing: 2,
                        color: Color(0xff515151),
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

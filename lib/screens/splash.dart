import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localite/services/wrapper.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // Future.delayed(Duration(seconds: 3), () {
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
    //     return Wrapper(); // home or signup
    //   }));
    // });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffBBEABA),
      body: Container(
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -50,
              left: 0,
              child: Container(
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
            Positioned(
              top: -50,
              left: 0,
              child: Container(
                width: width,
                height: 400,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/splashImage.png'),
                        fit: BoxFit.cover
                    )
                ),
              ),
            ),Positioned(
              top: -50,
              left: 0,
              child: Container(
                width: width,
                height: 400,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/splashImage.png'),
                        fit: BoxFit.cover
                    )
                ),
              ),
            ),Positioned(
              top: -50,
              left: 0,
              child: Container(
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
          ],
        ),
      ),
    );
  }
}

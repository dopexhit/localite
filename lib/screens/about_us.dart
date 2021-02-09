import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localite/animations/minion_controller.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {

  MinionController minionController;
  @override
  void initState() {
    super.initState();
    minionController = MinionController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Color(0xffbbeaba),
              iconTheme: IconThemeData(
                color: Color(0xff515151),
              ),
              automaticallyImplyLeading: false,
              leading: GestureDetector(
                  child: Icon(Icons.arrow_back_ios),
                  onTap: () {
                    Navigator.pop(context);
                  }),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: Svg('assets/images/appIcon.svg'),
                    height: 20.0,
                    width: 20.0,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'sAmigo',
                    style: GoogleFonts.boogaloo(
                        fontSize: 29, color: Color(0xff515151)),
                  ),
                  SizedBox(width: 60),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xfff0ffeb),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 500,
              height: 500,
              child: GestureDetector(
                onTap: (){
                  minionController.dance();
                },
                onDoubleTap: (){
                  minionController.jump();
                },
                child: FlareActor(
                  "assets/images/minion.flr",
                  controller: minionController,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
                constraints: BoxConstraints(maxHeight: 80, maxWidth: 0.8*width),
                child: Expanded(child: Text('Thanks for using the app <3',style: GoogleFonts.boogaloo(
                  fontSize: 25,
                  color: Color(0xff515151),
                ),)))
          ],
        ),
      ),
    );
  }
}

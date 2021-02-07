import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localite/constants.dart';
import 'package:localite/models/service_provider_data.dart';
import 'package:localite/screens/service_provider_screens/service_provider_detail.dart';
import 'package:localite/services/database.dart';
import 'package:localite/widgets/def_profile_pic.dart';

class NearbySP extends StatefulWidget {
  final String title;
  final double userLongitude;
  final double userLatitude;
  NearbySP({this.title, this.userLatitude, this.userLongitude});
  @override
  _NearbySPState createState() => _NearbySPState();
}

class _NearbySPState extends State<NearbySP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SvgPicture.asset('assets/images/design.svg'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
                  Text('The ${widget.title}s available nearby:',
                    style: GoogleFonts.boogaloo(
                      fontSize: 25,
                      color: Color(0xff515151),
                    ),
                  ),
                  SizedBox(height: 30),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: DatabaseService().getAllSP(widget.title),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final serviceProviders = snapshot.data.docs.reversed;
                            List<SPTile> spTiles = [];
                            for (var serviceProvider in serviceProviders) {
                              ServiceProviderData currentSP = ServiceProviderData(
                                uid: serviceProvider.data()['uid'],
                                name: serviceProvider.data()['name'],
                                contact: serviceProvider.data()['contact'],
                                address: serviceProvider.data()['address'],
                                longitude: double.parse(
                                    serviceProvider.data()['longitude'].toString()),
                                latitude: double.parse(
                                    serviceProvider.data()['latitude'].toString()),
                                service: serviceProvider.data()['service'],
                                photoUrl: serviceProvider.data()['photoUrl']
                              );

                              var latitudeDiff =
                                  (currentSP.latitude - widget.userLatitude).abs();
                              var longitudeDiff =
                                  (currentSP.longitude - widget.userLongitude)
                                      .abs();

                              if (latitudeDiff <= 0.2 &&
                                  longitudeDiff <= 0.2)
                                spTiles.add(SPTile(
                                  currentSP: currentSP,
                                ));
                            }
                            return ListView(
                              children: spTiles,
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SPTile extends StatelessWidget {
  //the tile which displays carpenter details
  final ServiceProviderData currentSP;
  SPTile({this.currentSP});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SPDetail(currentSp: currentSP),
            ));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        color: Color(0xfff0ffeb),
        child: Row(
          children: [
            SizedBox(width: 10.0,),
            getDefaultProfilePic(currentSP.photoUrl, currentSP.name, 20,false),
            SizedBox(width: 10.0,),
            Padding(
              padding: EdgeInsets.all(10),
              child: Expanded(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Name :  '+currentSP.name,
                      style: GoogleFonts.boogaloo(
                        fontSize: 20,
                        color: Color(0xff515151),
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 5.0,),
                    Text(
                      'Address :  '+currentSP.address,
                      style: GoogleFonts.boogaloo(
                        fontSize: 20,
                        color: Color(0xff515151),
                      ),
                      overflow: ,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

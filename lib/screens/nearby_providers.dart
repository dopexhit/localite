import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localite/models/service_provider_data.dart';
import 'package:localite/screens/service_provider_detail.dart';
import 'package:localite/services/database.dart';


class NearbySP extends StatefulWidget {
  final String title;
  final double userLongitude;
  final double userLatitude;
  NearbySP({this.title,this.userLatitude,this.userLongitude});
  @override
  _NearbySPState createState() => _NearbySPState();
}

class _NearbySPState extends State<NearbySP> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            children: [
              Text('The ${widget.title}s available nearby are:'),
              SizedBox(height: 30),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: DatabaseService().getAllSP(widget.title),
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        final serviceProviders=snapshot.data.docs.reversed;
                        List<SPTile>spTiles=[];
                        for(var serviceProvider in serviceProviders){

                          ServiceProviderData currentSP=ServiceProviderData(
                            uid: serviceProvider.data()['uid'],
                            name: serviceProvider.data()['name'],
                            contact: serviceProvider.data()['contact'],
                            address: serviceProvider.data()['address'],
                            longitude: serviceProvider.data()['longitude'],
                            latitude: serviceProvider.data()['latitude'],
                            service: serviceProvider.data()['service'],
                          );

                          if(currentSP.name=='hj')//todo change if condition
                            spTiles.add(SPTile(currentSP: currentSP,));
                        }
                        return ListView(
                          children: spTiles,
                        );
                      }else{
                        return Container();
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: EdgeInsets.only(bottom: 12),
      //   child: Row(
      //     children: [
      //       Expanded(child: Icon(Icons.chat)),
      //       Expanded(child: Icon(Icons.home_filled)),
      //       Expanded(child: Icon(Icons.person)),
      //     ],
      //   ),
      // ),
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
      onTap:(){ Navigator.push(context, MaterialPageRoute(builder:(_)=>SPDetail(currentSp: currentSP),));},
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            currentSP.name,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}




import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as map;
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong/latlong.dart';

import 'map_result.dart';

class SimpleLocationPicker extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;
  final bool displayOnly;
  final String appBarTitle;
  final double destLatitude;
  final double destLongitude;
  final bool dest;

  SimpleLocationPicker(
      {this.initialLatitude,
      this.initialLongitude,
      this.displayOnly = false,
      this.appBarTitle = "Select Location",
      this.destLatitude,
      this.destLongitude,
      this.dest});

  @override
  _SimpleLocationPickerState createState() => _SimpleLocationPickerState();
}

class _SimpleLocationPickerState extends State<SimpleLocationPicker> {
  // Holds the value of the picked location.
  SimpleLocationResult _selectedLocation;

  void initState() {
    super.initState();
    _selectedLocation =
        SimpleLocationResult(widget.initialLatitude, widget.initialLongitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffbbeaba), // Color(0xff97d486),
        iconTheme: IconThemeData(color: Colors.black54),
        title: Text(
          widget.appBarTitle,
          style: GoogleFonts.boogaloo(color: Colors.black54, fontSize: 25),
        ),
        actions: <Widget>[
          // DISPLAY_ONLY MODE: no save button for display only mode
          widget.displayOnly
              ? Container()
              : GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(_selectedLocation);
                  },
                  child: Center(
                    child: Text(
                      'Save  ',
                      style: GoogleFonts.boogaloo(
                          color: Colors.blue[500], fontSize: 25),
                    ),
                  ),
                ), //IconButton(
          //   icon: Icon(Icons.room_outlined,
          //       size: 30, color: Colors.black54),
          //   onPressed: () {
          //     Navigator.of(context).pop(_selectedLocation);
          //   },
          //   color: Colors.black54,
          // ),
        ],
      ),
      body: widget.dest ? _sourceDest() : _osmWidget(),
    );
  }

  /// Returns a widget containing the openstreetmaps screen.
  Widget _osmWidget() {
    return map.FlutterMap(
        options: map.MapOptions(
            center: _selectedLocation.getLatLng(),
            zoom: 15,
            onTap: (tapLoc) {
              // DISPLAY_ONLY MODE: no map taps for display only mode
              if (!widget.displayOnly) {
                setState(() {
                  _selectedLocation =
                      SimpleLocationResult(tapLoc.latitude, tapLoc.longitude);
                });
              }
            }),
        layers: [
          map.TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          map.MarkerLayerOptions(markers: [
            map.Marker(
                width: 80.0,
                height: 80.0,
                anchorPos: map.AnchorPos.align(map.AnchorAlign.top),
                point: _selectedLocation.getLatLng(),
                builder: (ctx) {
                  return Column(
                    children: [
                      Text(
                        'Pick your location',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 15),
                      ),
                      Icon(Icons.room, size: 40, color: Colors.red.shade900),
                    ],
                  );
                }),
          ])
        ]);
  }

  Widget _sourceDest() {
    return map.FlutterMap(
        options: map.MapOptions(
            center: LatLng(widget.destLatitude, widget.destLongitude),
            zoom: 15,
            onTap: (tapLoc) {
              // DISPLAY_ONLY MODE: no map taps for display only mode
              // if (!widget.displayOnly) {
              //   setState(() {
              //     _selectedLocation =
              //         SimpleLocationResult(tapLoc.latitude, tapLoc.longitude);
              //   });
              // }
            }),
        layers: [
          map.TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          map.MarkerLayerOptions(markers: [
            map.Marker(
                width: 80.0,
                height: 80.0,
                anchorPos: map.AnchorPos.align(map.AnchorAlign.top),
                point: _selectedLocation.getLatLng(),
                builder: (ctx) {
                  return Column(
                    children: [
                      Text(
                        'Your location',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 15),
                      ),
                      Icon(Icons.room, size: 40, color: Colors.red.shade900),
                    ],
                  );
                }),
            map.Marker(
                width: 80.0,
                height: 80.0,
                anchorPos: map.AnchorPos.align(map.AnchorAlign.top),
                point: LatLng(widget.destLatitude, widget.destLongitude),
                builder: (ctx) {
                  return Column(
                    children: [
                      Text(
                        'Provider\'s location',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 15),
                      ),
                      Icon(Icons.room, size: 40, color: Colors.red.shade900),
                    ],
                  );
                }),
          ])
        ]);
  }
}

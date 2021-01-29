import 'package:latlong/latlong.dart';

class SimpleLocationResult {
  final double latitude;
  final double longitude;

  SimpleLocationResult(this.latitude, this.longitude);

  getLatLng() => LatLng(latitude, longitude);
}

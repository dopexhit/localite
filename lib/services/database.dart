import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localite/models/service_provider_data.dart';
import 'package:localite/models/user_data.dart';

class DatabaseService {
  addSPDetails(String uid, ServiceProviderData data) async {
    await FirebaseFirestore.instance.collection(data.service).doc(uid).set({
      'uid': uid,
      'name': data.name,
      'contact': data.contact,
      'address': data.address,
      'latitude': data.latitude,
      'longitude': data.longitude,
      'service': data.service,
    }).catchError((e) {
      print(e.toString());
    });
  }

  addUserDetails(String uid, UserData data) async {
    await FirebaseFirestore.instance.collection('User').doc(uid).set({
      'uid': uid,
      'name': data.name,
      'contact': data.contact,
    }).catchError((e) {
      print(e.toString());
    });
  }

  getAllSP(String service){
    return FirebaseFirestore.instance.collection(service).snapshots();
  }
}

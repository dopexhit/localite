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

    await FirebaseFirestore.instance
        .collection('Service Provider Type')
        .doc(uid)
        .set({
      'uid': uid,
      'service': data.service,
    }).catchError((e) {
      print(e.toString());
    });
  }

  addUserDetails(String uid, UserData data) async {
    await FirebaseFirestore.instance.collection('Users').doc(uid).set({
      'uid': uid,
      'name': data.name,
      'contact': data.contact,
      'photoUrl': 'https://st.depositphotos.com/2101611/3925/v/600/depositphotos_39258143-stock-illustration-businessman-avatar-profile-picture.jpg',
    }).catchError((e) {
      print(e.toString());
    });
  }

  getAllSP(String service) {
    return FirebaseFirestore.instance.collection(service).snapshots();
  }
  getUserProfile(String uid){
    return FirebaseFirestore.instance.collection('Users').doc(uid).snapshots();
  }
}

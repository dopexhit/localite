import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localite/models/service_provider_data.dart';
import 'package:localite/models/user_data.dart';
import 'package:localite/widgets/toast.dart';

class CustomUser {
  final String uid;
  CustomUser({this.uid});
}

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User loggedUser;

class UserDetails extends ChangeNotifier {
  UserData userData;

  UserData get getUserDetails {
    return userData;
  }

  UserDetails() {
    getCurrentUser();
    notifyListeners();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedUser = user;

        var userDetail =
            await _firestore.collection('Users').doc(loggedUser.uid).get();
        var name = userDetail.data()['name'];
        var contact = userDetail.data()['contact'];
        var uid = userDetail.data()['uid'];
        userData = UserData(uid: uid, name: name, contact: contact);
      } else {
        MyToast().getToastBottom('failed!');
      }
    } catch (e) {
      MyToast().getToastBottom(e.message.toString());
    }
  }
}

class SPDetails extends ChangeNotifier {
  ServiceProviderData spData;

  ServiceProviderData get getSPDetails {
    return spData;
  }

  SPDetails() {
    getCurrentUser();
    notifyListeners();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedUser = user;

        var doc = await _firestore
            .collection('Service Provider Type')
            .doc(loggedUser.uid)
            .get();
        var service = doc.data()['service'];
        var spDetail =
            await _firestore.collection(service).doc(loggedUser.uid).get();

        var name = spDetail.data()['name'];
        var contact = spDetail.data()['contact'];
        var uid = spDetail.data()['uid'];
        var address = spDetail.data()['address'];
        var latitude = spDetail.data()['latitude'];
        var longitude = spDetail.data()['longitude'];

        spData = ServiceProviderData(
            uid: uid,
            name: name,
            contact: contact,
            address: address,
            longitude: longitude,
            latitude: latitude,
            service: service);
      } else {
        MyToast().getToastBottom('failed!');
      }
    } catch (e) {
      MyToast().getToastBottom(e.message.toString());
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localite/widgets/toast.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

String getUserProfileImage(String uid) {
  String photoUrl;

  _firestore.collection('Users').doc(uid).get().then((value) {
    photoUrl = value.data()['name'].toString();
  });
}

String getSPProfileImage(String uid, String service) {
  String photoUrl;
  _firestore.collection(service).doc(uid).get().then((value) {
    photoUrl = value.data()['photoUrl'];
  });

  return photoUrl;
}

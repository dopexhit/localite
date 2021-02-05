import 'package:firebase_auth/firebase_auth.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/service_provider_data.dart';
import 'package:localite/models/user_data.dart';
import 'package:localite/widgets/toast.dart';

import 'database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //creating user object based on FirebaseUser
  CustomUser _userFromFirebaseUser(User user) {
    return user != null ? CustomUser(uid: user.uid) : null;
  }

  //auth change user stream of data changes
  Stream<CustomUser> get user {
    return _auth
        .authStateChanges()
        .map((User user) => _userFromFirebaseUser(user));
  }

  //sign in email pass
  Future signInwithEmailandPassword(String email, String password) async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print(e.message.toString());
      return null;
    }
  }

  //register email pass for user
  Future userRegisterwithEmailandPassword(
      String email, String password, UserData data) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (user != null) {
        // create new document with uid

        DatabaseService().addUserDetails(user.user.uid, data);

        return user;
      } else {
        return null;
      }
    } catch (e) {
      print(e.message.toString());
      return null;
    }
  }

  // service provider register email pass
  Future serviceProviderRegisterwithEmailandPassword(
      String email, String password, ServiceProviderData data) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (user != null) {
        // create new document with uid

        DatabaseService().addSPDetails(user.user.uid, data);

        return user;
      } else {
        return null;
      }
    } catch (e) {
      print(e.message.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

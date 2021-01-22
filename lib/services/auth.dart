import 'package:firebase_auth/firebase_auth.dart';
import 'package:localite/models/custom_user.dart';
import 'package:localite/models/service_provider_data.dart';
import 'package:localite/models/user_data.dart';
import 'package:localite/widgets/toast.dart';

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
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        MyToast().getToast('No user found for that email!');
      } else if (e.code == 'wrong-password') {
        MyToast().getToast('Wrong password provided for that user!');
      }
      return null;
    } catch (e) {
      MyToast().getToast(e.toString());
      return null;
    }
  }

  //register email pass for user
  Future userRegisterwithEmailandPassword(
      String email, String password, UserData data) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // todo create new document with uid
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        MyToast().getToast('The password provided is too weak!');
      } else if (e.code == 'email-already-in-use') {
        MyToast().getToast('The account already exists for that email!');
      }
      return null;
    } catch (e) {
      MyToast().getToast(e.toString());
      return null;
    }
  }

  // service provider register email pass
  Future serviceProviderRegisterwithEmailandPassword(
      String email, String password, ServiceProviderData data) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // todo create new document with uid
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        MyToast().getToast('The password provided is too weak!');
      } else if (e.code == 'email-already-in-use') {
        MyToast().getToast('The account already exists for that email!');
      }
      return null;
    } catch (e) {
      MyToast().getToast(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    //todo: remove shared pref
    try {
      return await _auth.signOut();
    } catch (e) {
      MyToast().getToast(e.toString());
      return null;
    }
  }
}

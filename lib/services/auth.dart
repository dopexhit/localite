import 'package:firebase_auth/firebase_auth.dart';
import 'package:localite/models/custom_user.dart';

class AuthService{
  // todo specify the fields to input
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //creating user object based on FirebaseUser
  CustomUser _userFromFirebaseUser(User user){
    return user != null ? CustomUser(uid: user.uid) : null; //todo change custom type
  }

  //auth change user stream of data changes
  Stream<CustomUser> get user{
    return _auth.authStateChanges()
        .map((User user) => _userFromFirebaseUser(user));
  }
  //sign in email pass
  Future signInwithEmailandPassword(String email, String password) async{
    try{
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }

  //register email pass
  Future registerwithEmailandPassword(String email, String password) async{
    try{
      UserCredential user=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // todo create new document with uid
      return user;
       }on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString);
      return null;
    }
  }
}
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String eamil, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: eamil, password: password);
      return credential.user;
    } catch (e) {
      print('Some Error Occured');
    }
    return null;
  }



  Future<User?> signInWithEmailAndPassword(String eamil, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: eamil, password: password);
      return credential.user;
    } catch (e) {
      print('Some Error Occured');
    }
    return null;
  }



}

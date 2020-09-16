import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FbUser {
  FbUser({@required this.uid});

  final String uid;
}
abstract class AuthBase{
  Stream<FbUser> get onAuthStateChanged;
  Future<FbUser> currentUser();
  Future<FbUser> signInAnonymously();
  Future<void> signOut();

}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  FbUser _userFromFirebase(User user) {

    //return null if the user is null
    if (user == null) {
      return null;
    }
    //return uid if the user is not null
    return FbUser(uid: user.uid);
  }

  //using stream
  @override
  Stream<FbUser> get onAuthStateChanged{
    return  _firebaseAuth.authStateChanges().map((_userFromFirebase));
  }



  @override
  Future<FbUser> currentUser() async {
    final user = await _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<FbUser> signInAnonymously() async {
    //sign in the user
    final authResult = await _firebaseAuth.signInAnonymously();
    //get the user
    final user = authResult.user;
    //return the user
    return _userFromFirebase(user);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

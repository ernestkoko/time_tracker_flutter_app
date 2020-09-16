import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FbUser {
  FbUser({@required this.uid});

  final String uid;
}

abstract class AuthBase {
  Stream<FbUser> get onAuthStateChanged;

  Future<FbUser> currentUser();

  Future<FbUser> signInAnonymously();
  Future<FbUser> signInWithGoogle();

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
  Stream<FbUser> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map((_userFromFirebase));
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
  Future<FbUser> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleSignInAccount = await googleSignIn.signIn();
    //get the access token
    if (googleSignInAccount != null) {
      //
      final googleSignInAuth = await googleSignInAccount.authentication;
      if (googleSignInAuth.idToken != null &&
          googleSignInAuth.accessToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
              idToken: googleSignInAuth.idToken,
              accessToken: googleSignInAuth.accessToken),
        );
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: "ERROR_MISSING_GOOGLE_AUTH_TOKEN",
          message: "Missing Google Auth Token",
        );
      }
    } else {
      throw PlatformException(
        code: "ERROR_ABORTED_BY_USER",
        message: "Sign in aborted by user",
      );
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    //sign out from google and invalidate the idToken
    await googleSignIn.signOut();
    //sign out from firebase
    await _firebaseAuth.signOut();
  }
}

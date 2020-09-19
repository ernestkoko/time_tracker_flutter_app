import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter/services/auth.dart';

class SignInManager {
  SignInManager({@required this.auth, @required this.isLoading});

  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<FbUser> _signIn(Future<FbUser> Function() signInMethod) async {
    try {
      // _setIsLoading(true);
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      //forward the exception to the calling code
      rethrow;
    }
  }

  Future<FbUser> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);

  Future<FbUser> signInWithGoogle() async =>
      await _signIn(auth.signInWithGoogle);
}

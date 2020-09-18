import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter/services/auth.dart';

class SignInBloc {
  SignInBloc({@required this.auth});

  final AuthBase auth;
  final StreamController<bool> _isLoadingController = StreamController<bool>();

  //getter for the block
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  //dispose
  void dispose() {
    _isLoadingController.close();
  }

//add to the sink of the controller/ setter
  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);




  Future<FbUser> _signIn(Future<FbUser> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      _setIsLoading(false);
      //forward the exception to the calling code
      rethrow;
    }
  }
  Future<FbUser> signInAnonymously() async => await _signIn(auth.signInAnonymously);

  Future<FbUser> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);


}

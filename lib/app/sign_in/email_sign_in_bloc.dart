import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({@required this.auth});

  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();

  Future<void> submit() async {
    print("Submit: called");
    updateWith(submitted: true, isLoading: true);
    try {
      //delay for three seconds
      // Future.delayed(Duration(seconds: 3));
      if (_model.formType == EmailSignInFormType.signIn) {
        //if the button is showing sign in, sign in the user with email and
        // password when the button is clicked
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        //else create new user
        await auth.createUserWithEmailAndPassword(
            _model.email, _model.password);
      }
    } catch (e) {

      //rethrows the error to the calling method
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  //to close the controller
  void dispose() {
    _modelController.close();
  }

  //method that updates the model
  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    //update model
    //add updated model to _modelController
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
    //add new value to our stream
    _modelController.add(_model);
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter/services/auth.dart';

class EmailSignInBloc {
  //constructor
  EmailSignInBloc({@required this.auth});
  //instantiate the auth class
  final AuthBase auth;
  //instantiate and initialise and StreamController of type EmailSignIn Model
  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();

  //getter for the Stream
  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  //instantiate and initialise the Model class
  EmailSignInModel _model = EmailSignInModel();

  //submit method that returns a Future
  //it is an async call
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
      updateWith(isLoading: false);
      rethrow;
    }
  }

  //to close the controller
  void dispose() {
    _modelController.close();
  }

  //method that toggles the form
  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    //updates the form with the set values
    updateWith(
      email: '',
      password: '',
      submitted: false,
      formType: formType,
      isLoading: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  //method that updates the model
  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    //update model. It reassigns the new model to _model class
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

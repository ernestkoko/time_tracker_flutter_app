import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker_flutter/app/sign_in/validators.dart';
import 'package:time_tracker_flutter/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_flutter/services/auth.dart';
import 'package:time_tracker_flutter/services/auth_provider.dart';

//enum class to check the state of the user
enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _submitted = false;
  bool _isLoading = false;

  String get _email => _emailController.text;

  String get _password => _passwordController.text;

  //default value
  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  void _submit(BuildContext context) async {
    final auth = AuthProvider.of(context);
    setState(() {
      _submitted = true;
      _isLoading = true;
    });

    try {
      //delay for three seconds
      // Future.delayed(Duration(seconds: 3));
      if (_formType == EmailSignInFormType.signIn) {
        //if the button is showing sign in, sign in the user with email and
        // password when the button is clicked
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        //else create new user
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      //close the page if it succeeds
      Navigator.of(context).pop();
    } catch (e) {
      //if submit fails
      //display a dialog
      //check if it is IOS platform
      if (Platform.isIOS) {
        //show Cupertino alert dialog
      } else {
        PlatformAlertDialog(
          title: "Sign in failed",
          content: e.toString(),
          defaultActionText: "Ok",
        ).show(context);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    //pass the focus to new focus
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });

    //clear the texts in the fields
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? "Sign in"
        : "Create an account";
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? "Need an account? Register"
        : "Have an account? Sign in";
    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;
    return [
      _buildEmailTextField(),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnabled ? () =>_submit(context) : null,
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
        onPressed: !_isLoading ? _toggleFormType : null,
        child: Text(secondaryText),
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      controller: _passwordController,
      decoration: InputDecoration(
          labelText: "Password",
          errorText: showErrorText ? widget.invalidPasswordErrorText : null),
      obscureText: true,
      enabled: _isLoading == false,
      onEditingComplete:() => _submit(context),
      onChanged: (password) => _updateState(),
    );
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      focusNode: _emailFocusNode,
      controller: _emailController,
      enabled: _isLoading == false,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "test@test.com",
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
      ),
      onChanged: (email) => _updateState(),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        //make all the children widgets stretch to the ends
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }

  void _updateState() {
    //just call set state to rebuild the form

    setState(() {});
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/app/sign_in/email_sign_in_change_model.dart';
import 'package:time_tracker_flutter/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_flutter/services/auth.dart';

// enum EmailSignInFormType { signIn, register }

class EmailSignInFormChangeNotifier extends StatefulWidget {

  EmailSignInFormChangeNotifier({@required this.model});

  final EmailSignInChangeModel model;

  //method that creates the EmailSignInBlocBased widget
  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (context) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (context, model, _) => EmailSignInFormChangeNotifier(model: model),
      ),
      //dispose the controller
     // dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() => _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  EmailSignInChangeModel get model => widget.model;

  //called when a stateful widget is removed from the widget tree
  @override
  void dispose() {
    //dispose the text controllers
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    print("Submit");
    try {
      await model.submit();
      //close the page if it succeeds
      Navigator.of(context).pop();
    } catch (e) {
      print("Error: occurred");
      //if submit fails
      //display a dialog
      PlatformAlertDialog(
        title: "Sign in failed",
        content: e.message,
        defaultActionText: "Ok",
      ).show(context);
    }
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    //pass the focus to new focus
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    model.toggleFormType();
    //clear the texts in the fields
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
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
        text: model.primaryButtonText,
        onPressed: model.canSubmit ?  _submit : null,
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
        onPressed: !model.isLoading ? _toggleFormType : null,
        child: Text(model.secondaryButtontext),
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
       model.submitted && !model.passwordValidator.isValid(model.password);
    return TextField(
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      controller: _passwordController,
      decoration: InputDecoration(
          labelText: "Password", errorText:model.passwordErrorText),
      obscureText: true,
      enabled: model.isLoading == false,
      onEditingComplete: () => _submit(),
      onChanged: model.updatePassword,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      focusNode: _emailFocusNode,
      controller: _emailController,
      enabled: model.isLoading == false,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "test@test.com",
        errorText:model.emailErrorText,
      ),
      onChanged: model.updateEmail,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailEditingComplete(),
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
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_flutter/app/sign_in/sign_in_manager.dart';
import 'package:time_tracker_flutter/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_flutter/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.manager, @required this.isLoading}) : super(key: key);
  final SignInManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    //gte the auth object
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        //the builder is called every time the value changes in the change notifier
        builder: (_,isLoading, child ) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
               
          //using a Consumer Widget to access the bloc
          child: Consumer<SignInManager>(
            builder: (context, manager, _) => SignInPage(
              manager: manager, isLoading: isLoading.value ,
            ),

          ),
        ),
      ),
    );
  }

  // async call

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      //bloc.setIsLoading(true);

      await manager.signInAnonymously();
    } catch (err) {
      print(err);
      PlatformAlertDialog(
        title: "Sign in failed",
        content: err.message,
        defaultActionText: "Ok",
      ).show(context);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
    //  bloc.setIsLoading(true);
      await manager.signInWithGoogle();
    } catch (e) {
      PlatformAlertDialog(
        title: "Sign in failed",
        content: e.message,
        defaultActionText: "Ok",
      ).show(context);
    }
  }

  void _signInWithEmail(BuildContext context) {
    // setState(() => _isLoading = true);
   // final auth = Provider.of<AuthBase>(context, listen: false);
    //navigate to the email sign in page
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // fullscreenDialog: true,
        //render the EmailSignInPage screen
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        elevation: 2.0,
        title: Text('Time Tracker'),
      ),
      body: _buildContent(context),

      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 50.0, child: _buildHeader()),
            SizedBox(
              height: 48.0,
            ),
            SocialSignInButton(
              assetName: 'images/google-logo.png',
              text: "Sign in with Google",
              color: Colors.white,
              textColor: Colors.black87,
              onPressed: isLoading ? null : () => _signInWithGoogle(context),
            ),
            SizedBox(
              height: 8.0,
            ),
            SocialSignInButton(
              assetName: 'images/facebook-logo.png',
              text: "Sign in with Facebook",
              color: Color(0XFF334D92),
              textColor: Colors.white,
              onPressed: isLoading ? null : () {},
            ),
            SizedBox(
              height: 8.0,
            ),
            SignInButton(
              text: "Sign in with email",
              color: Colors.teal[700],
              textColor: Colors.white,
              onPressed: isLoading ? null : () => _signInWithEmail(context),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "or",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 8.0,
            ),
            SignInButton(
              text: "Go anonymous",
              color: Colors.lime[300],
              textColor: Colors.black87,
              onPressed: isLoading ? null : () => _signInAnonymously(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      "Sign in",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

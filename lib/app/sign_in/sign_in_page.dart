import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_flutter/app/sign_in/sign_in_bloc.dart';
import 'package:time_tracker_flutter/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_flutter/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.bloc}) : super(key: key);
  final SignInBloc bloc;

  static Widget create(BuildContext context) {
    //gte the auth object
    final auth = Provider.of<AuthBase>(context);
    return Provider<SignInBloc>(
      create: (_) => SignInBloc(auth: auth),
      //dispose the block after use
      dispose:(context, bloc) => bloc.dispose() ,
      //using a Consumer Widget to access the bloc
      child: Consumer<SignInBloc>(
        builder: (context, bloc, _) => SignInPage(
          bloc: bloc,
        ),

      ),
    );
  }

  // async call

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      //bloc.setIsLoading(true);

      await bloc.signInAnonymously();
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
      await bloc.signInWithGoogle();
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
      body: StreamBuilder<bool>(
        //get the isLoading
          stream: bloc.isLoadingStream,
          initialData: false,
          builder: (context, snapshot) {
            //snapshot.data gets the value of the isLoading
            return _buildContent(context, snapshot.data);
          }),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 50.0, child: _buildHeader(isLoading)),
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

  Widget _buildHeader(bool isLoading) {
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

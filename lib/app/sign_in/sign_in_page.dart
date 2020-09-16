import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter/services/auth.dart';

class SignInPage extends StatelessWidget {
  SignInPage({@required this.auth, @required this.onSignIn});
  //call back function
  final Function(FbUser) onSignIn;
  final AuthBase auth;

  // async call
  Future<void> _signInAnonymously() async {
    try{
    print('SignIn clicked');
    await Firebase.initializeApp();
     FbUser user  = await auth.signInAnonymously();
     onSignIn(user);
       print('${user.uid}');
    }  on Exception catch(err){
      print(err);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('Time Tracker'),
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "Sign in",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 48.0,
          ),

          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: "Sign in with Google",
            color: Colors.white,
            textColor: Colors.black87,
            onPressed: () {},
          ),
          SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
           assetName: 'images/facebook-logo.png',
            text: "Sign in with Facebook",
            color: Color(0XFF334D92),
            textColor: Colors.white,
            onPressed: () {},
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: "Sign in with email",
            color: Colors.teal[700],
            textColor: Colors.white,
            onPressed: () {},
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
            onPressed: _signInAnonymously,
          ),
        ],
      ),
    );
  }
}
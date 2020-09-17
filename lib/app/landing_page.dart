import 'package:flutter/material.dart';
import 'package:time_tracker_flutter/app/home_page.dart';
import 'package:time_tracker_flutter/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter/services/auth.dart';

class LandingPage extends StatelessWidget {
  LandingPage({@required this.auth});

  final AuthBase auth;



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FbUser>(
      //if auth state changes, this widget will rebuild
      stream: auth.onAuthStateChanged,
      //builder is called anytime the stream changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          //get the user
          FbUser user = snapshot.data;
          if (user == null) {
            return SignInPage(
              auth: auth,

            );
          }
          //returns this if there is user
          return HomePage(
            auth: auth,
          );
        }else{
          //no data in the snapshot
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

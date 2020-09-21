import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/app/home/jobs/jobs_page.dart';
import 'package:time_tracker_flutter/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter/services/auth.dart';
import 'package:time_tracker_flutter/services/database.dart';



class LandingPage extends StatelessWidget {
  // final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    //call the auth provider
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder<FbUser>(
      //if auth state changes, this widget will rebuild
      stream: auth.onAuthStateChanged,
      //builder is called anytime the stream changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          //get the user
          FbUser user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          }
          //returns this if there is user
          return Provider<Database>(
            //the user is guaranteed to be not null
            create: (_) => FirestoreDatabase(uid: user.uid),
            child: JobsPage(),
          );
        } else {
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

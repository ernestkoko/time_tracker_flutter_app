import 'package:flutter/material.dart';
import 'package:time_tracker_flutter/app/home_page.dart';
import 'package:time_tracker_flutter/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter/services/auth.dart';

class LandingPage extends StatefulWidget {
  LandingPage({@required this.auth});

  final AuthBase auth;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  FbUser _user;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
    widget.auth.onAuthStateChanged.listen((user) {
      print("User: ${user?.uid}");
    });
  }

  Future<void> _checkCurrentUser() async {
    //get the current user
    // User user = FirebaseAuth.instance.currentUser;
    FbUser user = await widget.auth.currentUser();
    print("User: ${user.uid}");
    //update the user
    _updateUser(user);
  }

  void _updateUser(FbUser user) {
    //setState() rebuilds the entire widget
    setState(() {
      //set the user to the gotten user
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(
        auth: widget.auth,
        onSignIn: _updateUser,
      );
    }
    //returns this if there is user
    return HomePage(
      auth: widget.auth,
      onSignOut: () => _updateUser(null),
    );
  }
}

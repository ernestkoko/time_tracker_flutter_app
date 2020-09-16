import 'package:flutter/material.dart';
import 'package:time_tracker_flutter/services/auth.dart';

class HomePage extends StatelessWidget {
  HomePage({@required this.auth});

  //final VoidCallback onSignOut;
  final AuthBase auth;

  // async call
  Future<void> _signOut() async {
    try {
      print('SignIn clicked');
      await auth.signOut();
     // onSignOut();
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          FlatButton(
              onPressed: _signOut,
              child: Text(
                "Logout",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ))
        ],
      ),
    );
  }
}

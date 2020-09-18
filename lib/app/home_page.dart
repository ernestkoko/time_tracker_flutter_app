import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_flutter/services/auth.dart';


class HomePage extends StatelessWidget {


  // async call
  Future<void> _signOut(BuildContext context) async {

    try {
      print('SignIn clicked');
      final auth = Provider.of<AuthBase>(context);
      await auth.signOut();
      // onSignOut();
    } catch (err) {
      print(err);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
   final didRequestSignOut = await PlatformAlertDialog(
      title: "Logout",
      content: "Are you sure?",
      cancelActionText: "Cancel",
      defaultActionText: "Logout",
    ).show(context);
   if(didRequestSignOut == true){
     _signOut(context);
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          FlatButton(
              onPressed: () => _confirmSignOut(context),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/app/home/models/job.dart';
import 'package:time_tracker_flutter/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_flutter/services/auth.dart';
import 'package:time_tracker_flutter/services/database.dart';

class JobsPage extends StatelessWidget {

  // async call
  Future<void> _signOut(BuildContext context) async {
    try {
      print('SignIn clicked');
      final auth = Provider.of<AuthBase>(context, listen: false);
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
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _createJob(BuildContext context) async {
    print("Create: called");
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(Job(name: 'Blogging', ratePerHour: 10));
    } catch (e) {
      print("Exception: " +e.message);
      PlatformAlertDialog(
        title: "Sign in failed",
        content: e.message,
        defaultActionText: "Ok",
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jobs"),
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
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createJob(context),
      ),
    );
  }

 Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder:(context, snapshot){
        if(snapshot.hasData){
          //jobs is a list of jobs
          final jobs = snapshot.data;
          //add toList to change it from iterable object
          final children = jobs.map((job) => Text(job.name)).toList();
          //listView id better when working with dynamic list of children
          return ListView(children: children,);
        }
        if(snapshot.hasError){
          return Center(child: Text("Some errors occurred"),);
        }
        return Center(child: CircularProgressIndicator(),);
      }   ,
    );
  }
}

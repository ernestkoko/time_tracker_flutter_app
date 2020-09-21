import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker_flutter/app/home/jobs/empty_content.dart';
import 'package:time_tracker_flutter/app/home/jobs/job_list_tile.dart';
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
        onPressed: () => EditJobPage.show(context),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //jobs is a list of jobs
          final jobs = snapshot.data;
          if (jobs.isNotEmpty) {
          //add toList to change it from iterable object
          final children = jobs
              .map((job) =>
              JobListTile(
                job: job,
                onTap: () => EditJobPage.show(context, job: job),
              ))
              .toList();
          //listView id better when working with dynamic list of children
          return ListView(
            children: children,
          );
          }
          return EmptyContent();

        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Some errors occurred"),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

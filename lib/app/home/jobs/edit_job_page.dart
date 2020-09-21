import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter/app/home/models/job.dart';
import 'package:time_tracker_flutter/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_flutter/services/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key key, @required this.database, this.job})
      : super(key: key);
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, {Job job}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditJobPage(
        database: database,
        job: job,
      ),
    ));
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  int _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
      print('ID: ${widget.job.id}');
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        //make the jobs unique in the database
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if(widget.job != null){
          //excludes the name from the list of existing jobs
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_name)) {
          PlatformAlertDialog(
            title: "Name already used",
            content: "Please choose a different name",
            defaultActionText: "Ok",
          ).show(context);
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(id: id,name: _name, ratePerHour: _ratePerHour);
          await widget.database.setJob(job);
          //close the page when saved
          Navigator.of(context).pop();
        }
      } catch (error) {
        print('error occurred: ${error.message}');
        PlatformAlertDialog(
          title: "Operation failed",
          content: error.message,
          defaultActionText: "Ok",
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: [
          FlatButton(
              onPressed: _submit,
              child: Text(
                'Save',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ))
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: _buildContents(),
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        initialValue: _name,
        onSaved: (value) => _name = value,
        decoration: InputDecoration(labelText: "Job name"),
      ),
      TextFormField(
        initialValue: _ratePerHour != null ? "$_ratePerHour" : null,
        decoration: InputDecoration(labelText: "Rate per hour"),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
      )
    ];
  }
}

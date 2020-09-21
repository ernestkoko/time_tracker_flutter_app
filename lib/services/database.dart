import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter/app/home/models/job.dart';
import 'package:time_tracker_flutter/services/api_path.dart';
import 'package:time_tracker_flutter/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);

  Stream<List<Job>> jobsStream();
}
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance ;


  Future<void> setJob(Job job) async => await _service.setData(
        path: APIPath.job(uid, job.id),
        data: job.toMap(),
      );


  Stream<List<Job>> jobsStream() {
    final path = APIPath.jobs(uid);
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshot = reference.snapshots();
    return snapshot.map(
      (snapshot) => snapshot.docs.map(
        (snapshot) => Job.fromMap(snapshot.data(), snapshot.id )
      ).toList(),
    );
  }



  // Stream<List<T>> _collectionStream<T>({@required String path, @required T builder(Map<String, dynamic>) data}){
  // final reference = FirebaseFirestore.instance.collection(path);
  // final snapshot = reference.snapshots();
  // return snapshot.map(
  // (snapshot) => snapshot.docs.map(
  // (snapshot) => builder(snapshot.data)).toList(),
  // );
  // }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreService{
  FirestoreService._();
  //signleton
  static final instance = FirestoreService._();
  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('Save: $path: $data');
    await reference.set(data);
  }

  // Stream<List<T>> collectionStream<T>({@required String path, @required T builder(Map<String, dynamic>)>}){
  //
  // }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_flow/core/networking/database_service.dart';

class FirestoreService implements DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? docId,
  }) async {
    if (docId != null) {
      await firestore.collection(path).doc(docId).set(data);
    } else {
      await firestore.collection(path).add(data);
    }
  }

  @override
  Future<dynamic> getData({required String path, String? docId}) async {
    if (docId != null) {
      var result = await firestore.collection(path).doc(docId).get();
      return result.data()!;
    } else {
      Query<Map<String, dynamic>> data = firestore.collection(path);

      var result = await data.get();
      return result.docs.map((e) => e.data()).toList();
    }
  }

  @override
  Future<void> deleteData({required String path, required String docId}) async {
    await firestore.collection(path).doc(docId).delete();
  }

  @override
  Future<void> updateData({
    required String path,
    required Map<String, dynamic> data,
    required String docId,
  }) async {
    await firestore.collection(path).doc(docId).update(data);
  }

  @override
  Future<bool> checkIfDocExists({
    required String path,
    required String docId,
  }) async {
    var data = await firestore.collection(path).doc(docId).get();
    return data.exists;
  }
}

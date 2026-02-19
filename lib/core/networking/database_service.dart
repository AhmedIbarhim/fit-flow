abstract class DatabaseService {
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? docId,
  });

  Future<dynamic> getData({required String path, String? docId});

  Future<void> deleteData({required String path, required String docId});

  Future<void> updateData({
    required String path,
    required Map<String, dynamic> data,
    required String docId,
  });

  Future<bool> checkIfDocExists({required String path, required String docId});
}

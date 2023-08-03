import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FbStorageController {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Stream<TaskSnapshot> uploadImage({required String path}) async* {
    UploadTask uploadTask = _firebaseStorage
        .ref('images/${DateTime.now()}_image')
        .putFile(File(path));
    yield* uploadTask.snapshotEvents;
  }

  Future<List<Reference>> read() async {
    ListResult listResult = await _firebaseStorage.ref('images').listAll();
    if (listResult.items.isNotEmpty) {
      return listResult.items;
    }
    return [];
  }

  Future<bool> delete({required String path}) {
    return _firebaseStorage
        .ref(path)
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }
}

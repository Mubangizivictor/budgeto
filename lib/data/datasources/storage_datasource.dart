// data/datasources/storage_datasource.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageDataSource {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a profile photo for [userId] and returns its public download URL.
  Future<String> uploadProfilePhoto(String userId, File file) async {
    final ref = _storage.ref().child('profile_photos/$userId.jpg');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }
}

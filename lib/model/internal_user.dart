import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';


class InternalUser {
  InternalUser({
    required this.uid,
    this.name,
    required this.fetched,
  });

  final String? name;
  final String uid;
  bool fetched;

  Reference get _profilePictureRef =>
      FirebaseStorage.instance.ref(uid).child('profile.jpg');

  set uploadProfilePicture(Uint8List image) =>
      _profilePictureRef.putData(image);

  Future<String> get profilePicture => _profilePictureRef.getDownloadURL();
}

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


  factory InternalUser.fromJson(Map<String, dynamic> json) {
    return InternalUser(
      uid: json['uid'],
      fetched: json['fetched'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'fetched': fetched,
      'name': name,
    };
  }
}

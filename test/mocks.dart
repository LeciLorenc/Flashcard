// lib/mocks.dart
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

@GenerateMocks([FirebaseFirestore, CollectionReference, DocumentReference, FirebaseStorage, Reference])
void main() {}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flashcard/service/firestore_service.dart';
import 'package:flashcard/model/subject.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('FirestoreService', () {
    late FirestoreService firestoreService;
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      firestoreService = FirestoreService(firestore: fakeFirestore);
    });

    test('addSubject should add a subject and return its ID', () async {
      Subject subject = Subject(
        id: 'test_subject',
        user_id: 'test_user',
        name: 'Test Subject',
        decks: [],
        icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
      );

      String id = await firestoreService.addSubject(subject);

      expect(id, isNotNull);
      final docSnapshot = await fakeFirestore.collection('subjects').doc(id).get();
      expect(docSnapshot.exists, isTrue);
      expect(docSnapshot.data(), subject.toJson());
    });

    test('backupData should back up data to JSON string', () async {
      List<Subject> subjects = [
        Subject(
          id: 'subject1',
          user_id: 'user1',
          name: 'Subject 1',
          decks: [],
          icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
        ),
      ];

      String backupJson = jsonEncode(subjects.map((subject) {
        return {
          ...subject.toJson(),
          'decks': subject.decks.map((deck) {
            return {
              ...deck.toJson(),
              'flashcards': deck.flashcards.map((flashcard) => flashcard.toJson()).toList(),
            };
          }).toList(),
        };
      }).toList());
      expect(backupJson, isNotNull);

      List<dynamic> decodedJson = jsonDecode(backupJson);
      expect(decodedJson.length, subjects.length);
    });

    test('restoreData should restore data from JSON string', () async {
      String jsonString = jsonEncode([
        {
          'id': 'subject1',
          'user_id': 'user1',
          'name': 'Subject 1',
          'decks': [],
          'icon': {
            'codePoint': 0xe900,
            'fontFamily': 'MaterialIcons',
            'fontPackage': null,
            'matchTextDirection': false,
          }
        }
      ]);

      List<Subject> subjects = await firestoreService.parseBackupJson(jsonString);
      expect(subjects.length, 1);
      expect(subjects.first.id, 'subject1');
    });
  });
}

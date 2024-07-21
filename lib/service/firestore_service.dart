import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../ChatGPT_services/model-view/api_service.dart';
import '../calendar_and_recap/pastErrors/model/newObject.dart';
import '../model/deck.dart';
import '../model/flashcard.dart';
import '../model/subject.dart';
import 'local_repository_service.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;


  FirestoreService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;


  // Add a new subject to Firestore and update the local instance with the Firestore-generated ID
  Future<String> addSubject(Subject subject) async {
    DocumentReference ref = await _db.collection('subjects').add(subject.toJson());
    subject = subject.copyWith(id: ref.id);  // Update the subject with the generated ID
    await ref.update({'id': ref.id});  // Optionally update the Firestore record with the ID
    return subject.id;
  }

  // Update an existing subject
  Future<void> updateSubject(Subject subject) async {
    await _db.collection('subjects').doc(subject.id).update(subject.toJson());
  }

  // Delete a subject by ID
  Future<void> deleteSubject(String subjectId) async {
    await _db.collection('subjects').doc(subjectId).delete();
  }

  // Stream subjects from Firestore
  Stream<List<Subject>> streamSubjects() {
    return _db.collection('subjects').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Subject.fromJson(doc.data())).toList());
  }

  //add deck to firestore
  Future<String> addDeck(Deck deck) async {
    DocumentReference ref = await _db.collection('decks').add(deck.toJson());
    deck = deck.copyWith(id: ref.id);  // Update the deck with the generated ID
    await ref.update({'id': ref.id});  // Optionally update the Firestore record with the ID
    return deck.id;
  }

  //delete a deck given the subject id and the deck id  }
  Future<void> deleteDeck(String subjectId, String deckId) async {
    await _db.collection('subjects').doc(subjectId).collection('decks').doc(deckId).delete();
  }

  //save a flashcard to firestore given the flashcard and the deck id
  Future<String> addFlashcard(Flashcard flashcard, String deckId) async {
    DocumentReference ref = await _db.collection('decks').doc(deckId).collection('flashcards').add(flashcard.toJson());
    flashcard = flashcard.copyWith(id: ref.id);  // Update the flashcard with the generated ID
    await ref.update({'id': ref.id});  // Optionally update the Firestore record with the ID
    return flashcard.id;
  }

  //create an update flashcard method give the flashcard and the deck id
  Future<void> updateFlashcard(Flashcard flashcard, String deckId) async {
    await _db.collection('decks').doc(deckId).collection('flashcards').doc(flashcard.id).update(flashcard.toJson());
  }

  //delete all subjects on firebasee
  Future<void> deleteAllSubjects() async {
    await _db.collection('subjects').get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  //delete flashcard given the flashcard id and the deck id
  Future<void> deleteFlashcard(String deckId, String flashcardId) async {
    await _db.collection('decks').doc(deckId).collection('flashcards').doc(flashcardId).delete();
  }


  Future<void> backupData(String userId, String backupJson) async {
    // Store the backup data in Firestore under the user's ID
    await _db.collection('backups').doc(userId).set({
      'data': backupJson,
    });
  }

  Future<String> restoreData(String userId) async {
    // Retrieve the backup data from Firestore using the user's ID
    DocumentSnapshot snapshot = await _db.collection('backups').doc(userId).get();

    if (!snapshot.exists) {
      throw Exception('No backup found for this user');
    }

    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    if (data != null) {
      print("Data: ${data['data']}");
      return data['data'] ?? '';
    } else {
      throw Exception('No data found for this user');
    }
  }


  // Method to create a JSON backup string from a list of subjects
  Future<String> createBackupJson(List<Subject> subjects, String userId) async {
    String apiKey = ApiService.getApiKey(userId);
    List<Map<String, dynamic>> subjectsJson = subjects.map((subject) {
      List<Map<String, dynamic>> decksJson = subject.decks.map((deck) {
        List<Map<String, dynamic>> flashcardsJson = deck.flashcards.map((flashcard) {
          return flashcard.toJson();
        }).toList();
        return {
          ...deck.toJson(),
          'flashcards': flashcardsJson,
        };
      }).toList();
      return {
        ...subject.toJson(),
        'decks': decksJson,
      };
    }).toList();
    return jsonEncode({
      'apiKey': apiKey,
      'subjects': subjectsJson,
    });
  }

  // Method to parse a JSON backup string to a list of subjects
  Future<List<Subject>> parseBackupJson(String jsonString, String userId) async {
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    String apiKey = jsonData['apiKey'];
    ApiService.setApiKey(userId, apiKey);
    List<dynamic> subjectsJson = jsonData['subjects'];
    List<Subject> subjects = subjectsJson.map((data) => Subject.fromJson(data)).toList();
    return subjects;
  }

  // Method to create a JSON backup string from a list of pastErrorsObject
  Future<String> createPastErrorsBackupJson(List<pastErrorsObject> pastErrors) async {
    List<Map<String, dynamic>> pastErrorsJson = pastErrors.map((error) => error.toJson()).toList();
    return jsonEncode(pastErrorsJson);
  }

// Method to backup pastErrors data to Firestore
  Future<void> backupPastErrorsData(String userId, List<pastErrorsObject> pastErrors) async {
    String backupJson = await createPastErrorsBackupJson(pastErrors);
    await _db.collection('pastErrors').doc(userId).set({'data': backupJson});
  }

  restorePastErrorsData(String userId) {
    //restore the past errors data from firestore
  return _db.collection('pastErrors').doc(userId).get().then((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String backupJson = data['data'];
        List<dynamic> jsonData = jsonDecode(backupJson);
        List<pastErrorsObject> pastErrors = jsonData.map((data) => pastErrorsObject.fromJson(data)).toList();
        return pastErrors;
      } else {
        throw Exception('No backup found for this user');
      }
    });
  }
  Future<void> restoreDebugData() async {
    try {
      Map<String, dynamic> debugData = jsonDecode(debugDataJson);

      List<dynamic> subjectsJson = debugData['subjects'] ?? [];
      List<Subject> subjects = subjectsJson.map((subjectJson) {
        List<dynamic> decksJson = subjectJson['decks'] ?? [];
        List<Deck> decks = decksJson.map((deckJson) {
          List<dynamic> flashcardsJson = deckJson['flashcards'] ?? [];
          List<Flashcard> flashcards = flashcardsJson.map((flashcardJson) {
            return Flashcard(
              id: flashcardJson['id'] ?? '',
              question: flashcardJson['question'] ?? '',
              answer: flashcardJson['answer'] ?? '',
              index: flashcardJson['index'] ?? 0,
              deckId: flashcardJson['deckId'] ?? '',
            );
          }).toList();

          return Deck(
            id: deckJson['id'] ?? '',
            subjectId: deckJson['subjectId'] ?? '',
            name: deckJson['name'] ?? '',
            icon: IconData(
              deckJson['icon']['codePoint'] ?? 0,
              fontFamily: deckJson['icon']['fontFamily'],
              fontPackage: deckJson['icon']['fontPackage'],
              matchTextDirection: deckJson['icon']['matchTextDirection'] ?? false,
            ),
            flashcards: flashcards,
          );
        }).toList();

        return Subject(
          id: subjectJson['id'] ?? '',
          user_id: subjectJson['user_id'] ?? '',
          name: subjectJson['name'] ?? '',
          icon: IconData(
            subjectJson['icon']['codePoint'] ?? 0,
            fontFamily: subjectJson['icon']['fontFamily'],
            fontPackage: subjectJson['icon']['fontPackage'],
            matchTextDirection: subjectJson['icon']['matchTextDirection'] ?? false,
          ),
          decks: decks,
        );
      }).toList();

      await LocalRepositoryService.clear();

      for (Subject subject in subjects) {
        await LocalRepositoryService.addSubject(subject);
      }

      List<dynamic> errorsJson = debugData['errors'] ?? [];
      await LocalRepositoryService.addErrors('eTem2I3UmDZP2pi7X2tSJiD2u472', List<Map<String, dynamic>>.from(errorsJson));

      List<dynamic> historyJson = debugData['history'] ?? [];
      await LocalRepositoryService.addHistory('eTem2I3UmDZP2pi7X2tSJiD2u472', List<Map<String, dynamic>>.from(historyJson));


    } catch (e, stackTrace) {
      debugPrint('Error populating debug data: $e');
      debugPrint(stackTrace.toString());
    }
  }

  static const String debugDataJson = '''
{
  "subjects": [
    {
      "user_id": "eTem2I3UmDZP2pi7X2tSJiD2u472",
      "name": "Subject 1",
      "icon": {
        "codePoint": 57633,
        "fontFamily": "MaterialIcons",
        "fontPackage": null,
        "matchTextDirection": false
      },
      "id": "subject1",
      "decks": [
        {
          "id": "deck1",
          "name": "Deck 1",
          "icon": {
            "codePoint": 57633,
            "fontFamily": "MaterialIcons",
            "fontPackage": null,
            "matchTextDirection": false
          },
          "subjectId": "subject1",
          "flashcards": [
            {
              "id": "flashcard1",
              "question": "Question 1",
              "answer": "Answer 1"
            },
            {
              "id": "flashcard2",
              "question": "Question 2",
              "answer": "Answer 2"
            }
          ]
        },
        {
          "id": "deck2",
          "name": "Deck 2",
          "icon": {
            "codePoint": 57633,
            "fontFamily": "MaterialIcons",
            "fontPackage": null,
            "matchTextDirection": false
          },
          "subjectId": "subject1",
          "flashcards": [
            {
              "id": "flashcard3",
              "question": "Question 3",
              "answer": "Answer 3"
            },
            {
              "id": "flashcard4",
              "question": "Question 4",
              "answer": "Answer 4"
            }
          ]
        }
      ]
    }
  ],
  "errors": [
    {
      "user_id": "eTem2I3UmDZP2pi7X2tSJiD2u472",
      "subject": "Subject 1",
      "deck": "Deck 1",
      "date": "2024-07-01",
      "time": "10:00:00",
      "length": "1",
      "questions": ["Question 1"],
      "answers": ["Answer 1"]
    }
  ],
  "history": [
    {
      "user_id": "eTem2I3UmDZP2pi7X2tSJiD2u472",
      "subject": "Subject 1",
      "deck": "Deck 1",
      "date": "2024-07-01",
      "time": "10:00:00",
      "length": "1",
      "questions": ["Question 1"],
      "answers": ["Answer 1"]
    }
  ]
}
''';


}
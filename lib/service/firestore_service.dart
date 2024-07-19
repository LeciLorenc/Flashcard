import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/deck.dart';
import '../model/flashcard.dart';
import '../model/subject.dart';

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

  Future<List<Subject>> _fetchAllSubjects() async {
    List<Subject> subjects = [];
    QuerySnapshot subjectSnapshot = await _db.collection('subjects').get();
    for (QueryDocumentSnapshot subjectDoc in subjectSnapshot.docs) {
      Subject subject = Subject.fromJson(subjectDoc.data() as Map<String, dynamic>);
      List<Deck> decks = [];

      // QuerySnapshot deckSnapshot = await _db.collection('subjects').doc(subject.id).collection('decks').get();
      QuerySnapshot deckSnapshot = await _db.collection('decks').where('subject_id', isEqualTo: subject.id).get();

      for (QueryDocumentSnapshot deckDoc in deckSnapshot.docs) {
        Deck deck = Deck.fromJson(deckDoc.data() as Map<String, dynamic>);
        List<Flashcard> flashcards = [];

        QuerySnapshot flashcardSnapshot = await _db.collection('decks').doc(deck.id).collection('flashcards').get();
        for (QueryDocumentSnapshot flashcardDoc in flashcardSnapshot.docs) {
          Flashcard flashcard = Flashcard.fromJson(flashcardDoc.data() as Map<String, dynamic>);
          flashcards.add(flashcard);
        }

        decks.add(deck.addFlashcards(flashcards: flashcards));
      }

      subjects.add(subject.addDecks(decks: decks));
    }

    return subjects;
  }


  // Method to create a JSON backup string from a list of subjects
  Future<String> createBackupJson(List<Subject> subjects) async {
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
    return jsonEncode(subjectsJson);
  }

  // Method to parse a JSON backup string to a list of subjects
  Future<List<Subject>> parseBackupJson(String jsonString) async {
    List<dynamic> jsonData = jsonDecode(jsonString);
    List<Subject> subjects = jsonData.map((data) => Subject.fromJson(data)).toList();
    return subjects;
  }
}
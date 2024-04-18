import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/deck.dart';
import '../model/flashcard.dart';
import '../model/subject.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


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

}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flashcard/model/subject.dart';
import 'package:flashcard/model/deck.dart';
import 'package:flashcard/model/flashcard.dart';

void main() {
  group('Manual Integration Test for Subject, Decks, and Flashcards', () {
    late List<Subject> subjects;

    setUp(() {
      subjects = [];
    });

    test('Add Subject, Decks, and Flashcards locally', () async {
      // Step 1: Add a new subject
      final subject = Subject(
        id: 'subject1',
        user_id: 'user1',
        name: 'Test Subject',
        decks: [],
        icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
      );

      subjects.add(subject);

      // Verify subject is added
      expect(subjects, isNotEmpty);
      expect(subjects.first.name, 'Test Subject');

      // Step 2: Add decks to the subject
      final deck1 = Deck(
        id: 'deck1',
        subjectId: 'subject1',
        name: 'Deck 1',
        icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
        flashcards: [],
      );

      final deck2 = Deck(
        id: 'deck2',
        subjectId: 'subject1',
        name: 'Deck 2',
        icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
        flashcards: [],
      );

      subject.decks.add(deck1);
      subject.decks.add(deck2);

      // Verify decks are added
      final updatedSubject = subjects.firstWhere((sub) => sub.id == 'subject1');
      expect(updatedSubject.decks.length, 2);
      expect(updatedSubject.decks[0].name, 'Deck 1');
      expect(updatedSubject.decks[1].name, 'Deck 2');

      // Step 3: Add flashcards to decks
      final flashcard1 = Flashcard(
        id: 'flashcard1',
        deckId: 'deck1',
        question: 'Question 1',
        answer: 'Answer 1',
        index: 0,
      );

      final flashcard2 = Flashcard(
        id: 'flashcard2',
        deckId: 'deck1',
        question: 'Question 2',
        answer: 'Answer 2',
        index: 1,
      );

      deck1.flashcards.add(flashcard1);
      deck1.flashcards.add(flashcard2);

      // Verify flashcards are added
      final updatedDeck = updatedSubject.decks.firstWhere((deck) => deck.id == 'deck1');
      expect(updatedDeck.flashcards.length, 2);
      expect(updatedDeck.flashcards[0].question, 'Question 1');
      expect(updatedDeck.flashcards[1].question, 'Question 2');
    });

    test('Update Flashcard locally', () async {
      // Setup initial state
      final flashcard = Flashcard(
        id: 'flashcard1',
        deckId: 'deck1',
        question: 'Initial Question',
        answer: 'Initial Answer',
        index: 0,
      );

      final deck = Deck(
        id: 'deck1',
        subjectId: 'subject1',
        name: 'Deck 1',
        icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
        flashcards: [flashcard],
      );

      final subject = Subject(
        id: 'subject1',
        user_id: 'user1',
        name: 'Test Subject',
        decks: [deck],
        icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
      );

      subjects.add(subject);

      // Update flashcard
      final updatedFlashcard = Flashcard(
        id: 'flashcard1',
        deckId: 'deck1',
        question: 'Updated Question',
        answer: 'Updated Answer',
        index: 0,
      );

      deck.flashcards[0] = updatedFlashcard;

      // Verify flashcard is updated
      final updatedDeck = subjects.first.decks.first;
      expect(updatedDeck.flashcards[0].question, 'Updated Question');
      expect(updatedDeck.flashcards[0].answer, 'Updated Answer');
    });

    test('Delete Flashcard locally', () async {
      // Setup initial state
      final flashcard1 = Flashcard(
        id: 'flashcard1',
        deckId: 'deck1',
        question: 'Question 1',
        answer: 'Answer 1',
        index: 0,
      );

      final flashcard2 = Flashcard(
        id: 'flashcard2',
        deckId: 'deck1',
        question: 'Question 2',
        answer: 'Answer 2',
        index: 1,
      );

      final deck = Deck(
        id: 'deck1',
        subjectId: 'subject1',
        name: 'Deck 1',
        icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
        flashcards: [flashcard1, flashcard2],
      );

      final subject = Subject(
        id: 'subject1',
        user_id: 'user1',
        name: 'Test Subject',
        decks: [deck],
        icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
      );

      subjects.add(subject);

      // Delete flashcard
      deck.flashcards.removeWhere((flashcard) => flashcard.id == 'flashcard1');

      // Verify flashcard is deleted
      final updatedDeck = subjects.first.decks.first;
      expect(updatedDeck.flashcards.length, 1);
      expect(updatedDeck.flashcards[0].question, 'Question 2');
    });

    test('Delete Deck locally', () async {
      // Setup initial state
      final deck1 = Deck(
        id: 'deck1',
        subjectId: 'subject1',
        name: 'Deck 1',
        icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
        flashcards: [],
      );

      final deck2 = Deck(
        id: 'deck2',
        subjectId: 'subject1',
        name: 'Deck 2',
        icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
        flashcards: [],
      );

      final subject = Subject(
        id: 'subject1',
        user_id: 'user1',
        name: 'Test Subject',
        decks: [deck1, deck2],
        icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
      );

      subjects.add(subject);

      // Delete deck
      subject.decks.removeWhere((deck) => deck.id == 'deck1');

      // Verify deck is deleted
      final updatedSubject = subjects.first;
      expect(updatedSubject.decks.length, 1);
      expect(updatedSubject.decks[0].name, 'Deck 2');
    });

    test('Delete Subject locally', () async {
      // Setup initial state
      final subject1 = Subject(
        id: 'subject1',
        user_id: 'user1',
        name: 'Test Subject 1',
        decks: [],
        icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
      );

      final subject2 = Subject(
        id: 'subject2',
        user_id: 'user2',
        name: 'Test Subject 2',
        decks: [],
        icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
      );

      subjects.add(subject1);
      subjects.add(subject2);

      // Delete subject
      subjects.removeWhere((subject) => subject.id == 'subject1');

      // Verify subject is deleted
      expect(subjects.length, 1);
      expect(subjects[0].name, 'Test Subject 2');
    });
  });
}

/**
 * Explanation of Additional Tests

    Update Flashcard:
    Add a subject with a deck and a flashcard.
    Update the flashcard.
    Verify the flashcard is updated correctly.

    Delete Flashcard:
    Add a subject with a deck and two flashcards.
    Delete one flashcard.
    Verify the flashcard is deleted correctly.

    Delete Deck:
    Add a subject with two decks.
    Delete one deck.
    Verify the deck is deleted correctly.

    Delete Subject:
    Add two subjects.
    Delete one subject.
    Verify the subject is deleted correctly.
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flashcard/model/subject.dart';
import 'package:flashcard/model/deck.dart';
import 'package:flashcard/model/flashcard.dart';
import 'package:flashcard/service/local_repository_service.dart';

void main() {
  group('Local Repository Service Integration Test', () {
    late LocalRepositoryService localRepositoryService;

    setUp(() async {
      localRepositoryService = LocalRepositoryService();
      await LocalRepositoryService.clear(); // Clear any existing data
    });

    test('Add Subject, Decks, and Flashcards locally', () async {
      // Add a new subject
      final subject = Subject(
        id: 'subject1',
        user_id: 'user1',
        name: 'Test Subject',
        decks: [],
        icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
      );

      await LocalRepositoryService.addSubject(subject);

      // Verify subject is added
      final subjects = await LocalRepositoryService.getSubjects();
      expect(subjects, isNotEmpty);
      expect(subjects.first.name, 'Test Subject');

      // Add decks to the subject
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

      await LocalRepositoryService.addDeck(subject, deck1);
      await LocalRepositoryService.addDeck(subject, deck2);

      // Verify decks are added
      final updatedSubjects = await LocalRepositoryService.getSubjects();
      final updatedSubject = updatedSubjects.firstWhere((sub) => sub.id == 'subject1');
      expect(updatedSubject.decks.length, 2);
      expect(updatedSubject.decks[0].name, 'Deck 1');
      expect(updatedSubject.decks[1].name, 'Deck 2');

      // Add flashcards to decks
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

      await LocalRepositoryService.addFlashcard(deck1, flashcard1);
      await LocalRepositoryService.addFlashcard(deck1, flashcard2);

      // Verify flashcards are added
      final updatedDecks = updatedSubject.decks.firstWhere((deck) => deck.id == 'deck1');
      expect(updatedDecks.flashcards.length, 2);
      expect(updatedDecks.flashcards[0].question, 'Question 1');
      expect(updatedDecks.flashcards[1].question, 'Question 2');
    });
  });
}

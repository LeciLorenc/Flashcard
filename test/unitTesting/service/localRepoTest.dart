import 'package:flutter_test/flutter_test.dart';
import 'package:flashcard/service/local_repository_service.dart';
import 'package:flashcard/model/subject.dart';
import 'package:flashcard/model/deck.dart';
import 'package:flashcard/model/flashcard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalRepositoryService', () {
    late LocalRepositoryService localRepositoryService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      localRepositoryService = LocalRepositoryService();
    });

    test('addNewSubject should add a subject to local storage', () async {
      final subject = Subject(
        id: 'test_subject',
        user_id: 'test_user',
        name: 'Test Subject',
        decks: [],
        icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
      );

      await LocalRepositoryService.addNewSubject(
        user_id: subject.user_id,
        name: subject.name,
        icon: subject.icon,
      );

      final subjects = await LocalRepositoryService.getSubjects();
      expect(subjects.length, 1);
      expect(subjects.first.name, 'Test Subject');
    });

    test('getSubjects should return a list of subjects from local storage', () async {
      final subject1 = Subject(
        id: 'subject1',
        user_id: 'user1',
        name: 'Subject 1',
        decks: [],
        icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
      );
      final subject2 = Subject(
        id: 'subject2',
        user_id: 'user2',
        name: 'Subject 2',
        decks: [],
        icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
      );

      await LocalRepositoryService.addNewSubject(
        user_id: subject1.user_id,
        name: subject1.name,
        icon: subject1.icon,
      );

      await LocalRepositoryService.addNewSubject(
        user_id: subject2.user_id,
        name: subject2.name,
        icon: subject2.icon,
      );

      final subjects = await LocalRepositoryService.getSubjects();
      expect(subjects.length, 2);
    });

    test('addNewDeck should add a deck to a subject', () async {
      final subject = await LocalRepositoryService.addNewSubject(
        user_id: 'user1',
        name: 'Subject 1',
        icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
      );

      final deck = await LocalRepositoryService.addNewDeck(
        name: 'Deck 1',
        icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
        subject: subject,
      );

      final updatedSubject = await LocalRepositoryService.getSubject(subject.id);

      expect(updatedSubject?.decks.length, 1);
      expect(updatedSubject?.decks.first.name, 'Deck 1');
    });

    test('addNewFlashcard should add a flashcard to a deck', () async {
      final subject = await LocalRepositoryService.addNewSubject(
        user_id: 'user1',
        name: 'Subject 1',
        icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
      );

      final deck = await LocalRepositoryService.addNewDeck(
        name: 'Deck 1',
        icon: IconData(0xe900, fontFamily: 'MaterialIcons'),
        subject: subject,
      );

      final flashcard = await LocalRepositoryService.addNewFlashcard(
        question: 'Question 1',
        answer: 'Answer 1',
        index: 0,
        deck: deck,
      );

      final updatedDeck = await LocalRepositoryService.getDeck(deck.id);

      expect(updatedDeck?.flashcards.length, 1);
      expect(updatedDeck?.flashcards.first.question, 'Question 1');
    });

    // Add more tests for other methods of LocalRepositoryService
  });
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flashcard/model/deck.dart';
import 'package:flashcard/model/flashcard.dart';

void main() {
  group('Deck', () {
    test('fromJson should return a valid model', () {
      // Arrange
      final json = {
        'id': 'deck1',
        'subjectId': 'subject1',
        'name': 'Deck 1',
        'icon': {
          'codePoint': 0xe145,
          'fontFamily': 'MaterialIcons',
          'fontPackage': null,
          'matchTextDirection': false,
        },
        'flashcards': [
          {
            'id': 'flashcard1',
            'deckId': 'deck1',
            'question': 'Question 1',
            'answer': 'Answer 1',
            'index': 0,
          }
        ],
      };

      // Act
      final deck = Deck.fromJson(json);

      // Assert
      expect(deck.id, 'deck1');
      expect(deck.subjectId, 'subject1');
      expect(deck.name, 'Deck 1');
      expect(deck.icon.codePoint, 0xe145);
      expect(deck.flashcards.length, 1);
      final flashcard = deck.flashcards[0];
      expect(flashcard.id, 'flashcard1');
      expect(flashcard.deckId, 'deck1');
      expect(flashcard.question, 'Question 1');
      expect(flashcard.answer, 'Answer 1');
      expect(flashcard.index, 0);
    });

    test('toJson should return a valid JSON map', () {
      // Arrange
      final flashcard = Flashcard(
        id: 'flashcard1',
        deckId: 'deck1',
        question: 'Question 1',
        answer: 'Answer 1',
        index: 0,
      );
      final deck = Deck(
        id: 'deck1',
        subjectId: 'subject1',
        name: 'Deck 1',
        icon: IconData(
          0xe145,
          fontFamily: 'MaterialIcons',
          fontPackage: null,
          matchTextDirection: false,
        ),
        flashcards: [flashcard],
      );

      // Act
      final json = deck.toJson();

      // Assert
      expect(json['id'], 'deck1');
      expect(json['subjectId'], 'subject1');
      expect(json['name'], 'Deck 1');
      expect(json['icon']['codePoint'], 0xe145);
      expect(json['flashcards'].length, 1);
      final flashcardJson = json['flashcards'][0];
      expect(flashcardJson['id'], 'flashcard1');
      expect(flashcardJson['deckId'], 'deck1');
      expect(flashcardJson['question'], 'Question 1');
      expect(flashcardJson['answer'], 'Answer 1');
      expect(flashcardJson['index'], 0);
    });

    test('copyWith should return a valid copy with updated fields', () {
      // Arrange
      final flashcard = Flashcard(
        id: 'flashcard1',
        deckId: 'deck1',
        question: 'Question 1',
        answer: 'Answer 1',
        index: 0,
      );
      final deck = Deck(
        id: 'deck1',
        subjectId: 'subject1',
        name: 'Deck 1',
        icon: IconData(
          0xe145,
          fontFamily: 'MaterialIcons',
          fontPackage: null,
          matchTextDirection: false,
        ),
        flashcards: [flashcard],
      );

      // Act
      final updatedDeck = deck.copyWith(
        name: 'Updated Deck',
        flashcards: [],
      );

      // Assert
      expect(updatedDeck.id, 'deck1');
      expect(updatedDeck.subjectId, 'subject1');
      expect(updatedDeck.name, 'Updated Deck');
      expect(updatedDeck.icon.codePoint, 0xe145);
      expect(updatedDeck.flashcards.isEmpty, true);
    });

    test('compareTo should compare by name', () {
      // Arrange
      final deck1 = Deck(
        id: 'deck1',
        subjectId: 'subject1',
        name: 'Deck A',
        icon: IconData(
          0xe145,
          fontFamily: 'MaterialIcons',
          fontPackage: null,
          matchTextDirection: false,
        ),
        flashcards: [],
      );

      final deck2 = Deck(
        id: 'deck2',
        subjectId: 'subject2',
        name: 'Deck B',
        icon: IconData(
          0xe145,
          fontFamily: 'MaterialIcons',
          fontPackage: null,
          matchTextDirection: false,
        ),
        flashcards: [],
      );

      // Act & Assert
      expect(deck1.compareTo(deck2), -1);
      expect(deck2.compareTo(deck1), 1);
    });

    test('toString should return a JSON string representation', () {
      // Arrange
      final flashcard = Flashcard(
        id: 'flashcard1',
        deckId: 'deck1',
        question: 'Question 1',
        answer: 'Answer 1',
        index: 0,
      );
      final deck = Deck(
        id: 'deck1',
        subjectId: 'subject1',
        name: 'Deck 1',
        icon: IconData(
          0xe145,
          fontFamily: 'MaterialIcons',
          fontPackage: null,
          matchTextDirection: false,
        ),
        flashcards: [flashcard],
      );

      // Act
      final deckString = deck.toString();

      // Assert
      expect(deckString, deck.toJson().toString());
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flashcard/model/flashcard.dart';

void main() {
  group('Flashcard', () {
    test('fromJson should return a valid model', () {
      // Arrange
      final json = {
        'id': '12345',
        'deckId': 'deck1',
        'question': 'What is Flutter?',
        'answer': 'A UI toolkit for building natively compiled applications',
        'index': 0,
      };

      // Act
      final flashcard = Flashcard.fromJson(json);

      // Assert
      expect(flashcard.id, '12345');
      expect(flashcard.deckId, 'deck1');
      expect(flashcard.question, 'What is Flutter?');
      expect(flashcard.answer, 'A UI toolkit for building natively compiled applications');
      expect(flashcard.index, 0);
    });

    test('toJson should return a valid JSON map', () {
      // Arrange
      final flashcard = Flashcard(
        id: '12345',
        deckId: 'deck1',
        question: 'What is Flutter?',
        answer: 'A UI toolkit for building natively compiled applications',
        index: 0,
      );

      // Act
      final json = flashcard.toJson();

      // Assert
      expect(json['id'], '12345');
      expect(json['deckId'], 'deck1');
      expect(json['question'], 'What is Flutter?');
      expect(json['answer'], 'A UI toolkit for building natively compiled applications');
      expect(json['index'], 0);
    });

    test('copyWith should return a valid copy with updated fields', () {
      // Arrange
      final flashcard = Flashcard(
        id: '12345',
        deckId: 'deck1',
        question: 'What is Flutter?',
        answer: 'A UI toolkit for building natively compiled applications',
        index: 0,
      );

      // Act
      final updatedFlashcard = flashcard.copyWith(
        question: 'Updated question',
        answer: 'Updated answer',
        index: 1,
      );

      // Assert
      expect(updatedFlashcard.id, '12345');
      expect(updatedFlashcard.deckId, 'deck1'); // Ensure deckId remains the same
      expect(updatedFlashcard.question, 'Updated question');
      expect(updatedFlashcard.answer, 'Updated answer');
      expect(updatedFlashcard.index, 1);
    });

    test('compareTo should compare by index', () {
      // Arrange
      final flashcard1 = Flashcard(
        id: '12345',
        deckId: 'deck1',
        question: 'What is Flutter?',
        answer: 'A UI toolkit for building natively compiled applications',
        index: 0,
      );

      final flashcard2 = Flashcard(
        id: '67890',
        deckId: 'deck1',
        question: 'What is Dart?',
        answer: 'A programming language optimized for building UI',
        index: 1,
      );

      // Act & Assert
      expect(flashcard1.compareTo(flashcard2), -1);
      expect(flashcard2.compareTo(flashcard1), 1);
    });
  });
}

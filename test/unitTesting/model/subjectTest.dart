
          import 'package:flutter/material.dart';
          import 'package:flutter_test/flutter_test.dart';
          import 'package:flashcard/model/subject.dart';
          import 'package:flashcard/model/deck.dart';
          import 'package:flashcard/model/flashcard.dart';

          void main() {
        group('Subject', () {
          test('fromJson should return a valid model', () {
            // Arrange
            final json = {
              'id': 'subject1',
              'user_id': 'user1',
              'name': 'Subject 1',
              'icon': {
                'codePoint': 0xe145,
                'fontFamily': 'MaterialIcons',
                'fontPackage': null,
                'matchTextDirection': false,
              },
              'decks': [
                {
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
                }
              ],
            };

            // Act
            final subject = Subject.fromJson(json);

            // Assert
            expect(subject.id, 'subject1');
            expect(subject.user_id, 'user1');
            expect(subject.name, 'Subject 1');
            expect(subject.icon.codePoint, 0xe145);
            expect(subject.decks.length, 1);
            final deck = subject.decks[0];
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
            final subject = Subject(
              id: 'subject1',
              user_id: 'user1',
              name: 'Subject 1',
              icon: IconData(
                0xe145,
                fontFamily: 'MaterialIcons',
                fontPackage: null,
                matchTextDirection: false,
              ),
              decks: [deck],
            );

            // Act
            final json = subject.toJson();

            // Assert
            expect(json['id'], 'subject1');
            expect(json['user_id'], 'user1');
            expect(json['name'], 'Subject 1');
            expect(json['icon']['codePoint'], 0xe145);
            expect(json['decks'].length, 1);
            final deckJson = json['decks'][0];
            expect(deckJson['id'], 'deck1');
            expect(deckJson['subjectId'], 'subject1');
            expect(deckJson['name'], 'Deck 1');
            expect(deckJson['icon']['codePoint'], 0xe145);
            expect(deckJson['flashcards'].length, 1);
            final flashcardJson = deckJson['flashcards'][0];
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
            final subject = Subject(
              id: 'subject1',
              user_id: 'user1',
              name: 'Subject 1',
              icon: IconData(
                0xe145,
                fontFamily: 'MaterialIcons',
                fontPackage: null,
                matchTextDirection: false,
              ),
              decks: [deck],
            );

            // Act
            final updatedSubject = subject.copyWith(name: 'Updated Subject');

            // Assert
            expect(updatedSubject.id, 'subject1');
            expect(updatedSubject.user_id, 'user1');
            expect(updatedSubject.name, 'Updated Subject');
            expect(updatedSubject.icon.codePoint, 0xe145);
            expect(updatedSubject.decks.length, 1);
          });

          test('compareTo should compare by name', () {
            // Arrange
            final subject1 = Subject(
              id: 'subject1',
              user_id: 'user1',
              name: 'Subject A',
              icon: IconData(
                0xe145,
                fontFamily: 'MaterialIcons',
                fontPackage: null,
                matchTextDirection: false,
              ),
              decks: [],
            );

            final subject2 = Subject(
              id: 'subject2',
              user_id: 'user2',
              name: 'Subject B',
              icon: IconData(
                0xe145,
                fontFamily: 'MaterialIcons',
                fontPackage: null,
                matchTextDirection: false,
              ),
              decks: [],
            );

            // Act & Assert
            expect(subject1.compareTo(subject2), -1);
            expect(subject2.compareTo(subject1), 1);
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
            final subject = Subject(
              id: 'subject1',
              user_id: 'user1',
              name: 'Subject 1',
              icon: IconData(
                0xe145,
                fontFamily: 'MaterialIcons',
                fontPackage: null,
                matchTextDirection: false,
              ),
              decks: [deck],
            );

            // Act
            final subjectString = subject.toString();

            // Assert
            expect(subjectString, subject.toJson().toString());
          });
        });
      }

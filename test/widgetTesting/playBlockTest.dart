import 'package:flashcard/bloc/play_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashcard/model/flashcard.dart';
import 'package:flashcard/model/deck.dart';
import 'package:flashcard/model/subject.dart';


void main() {
  group('PlayWidget', () {
    late Subject subject;
    late Deck deck;

    setUp(() {
      subject = Subject(
        id: 'subject1',
        user_id: 'user1',
        name: 'Test Subject',
        icon: Icons.school,
        decks: [],
      );

      deck = Deck(
        id: 'deck1',
        subjectId: 'subject1',
        name: 'Test Deck',
        icon: Icons.book,
        flashcards: [
          Flashcard(id: 'flashcard1', deckId: 'deck1', question: 'Question 1', answer: 'Answer 1', index: 0),
          Flashcard(id: 'flashcard2', deckId: 'deck1', question: 'Question 2', answer: 'Answer 2', index: 1),
        ],
      );
    });

    testWidgets('shows start button initially', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: PlayWidget(subject: subject, deck: deck)));
      expect(find.text('Start'), findsOneWidget);
    });

    testWidgets('shows first flashcard when started', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: PlayWidget(subject: subject, deck: deck)));
      await tester.tap(find.text('Start'));
      await tester.pump();
      expect(find.text('Question 1'), findsOneWidget);
    });

    testWidgets('shows second flashcard when answered correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: PlayWidget(subject: subject, deck: deck)));
      await tester.tap(find.text('Start'));
      await tester.pump();
      await tester.tap(find.text('Correct'));
      await tester.pump();
      expect(find.text('Question 2'), findsOneWidget);
    });

    testWidgets('shows finished when all flashcards answered', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: PlayWidget(subject: subject, deck: deck)));
      await tester.tap(find.text('Start'));
      await tester.pump();
      await tester.tap(find.text('Correct'));
      await tester.pump();
      await tester.tap(find.text('Correct'));
      await tester.pump();
      expect(find.text('Finished!'), findsOneWidget);
    });
  });
}


class PlayWidget extends StatelessWidget {
  final Subject subject;
  final Deck deck;

  const PlayWidget({Key? key, required this.subject, required this.deck}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlayBloc(subject: subject, deck: deck),
      child: BlocBuilder<PlayBloc, PlayState>(
        builder: (context, state) {
          if (state is Playing) {
            return Column(
              children: [
                Text(state.nextFlashcard.question),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<PlayBloc>(context).add(Answer(correct: true));
                  },
                  child: Text('Correct'),
                ),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<PlayBloc>(context).add(Answer(correct: false));
                  },
                  child: Text('Incorrect'),
                ),
              ],
            );
          } else if (state is Finished) {
            return Column(
              children: [
                Text('Finished!'),
                Text('Incorrect Flashcards: ${BlocProvider.of<PlayBloc>(context).getIncorrectFlashcards().length}'),
              ],
            );
          } else {
            return ElevatedButton(
              onPressed: () {
                BlocProvider.of<PlayBloc>(context).add(Play());
              },
              child: Text('Start'),
            );
          }
        },
      ),
    );
  }
}

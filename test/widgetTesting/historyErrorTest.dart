import 'package:flashcard/calendar_and_recap/historyErrorList/historyError.dart';
import 'package:flashcard/calendar_and_recap/historyErrorList/historyErrorViewModel.dart';
import 'package:flashcard/calendar_and_recap/historyErrorList/view/orderMenuWidget.dart';
import 'package:flashcard/calendar_and_recap/pastErrors/model/newObject.dart';
import 'package:flashcard/calendar_and_recap/pastErrors/storage/NewSavings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HistoryError Widget Tests', () {
    late HistoryErrorViewModel viewModel;

    setUp(() {
      viewModel = HistoryErrorViewModel();
    });

    testWidgets('Initial UI components are displayed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryError(viewModel: viewModel),
          ),
        ),
      );

      expect(find.text('Filters'), findsOneWidget);
      expect(find.text('Order'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Filter button expands and collapses', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryError(viewModel: viewModel),
          ),
        ),
      );

      // Initially collapsed
      expect(find.text('Hide Filters'), findsNothing);

      // Tap to expand
      await tester.tap(find.text('Filters'));
      await tester.pumpAndSettle();
      expect(find.text('Hide Filters'), findsOneWidget);

      // Tap to collapse
      await tester.tap(find.text('Hide Filters'));
      await tester.pumpAndSettle();
      expect(find.text('Hide Filters'), findsNothing);
    });

    testWidgets('Order button expands and collapses', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryError(viewModel: viewModel),
          ),
        ),
      );

      // Initially collapsed
      expect(find.text('Hide Order'), findsNothing);

      // Tap to expand
      await tester.tap(find.text('Order'));
      await tester.pumpAndSettle();
      expect(find.text('Hide Order'), findsOneWidget);

      // Tap to collapse
      await tester.tap(find.text('Hide Order'));
      await tester.pumpAndSettle();
      expect(find.text('Hide Order'), findsNothing);
    });

    testWidgets('Filter menu displays correctly', (WidgetTester tester) async {

      final viewModel = HistoryErrorViewModel();
      viewModel.updateSubjectFilter('Math');
      viewModel.updateDeckFilter('Deck 1');
      viewModel.updateDateFilter('2023-07-21');

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryError(viewModel: viewModel),
          ),
        ),
      );

      // Trigger the filter button to expand the filter menu
      await tester.tap(find.text('Filters'));
      await tester.pumpAndSettle();

      // Allow more time for the widgets to render
      await tester.pumpAndSettle();

      // Check for the presence of the filter options
      expect(find.text('Select Subject'), findsNothing);
      expect(find.text('Select Deck'), findsNothing);
      expect(find.text('Filter Date'), findsNothing);
    });


    testWidgets('Order menu displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryError(viewModel: viewModel),
          ),
        ),
      );

      await tester.tap(find.text('Order'));
      await tester.pumpAndSettle();

      expect(find.byType(OrderMenu), findsOneWidget);
    });

    testWidgets('Deleting all records shows confirmation dialog', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryError(viewModel: viewModel),
          ),
        ),
      );

      await tester.tap(find.text('Delete all the records'));
      await tester.pumpAndSettle();

      expect(find.text('Delete All Records'), findsOneWidget);
      expect(find.text('Are you sure you want to delete all records?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('Confirming deletion deletes all records', (WidgetTester tester) async {
      NewSavings.savings.add(
          PastErrorsObject(user_id: '1', subject: 'Math', deck: 'Deck 1', date: '2023-07-21',
            time: '12:32:21',numberOfTotalFlashcards: "3",wrongQuestions:["sas","da","da"],wrongAnswers:["sas","da","da"]));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryError(viewModel: viewModel),
          ),
        ),
      );

      await tester.tap(find.text('Delete all the records'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(NewSavings.savings.isEmpty, true);
    });
  });
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flashcard/bloc/subject_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashcard/model/subject.dart';
import 'package:flashcard/model/deck.dart';
import 'package:flashcard/service/firestore_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flashcard/service/firestore_service.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  group('SubjectWidget', () {
    late FirestoreService firestoreService;
    late FakeFirebaseFirestore fakeFirebaseFirestore;


    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      fakeFirebaseFirestore = FakeFirebaseFirestore();
      firestoreService = FirestoreService(firestore: fakeFirebaseFirestore);
    });

    testWidgets('shows Add Subject button initially', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SubjectWidget(firestoreService: firestoreService)));
      expect(find.text('Add Subject'), findsOneWidget);
    });

    testWidgets('adds subject and shows subject name', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SubjectWidget(firestoreService: firestoreService)));
      await tester.tap(find.text('Add Subject'));
      await tester.pumpAndSettle();

      expect(find.text('Subject: New Subject'), findsOneWidget);
      expect(find.text('Add Deck'), findsOneWidget);
    });

    testWidgets('adds deck and shows deck name', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SubjectWidget(firestoreService: firestoreService)));
      await tester.tap(find.text('Add Subject'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add Deck'));
      await tester.pumpAndSettle();

      expect(find.text('Deck: New Deck'), findsOneWidget);
    });
  });
}

class SubjectWidget extends StatelessWidget {

  final FirestoreService firestoreService;



  const SubjectWidget({Key? key, required this.firestoreService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubjectBloc(firestoreService: firestoreService),
      child: BlocBuilder<SubjectBloc, SubjectState>(
        builder: (context, state) {
          if (state.subject == null) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<SubjectBloc>(context).add(AddSubject(
                    user_id: 'user1',
                    name: 'New Subject',
                    icon: Icons.subject,
                  ));
                },
                child: Text('Add Subject'),
              ),
            );
          } else {
            return Column(
              children: [
                Text('Subject: ${state.subject!.name}'),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<SubjectBloc>(context).add(AddDeck(
                      name: 'New Deck',
                      icon: Icons.deck,
                    ));
                  },
                  child: Text('Add Deck'),
                ),
                if (state.deck != null) Text('Deck: ${state.deck!.name}'),
              ],
            );
          }
        },
      ),
    );
  }
}
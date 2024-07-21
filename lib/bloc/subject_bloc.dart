import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flashcard/service/local_repository_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../ChatGPT_services/model-view/api_service.dart';
import '../calendar_and_recap/pastErrors/model/newObject.dart';
import '../calendar_and_recap/pastErrors/storage/NewSavings.dart';
import '../main.dart';
import '../model/deck.dart';
import '../model/flashcard.dart';
import '../model/subject.dart';
import '../service/firestore_service.dart';




abstract class SubjectEvent {}

/// LOAD

class _LoadLocal extends SubjectEvent {}

/// MODIFY

class SaveFlashcard extends SubjectEvent {
  final Flashcard flashcard;
  final Completer? completer;
  final String? question;
  final String? answer;
  final int? index;

  SaveFlashcard({
    required this.flashcard,
    this.completer,
    required this.question,
    required this.answer,
    this.index,
  });
}

class ReorderFlashcard extends SubjectEvent {
  final int newIndex;
  final int oldIndex;

  ReorderFlashcard({
    required this.newIndex,
    required this.oldIndex,
  });
}

class PopulateDB extends SubjectEvent {
  final String userId;

  PopulateDB(this.userId);

  @override
  List<Object> get props => [userId];
}

class BackupData extends SubjectEvent {
  final String userId;

  BackupData(this.userId);

  @override
  List<Object> get props => [userId];
}

class RestoreData extends SubjectEvent {
  final String userId;

  RestoreData(this.userId);

  @override
  List<Object> get props => [userId];
}

/// ADD

class AddSubject extends SubjectEvent {
  final String name;
  final IconData icon;
  final String user_id;

  AddSubject({
    required this.user_id,
    required this.name,
    required this.icon,
  });
}

class AddDeck extends SubjectEvent {
  final String name;
  final IconData icon;

  AddDeck({
    required this.name,
    required this.icon,
  });
}

class AddFlashcard extends SubjectEvent {
  final String question;
  final String answer;
  final int index;

  AddFlashcard({
    this.question = '',
    this.answer = '',
    required this.index,
  });
}

/// DELETE

class DeleteFlashcard extends SubjectEvent {
  final int index;

  DeleteFlashcard({
    required this.index,
  });
}

class DeleteDeck extends SubjectEvent {
  final Deck? deck;

  DeleteDeck({
    required this.deck,
  });
}

class DeleteSubject extends SubjectEvent {
  final Subject subject;

  DeleteSubject({
    required this.subject,
  });
}

class DeleteAllSubjects extends SubjectEvent {}

/// SELECT
class SelectSubject extends SubjectEvent {
  final Subject? subject;

  SelectSubject(this.subject);
}

class SelectDeck extends SubjectEvent {
  final Deck? deck;
  final bool visualize;

  SelectDeck(this.deck, {this.visualize = false});
}

class SubjectState {
  final List<Subject> subjects;
  final Subject? subject;
  final Deck? deck;
  final bool? visualize;

  SubjectState({
    required this.subjects,
    this.subject,
    this.deck,
    this.visualize
  });

  get id => subject!.id;
}

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final FirestoreService firestoreService;


  SubjectBloc({required this.firestoreService})
      : super(SubjectState(subjects: [])) {
    on<AddDeck>(_onAddDeck);
    on<SelectSubject>(_onSelectSubject);
    on<SelectDeck>(_onSelectDeck);
    on<DeleteDeck>(_onDeleteDeck);
    on<DeleteSubject>(_onDeleteSubject);
    on<AddFlashcard>(_onAddFlashCard);
    on<SaveFlashcard>(_onSaveFlashcard);
    on<AddSubject>(_onAddSubject);
    on<_LoadLocal>(_onLoadLocal);
    on<DeleteAllSubjects>(_onDeleteAllSubject);
    on<ReorderFlashcard>(_onReorderFlashcard);
    on<DeleteFlashcard>(_onDeleteFlashcard);
    on<BackupData>(_onBackupData);
    on<RestoreData>(_onRestoreData);
    add(_LoadLocal());
    on<PopulateDB>(_onPopulateDB);
  }


  _onAddDeck(AddDeck event, Emitter<SubjectState> emit) async {
    if (state.subject == null) {
      return;
    }

    debugPrint('AddDeck');

    Deck deck = await LocalRepositoryService.addNewDeck(
      subject: state.subject!,
      name: event.name,
      icon: event.icon,
    );

    Subject subject = state.subject!
      ..decks.add(deck);

    firestoreService.addDeck(deck);

    emit(SubjectState(
      subjects: state.subjects,
      subject: subject,
      deck: state.deck,
    ));
  }

  _onSelectSubject(SelectSubject event, Emitter<SubjectState> emit) {
    debugPrint('SelectSubject');

    emit(SubjectState(
      subjects: state.subjects,
      subject: event.subject,
    ));
  }

  _onSelectDeck(SelectDeck event, Emitter<SubjectState> emit) {
    if (state.subject == null) {
      return;
    }

    debugPrint('SelectDeck');

    assert(state.subject!.decks.contains(event.deck));

    emit(SubjectState(
      subject: state.subject,
      deck: event.deck,
      subjects: state.subjects,
      visualize: event.visualize,
    ));
  }

  _onDeleteDeck(DeleteDeck event, Emitter<SubjectState> emit) async {
    if (state.subject == null) {
      return;
    }

    debugPrint('DeleteDeck');

    Deck? deckToDelete = event.deck ?? state.deck;

    if (deckToDelete == null) {
      debugPrint('No deck to delete');
      return;
    }

    await LocalRepositoryService.removeDeck(deckToDelete, state.subject!);

    Subject subject = state.subject!
      ..decks.remove(deckToDelete);

    if (state.id != null && deckToDelete.id != null) {
      await firestoreService.deleteDeck(state.id!, deckToDelete.id!);
    } else {
      debugPrint(
          'Unable to delete deck from Firestore: Missing state.id or deck.id');
    }

    emit(SubjectState(
      subject: subject,
      subjects: state.subjects,
    ));
  }


  _onDeleteSubject(DeleteSubject event, Emitter<SubjectState> emit) async {
    debugPrint('DeleteSubject');

    await LocalRepositoryService.removeSubject(event.subject);

    List<Subject> subjects = state.subjects;

    for (int i = 0; i < subjects.length; i++) {
      if (subjects[i].id == event.subject.id) {
        subjects.removeAt(i);
      }
    }

    firestoreService.deleteSubject(event.subject.id);

    emit(SubjectState(
      subjects: subjects,
    ));
  }

  _onAddFlashCard(AddFlashcard event, Emitter<SubjectState> emit) async {
    if (state.deck == null) {
      return;
    }

    debugPrint('AddFlashcard');

    Flashcard flashcard = await LocalRepositoryService.addNewFlashcard(
      deck: state.deck!,
      question: event.question,
      answer: event.answer,
      index: event.index,
    );

    state.deck!.flashcards.add(flashcard);

    firestoreService.addFlashcard(flashcard, state.deck!.id);

    emit(SubjectState(
      subject: state.subject,
      deck: state.deck,
      subjects: state.subjects,
    ));
  }

  _onSaveFlashcard(SaveFlashcard event, Emitter<SubjectState> emit) async {
    if (state.deck == null) {
      return;
    }

    debugPrint('SaveFlashcard');

    Flashcard flashcard = await LocalRepositoryService.updateFlashcard(
      flashcard: event.flashcard,
      question: event.question,
      answer: event.answer,
      index: event.index,
    );

    for (int i = 0; i < state.deck!.flashcards.length; i++) {
      if (state.deck!.flashcards[i].id == flashcard.id) {
        state.deck!.flashcards[i] = flashcard;
      }
    }

    firestoreService.updateFlashcard(flashcard, state.deck!.id);

    event.completer?.complete();
  }

  _onLoadLocal(_LoadLocal event, Emitter<SubjectState> emit) async {
    debugPrint('_LoadLocal');

    List<Subject> subjects = await LocalRepositoryService.getSubjects();

    emit(SubjectState(
      subjects: subjects,
    ));
  }

  _onAddSubject(AddSubject event, Emitter<SubjectState> emit) async {
    debugPrint('AddSubject');

    Subject subject = await LocalRepositoryService.addNewSubject(
      user_id: event.user_id,
      name: event.name,
      icon: event.icon,
    );

    List<Subject> subjects = [...state.subjects, subject];

    String id = await firestoreService.addSubject(subject);
    subject = subject.copyWith(id: id); // Update with Firestore ID

    emit(SubjectState(
      deck: state.deck,
      subject: state.subject,
      subjects: subjects,
    ));
  }

  _onDeleteAllSubject(DeleteAllSubjects event, Emitter<SubjectState> emit) {
    LocalRepositoryService.clear();

    firestoreService.deleteAllSubjects();

    //delete pastErrorsObject in the subbject_block
    NewSavings.clearPastErrorsObjectList(globalUserId);
    //delete historyErrorList in the subbject_block


    emit(SubjectState(subjects: []));
  }

  _onReorderFlashcard(ReorderFlashcard event,
      Emitter<SubjectState> emit) async {
    if (state.deck == null || state.subject == null) {
      return;
    }

    if (event.newIndex == event.oldIndex) {
      return;
    }

    assert(
    state.deck!.flashcards.length >= max(event.newIndex, event.oldIndex));

    debugPrint('ReorderFlashcard');

    Deck deck = state.deck!;

    state.subject!.decks.remove(deck);
    List<Flashcard> flashcards = [...deck.flashcards];

    Flashcard flashcard = flashcards.removeAt(event.oldIndex);

    flashcards.insert(event.newIndex, flashcard);

    for (int i = min(event.newIndex, event.oldIndex);
    i <= max(event.newIndex, event.oldIndex);
    i++) {
      flashcards[i] = await LocalRepositoryService.updateFlashcard(
        flashcard: flashcards[i],
        index: i,
      );
    }

    deck = Deck(
      id: deck.id,
      name: deck.name,
      icon: deck.icon,
      flashcards: flashcards,
      subjectId: state.subject!.id,
    );

    state.subject!.decks.add(deck);

    emit(SubjectState(
      deck: deck,
      subject: state.subject,
      subjects: state.subjects,
    ));
  }

  _onDeleteFlashcard(DeleteFlashcard event, Emitter<SubjectState> emit) async {
    if (state.deck == null || state.subject == null) {
      return;
    }

    debugPrint('DeleteFlashcard');

    Deck deck = state.deck!;

    state.subject!.decks.remove(deck);
    List<Flashcard> flashcards = [...deck.flashcards];

    flashcards.removeAt(event.index);
    await LocalRepositoryService.removeFlashcard(
        deck.flashcards[event.index], deck);

    for (int i = event.index; i < flashcards.length; i++) {
      flashcards[i] = await LocalRepositoryService.updateFlashcard(
        flashcard: flashcards[i],
        index: i,
      );
    }

    deck = Deck(
      id: deck.id,
      name: deck.name,
      icon: deck.icon,
      flashcards: flashcards,
      subjectId: state.subject!.id,
    );

    state.subject!.decks.add(deck);

    firestoreService.deleteFlashcard(deck.id, deck.flashcards[event.index].id);

    emit(SubjectState(
      deck: deck,
      subject: state.subject,
      subjects: state.subjects,
    ));
  }

  void _onBackupData(BackupData event, Emitter<SubjectState> emit) async {
    try {
      // Generate a list of subjects, where each subject is a map that includes its decks and flashcards
      List<Map<String, dynamic>> subjectsJson = state.subjects.map((subject) {
        // For each subject, generate a list of its decks, where each deck is a map that includes its flashcards
        List<Map<String, dynamic>> decksJson = subject.decks.map((deck) {
          // For each deck, generate a list of its flashcards, where each flashcard is a map
          List<Map<String, dynamic>> flashcardsJson = deck.flashcards.map((
              flashcard) {
            return flashcard.toJson();
          }).toList();

          // Combine the deck's properties with its flashcards into a single map
          return {
            ...deck.toJson(),
            'flashcards': flashcardsJson,
          };
        }).toList();

        // Combine the subject's properties with its decks into a single map
        return {
          ...subject.toJson(),
          'decks': decksJson,
        };
      }).toList();

      // Convert the list of subjects to JSON
      String backupJson = jsonEncode(subjectsJson);

      // Save the JSON to Firestore
      //await firestoreService.backupData(event.userId, backupJson);
      print(backupJson);

      await firestoreService.backupData(event.userId, backupJson);

      //get the pastErrorsObject list
      List<PastErrorsObject> pastErrors = NewSavings.getPastErrorsObjectList(
          event.userId);

      print("error List backup");
      //print pastErrors list

      //backup chatgpt api_key
      String chatgpt_api_key = ApiService.getApiKey(event.userId);

      //backup api_key
      await firestoreService.backupApiKey(event.userId, chatgpt_api_key);

      print(pastErrors);

      await firestoreService.backupPastErrorsData(event.userId, pastErrors);

    } catch (e) {
      print("error backuping data");
      print(e);
    }
  }

  void _onRestoreData(RestoreData event, Emitter<SubjectState> emit) async {
    try {
      String backupJson = await firestoreService.restoreData(event.userId);

      // Parse the backupJson into a list of subjects
      List<dynamic> subjectsJson = jsonDecode(backupJson);
      List<Subject> subjects = subjectsJson.map((subjectJson) {
        // Parse the decks for each subject
        List<dynamic> decksJson = subjectJson['decks'];
        List<Deck> decks = decksJson.map((deckJson) {
          // Parse the flashcards for each deck
          List<dynamic> flashcardsJson = deckJson['flashcards'];
          List<Flashcard> flashcards = flashcardsJson.map((flashcardJson) =>
              Flashcard.fromJson(flashcardJson)).toList();

          // Return the deck with its flashcards
          return Deck(
            id: deckJson['id'],
            subjectId: deckJson['subjectId'],
            name: deckJson['name'],
            icon: IconData(
              deckJson['icon']['codePoint'],
              fontFamily: deckJson['icon']['fontFamily'],
              fontPackage: deckJson['icon']['fontPackage'],
              matchTextDirection: deckJson['icon']['matchTextDirection'],
            ),
            flashcards: flashcards,
          );
        }).toList();

        // Construct the subject with its decks
        return Subject(
          id: subjectJson['id'],
          user_id: subjectJson['user_id'],
          name: subjectJson['name'],
          icon: IconData(
            subjectJson['icon']['codePoint'],
            fontFamily: subjectJson['icon']['fontFamily'],
            fontPackage: subjectJson['icon']['fontPackage'],
            matchTextDirection: subjectJson['icon']['matchTextDirection'],
          ),
          decks: decks,
        );
      }).toList();


      // Clear the local data
      await LocalRepositoryService.clear();

      // Add the new subjects to the local data
      for (Subject subject in subjects) {
        await LocalRepositoryService.addSubject(subject);
      }

      NewSavings.clearPastErrorsObjectList(event.userId);

      //get the pastErrorsObject list
      List<PastErrorsObject> pastErrors = await firestoreService
          .restorePastErrorsData(event.userId);
      //
      print("error list download");
      // print(pastErrors);
      //
      // //restore pastErrorsObject in the subbject_block
      for (PastErrorsObject error in pastErrors) {
        NewSavings.addPastErrorsObject(error);
      }

      //restore chatgpt api_key
      String chatgpt_api_key = await firestoreService.restoreApiKey(
          event.userId);

      //restore api_key
      ApiService.setApiKey(globalUserId, chatgpt_api_key);


      emit(SubjectState(
        subjects: subjects,
        subject: state.subject,
        deck: state.deck,
      ));
    } catch (e) {
      emit(SubjectState(
        subjects: state.subjects,
        subject: state.subject,
        deck: state.deck,
      ));
    }
  }

  void _onPopulateDB(PopulateDB event, Emitter<SubjectState> emit) async {
    //populate the database with the data from firestore

  }
}
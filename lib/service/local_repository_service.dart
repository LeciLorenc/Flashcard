import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../calendar_and_recap/pastErrors/model/newObject.dart';
import '../calendar_and_recap/pastErrors/storage/NewSavings.dart';
import '../model/deck.dart';
import '../model/flashcard.dart';
import '../model/subject.dart';
import '../utils.dart';

class LocalRepositoryService {
  static const String _subjectsEntry = '__SUBJECTS__';
  static const String _errorsEntry = '__ERRORS__';
  static const String _historyEntry = '__HISTORY__';
  static final Future<SharedPreferences> _sharedPreferences = SharedPreferences.getInstance();

  static Future<void> clear() async {
    debugPrint('CLEARING MEMORY');
    (await _sharedPreferences).clear();
  }

  static Future<void> debug() async {
    debugPrint('DEBUG START');
    for (String key in (await _sharedPreferences).getKeys()) {
      debugPrint('$key - ${(await _sharedPreferences).get(key)}');
    }
    debugPrint('DEBUG END');
  }

  static Future<void> remove(String key) async {
    debugPrint('REMOVING $key');
    (await _sharedPreferences).remove(key);
  }

  static Future<List<String>?> getStringList(String key) async {
    debugPrint('GETTING STRING LIST $key');
    List<String>? stringList = (await _sharedPreferences).getStringList(key);
    debugPrint(stringList.toString());
    return stringList;
  }

  static Future<void> setStringList(String key, List<String> value) async {
    debugPrint('SETTING STRING LIST $key');
    debugPrint(value.toString());
    (await _sharedPreferences).setStringList(key, value);
  }

  static Future<String?> getString(String key) async {
    debugPrint('GETTING STRING $key');
    String? string = (await _sharedPreferences).getString(key);
    debugPrint(string);
    return string;
  }

  static Future<void> setString(String key, String value) async {
    debugPrint('SETTING STRING $key');
    debugPrint(value);
    (await _sharedPreferences).setString(key, value);
  }

  static Future<void> removeSubject(Subject subject) async {
    assert((await getStringList(_subjectsEntry) ?? []).contains(subject.id));
    for (Deck deck in subject.decks) {
      await removeDeck(deck, subject);
    }
    await remove('_${subject.id}');
    List<String> subjectIDs = await getStringList(_subjectsEntry) ?? [];
    assert(subjectIDs.contains(subject.id));
    subjectIDs.remove(subject.id);
    await setStringList(_subjectsEntry, subjectIDs);
    await remove(subject.id);
  }

  static Future<void> removeDeck(Deck deck, Subject subject) async {
    assert((await getStringList(_subjectsEntry) ?? []).contains(subject.id));
    for (Flashcard flashcard in deck.flashcards) {
      await removeFlashcard(flashcard, deck);
    }
    await remove('*${deck.id}');
    List<String> deckIDs = await getStringList('_${subject.id}') ?? [];
    assert(deckIDs.contains(deck.id));
    deckIDs.remove(deck.id);
    await setStringList('_${subject.id}', deckIDs);
    await remove(deck.id);
  }

  static Future<void> removeFlashcard(Flashcard flashcard, Deck deck) async {
    List<String> flashcardIDs = await getStringList('*${deck.id}') ?? [];
    assert(flashcardIDs.contains(flashcard.id));
    flashcardIDs.remove(flashcard.id);
    await setStringList('*${deck.id}', flashcardIDs);
    await remove(flashcard.id);
  }

  static Future<Subject> updateSubject({
    required Subject subject,
    String? user_id,
    String? name,
    IconData? icon,
  }) async {
    assert(name != null || icon != null);
    Subject updatedSubject = Subject(
      id: subject.id,
      user_id: subject.user_id,
      name: name ?? subject.name,
      icon: icon ?? subject.icon,
      decks: subject.decks,
    );
    await setString(subject.id, jsonEncode(updatedSubject.toJson()));
    return updatedSubject;
  }

  static Future<Deck> updateDeck({
    required Deck deck,
    String? name,
    IconData? icon,
  }) async {
    assert(name != null || icon != null);
    Deck updatedDeck = Deck(
      id: deck.id,
      name: name ?? deck.name,
      icon: icon ?? deck.icon,
      flashcards: deck.flashcards,
      subjectId: deck.subjectId,
    );
    await setString(updatedDeck.id, jsonEncode(updatedDeck.toJson()));
    return updatedDeck;
  }

  static Future<Flashcard> updateFlashcard({
    required Flashcard flashcard,
    String? question,
    String? answer,
    int? index,
  }) async {
    assert(question != null || answer != null || index != null);
    Flashcard updatedFlashcard = Flashcard(
      id: flashcard.id,
      question: question ?? flashcard.question,
      answer: answer ?? flashcard.answer,
      index: index ?? flashcard.index,
      deckId: flashcard.deckId,
    );
    await setString(updatedFlashcard.id, jsonEncode(updatedFlashcard.toJson()));
    return updatedFlashcard;
  }

  static Future<Subject> addNewSubject({
    required String user_id,
    required String name,
    required IconData icon,
  }) async {
    List<String>? subjectIDs = await getStringList(_subjectsEntry) ?? [];
    String id;
    do {
      id = generateRandomString();
    } while (subjectIDs.contains(id));
    subjectIDs.add(id);
    await setStringList(_subjectsEntry, subjectIDs);
    Subject subject = Subject(
      user_id: user_id,
      id: id,
      name: name,
      decks: [],
      icon: icon,
    );
    await setString(subject.id, jsonEncode(subject.toJson()));
    return subject;
  }

  static Future<Deck> addNewDeck({
    required String name,
    required IconData icon,
    required Subject subject,
  }) async {
    List<String>? subjectIDs = await getStringList(_subjectsEntry) ?? [];
    if (!subjectIDs.contains(subject.id)) {
      subjectIDs.add(subject.id);
      await setStringList(_subjectsEntry, subjectIDs);
    }
    assert(subjectIDs.contains(subject.id));

    List<String>? deckIDs = await getStringList('_${subject.id}') ?? [];
    String id;
    do {
      id = generateRandomString();
    } while (deckIDs.contains(id));
    deckIDs.add(id);
    await setStringList('_${subject.id}', deckIDs);

    Deck deck = Deck(
      id: id,
      name: name,
      icon: icon,
      flashcards: [],
      subjectId: subject.id,
    );
    await setString(deck.id, jsonEncode(deck.toJson()));
    return deck;
  }



  static Future<Flashcard> addNewFlashcard({
    required String question,
    required String answer,
    required int index,
    required Deck deck,
  }) async {
    List<String>? flashcardIDs = await getStringList('*${deck.id}') ?? [];
    String id;
    do {
      id = generateRandomString();
    } while (flashcardIDs.contains(id));
    flashcardIDs.add(id);
    await setStringList('*${deck.id}', flashcardIDs);
    Flashcard flashcard = Flashcard(
      id: id,
      question: question,
      answer: answer,
      index: index,
      deckId: deck.id,
    );
    await setString(flashcard.id, jsonEncode(flashcard.toJson()));
    return flashcard;
  }

  static Future<Subject?> getSubject(String id) async {
    String? json = await getString(id);
    if (json == null) {
      return null;
    }
    Subject subject = Subject.fromJson(jsonDecode(json));
    List<String> deckIDs = await getStringList('_$id') ?? [];
    for (String id in deckIDs) {
      Deck? deck = await getDeck(id);
      if (deck == null) {
        continue;
      }
      subject.decks.add(deck);
    }
    return subject;
  }

  static Future<Deck?> getDeck(String id) async {
    String? json = await getString(id);
    if (json == null) {
      return null;
    }
    Deck deck = Deck.fromJson(jsonDecode(json));
    List<String> flashcardIDs = await getStringList('*$id') ?? [];
    for (String id in flashcardIDs) {
      Flashcard? flashcard = await getFlashcard(id);
      if (flashcard == null) {
        continue;
      }
      deck.flashcards.add(flashcard);
    }
    return deck;
  }

  static Future<Flashcard?> getFlashcard(String id) async {
    String? json = await getString(id);
    if (json == null) {
      return null;
    }
    return Flashcard.fromJson(jsonDecode(json));
  }

  static Future<void> saveSubjects(List<Subject> subjects) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> subjectIds = subjects.map((subject) => subject.id).toList();
    await prefs.setStringList('__SUBJECTS__', subjectIds);
    for (Subject subject in subjects) {
      await prefs.setString(subject.id, subjectToJson(subject));
    }
  }

  static Future<List<Subject>> getSubjects() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> subjectIds = prefs.getStringList('__SUBJECTS__') ?? [];
    List<Subject> subjects = [];
    for (String subjectId in subjectIds) {
    String? subjectString = prefs.getString(subjectId);
    if (subjectString != null) {
    subjects.add(subjectFromJson(subjectString));
    }
    }
    return subjects;
  }

  static String subjectToJson(Subject subject) {
    return subject.toJson().toString();
  }

  static Subject subjectFromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    return Subject.fromJson(json);
  }

  static Future<void> addSubject(Subject subject) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> subjectIds = prefs.getStringList(_subjectsEntry) ?? [];
    if (!subjectIds.contains(subject.id)) {
      subjectIds.add(subject.id);
    }
    await prefs.setStringList(_subjectsEntry, subjectIds);
    await prefs.setString(subject.id, jsonEncode(subject.toJson()));
  }



  // Method to add a deck to a subject
  static Future<void> addDeck(Subject subject, Deck deck) async {
    subject.decks.add(deck);
  }

  // Method to add a flashcard to a deck
  static Future<void> addFlashcard(Deck deck, Flashcard flashcard) async {
    deck.flashcards.add(flashcard);
  }

  // static Future<void> addErrors(String userId, List<Map<String, dynamic>> errors) async {
  //   List<String> errorIds = await getStringList(_errorsEntry) ?? [];
  //
  //   for (var error in errors) {
  //     String id;
  //     do {
  //       id = generateRandomString();
  //     } while (errorIds.contains(id));
  //     errorIds.add(id);
  //     await setString(id, jsonEncode(error));
  //   }
  //
  //   await setStringList(_errorsEntry, errorIds);
  // }

  // static Future<void> addHistory(String userId, List<Map<String, dynamic>> history) async {
  //   List<String> historyIds = await getStringList(_historyEntry) ?? [];
  //
  //   for (var record in history) {
  //     String id;
  //     do {
  //       id = generateRandomString();
  //     } while (historyIds.contains(id));
  //     historyIds.add(id);
  //     await setString(id, jsonEncode(record));
  //   }
  //
  //   await setStringList(_historyEntry, historyIds);
  // }


  static Future<void> addBackupData(String backupJson) async {
    List<dynamic> subjectsJson = jsonDecode(backupJson);
    for (var subjectJson in subjectsJson) {
      Subject subject = Subject.fromJson(subjectJson);
      await addSubject(subject);

      for (var deckJson in subjectJson['decks']) {
        Deck deck = Deck.fromJson(deckJson);
        await addDeck(subject, deck);

        for (var flashcardJson in deckJson['flashcards']) {
          Flashcard flashcard = Flashcard.fromJson(flashcardJson);
          await addFlashcard(deck, flashcard);
        }
      }
    }
  }

  static Future<void> addErrors(List<dynamic> errorsJson) async {
    for (var errorJson in errorsJson) {
      NewSavings.addPastErrorsObject(PastErrorsObject.fromJson(errorJson));
    }
  }

  static Future<void> addHistory(List<dynamic> historyJson) async {
    for (var history in historyJson) {
      //NewSavings.addHistoryObject(historyErrorViewModel.fromJson(history));
    }
  }





}

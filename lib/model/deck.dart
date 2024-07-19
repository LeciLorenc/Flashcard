import 'package:flashcard/utils.dart';
import 'package:flutter/material.dart';

import '../exceptions/invalid_json.dart';
import 'flashcard.dart';

/// Model class for Deck
/// A deck is a collection of flashcards
/// It should contain all the flashcards for a particular topic of a subject
class Deck implements Comparable<Deck> {
  final String id;
  final String subjectId; // Add this field
  final String name;
  final IconData icon;
  late final List<Flashcard> flashcards;

  Deck({
    required this.id,
    required this.subjectId, // Initialize this field
    required this.name,
    required this.icon,
    required this.flashcards,
  });

  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck(
      id: json['id'],
      subjectId: json['subjectId'], // Parse this field
      name: json['name'],
      icon: IconData(
        json['icon']['codePoint'],
        fontFamily: json['icon']['fontFamily'],
        fontPackage: json['icon']['fontPackage'],
        matchTextDirection: json['icon']['matchTextDirection'],
      ),
      flashcards: (json['flashcards'] as List<dynamic>)
          .map((flashcardJson) => Flashcard.fromJson(flashcardJson as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjectId': subjectId, // Include this field
      'name': name,
      'icon': {
        'codePoint': icon.codePoint,
        'fontFamily': icon.fontFamily,
        'fontPackage': icon.fontPackage,
        'matchTextDirection': icon.matchTextDirection,
      },
      'flashcards': flashcards.map((flashcard) => flashcard.toJson()).toList(),
    };
  }

  @override
  int compareTo(Deck other) {
    return name.compareTo(other.name);
  }

  @override
  String toString() {
    return toJson().toString();
  }

  // set id of the deck to the id of the document in firestore
  Deck copyWith({String? id, String? name, List<Flashcard>? flashcards}) {
    return Deck(
      id: id ?? this.id,
      subjectId: subjectId,
      name: name ?? this.name,
      icon: icon,
      flashcards: flashcards ?? this.flashcards,
    );
  }

  Deck addFlashcards({required List<Flashcard> flashcards}) {
    return Deck(
      id: id,
      name: name,
      icon: icon,
      flashcards: flashcards, subjectId: '',
    );
  }
}

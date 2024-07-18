import 'package:flashcard/exceptions/invalid_json.dart';

/// Model class for Flashcard
/// A flashcard is a question and answer pair
class Flashcard implements Comparable<Flashcard>{
  final String id;
  final String deckId; // Add this field
  final String question;
  final String answer;
  final int index;

  Flashcard({
    required this.id,
    required this.deckId, // Initialize this field
    required this.question,
    required this.answer,
    required this.index,
  });

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'],
      deckId: json['deckId'], // Parse this field
      question: json['question'],
      answer: json['answer'],
      index: json['index'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deckId': deckId, // Include this field
      'question': question,
      'answer': answer,
      'index': index,
    };
  }



  Map<String, dynamic> toJsonIdFriendly() {
    return toJson();
  }

  @override
  int compareTo(Flashcard other) {
    return index.compareTo(other.index);
  }

  @override
  String toString() {
    return toJson().toString();
  }

  //copyWith method
  Flashcard copyWith({
    String? id,
    String? question,
    String? answer,
    int? index,
  }) {
    return Flashcard(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      index: index ?? this.index, deckId: '',
    );
  }
}

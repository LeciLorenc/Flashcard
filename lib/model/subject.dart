import 'package:flutter/material.dart';

import '../exceptions/invalid_json.dart';
import '../utils.dart';
import 'deck.dart';

class Subject implements Comparable<Subject> {
  late final String id;
  final String user_id;
  final String name;
  final List<Deck> decks;
  final IconData icon;

  Subject({
    required this.id,
    required this.user_id,
    required this.name,
    required this.decks,
    required this.icon,
  });

  static Subject fromJson(Map<String, dynamic> json) {
    if (json['user_id'] == null ||
        json['user_id'] is! String ||
        json['name'] == null ||
        json['name'] is! String ||
        json['decks'] == null ||
        json['decks'] is! List ||
        json['icon'] == null ||
        json['icon'] is! Map<String, dynamic>) {
      throw InvalidJson(
          json,
          'Subject:{'
          ' "id": String?,'
          ' "user_id": String?,'
          ' "name": String,'
          ' "decks": List<Deck>,'
          ' "icon": IconData'
          '}');
    }
    final List<Deck> decks = [];
    for (final deck in json['decks']) {
      final Deck deckObj = Deck.fromJson(deck);
      decks.add(deckObj);
    }
    return Subject(
      id: json['id'],
      user_id: json['user_id'],
      name: json['name'],
      decks: decks,
      icon: iconDataFromJson(
        json['icon'],
      ),
    );
  }

  static Subject fromJsonIdFriendly(Map<String, dynamic> json) {
    json['decks'] = [];

    return fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = user_id;
    data['decks'] = decks.map((deck) => deck.toJson()).toList();
    data['name'] = name;
    data['icon'] = iconDataToJson(icon);
    data['id'] = id;
    return data;
  }

  Map<String, dynamic> toJsonIdFriendly() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = user_id;
    data['id'] = id;
    data['name'] = name;
    data['icon'] = iconDataToJson(icon);
    return data;
  }
  //set the id of the subject to the id of the document in firestore
Subject copyWith({String? id}) {
    return Subject(
      id: id ?? this.id,
      user_id: user_id,
      name: name,
      decks: decks,
      icon: icon,
    );
  }

  @override
  int compareTo(Subject other) {
    return name.compareTo(other.name);
  }

  @override
  String toString() {
    return toJson().toString();
  }

}

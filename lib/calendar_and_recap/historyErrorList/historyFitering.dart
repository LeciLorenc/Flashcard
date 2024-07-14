import 'package:flashcard/bloc/subject_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';


List<DropdownMenuItem<String>> computeItemsForSubject(BuildContext context) {
  // Filtra i soggetti in base a user_id
  final subjects = context.read<SubjectBloc>().state.subjects.where((subject) {
    return subject.user_id == globalUserId;
  }).toList();

  // Crea le voci del menu a discesa per i soggetti filtrati
  return subjects.map((subject) {
    return DropdownMenuItem<String>(
      value: subject.name,
      child: Text(subject.name),
    );
  }).toList();
}

List<DropdownMenuItem<String>> computeItemsForDeck(BuildContext context) {
  Set<String> deckNames = {};

  // Filtra i soggetti in base a user_id
  final subjects = context.read<SubjectBloc>().state.subjects.where((subject) {
    return subject.user_id == globalUserId;
  }).toList();

  // Itera sui soggetti filtrati per raccogliere i nomi dei deck
  subjects.forEach((subject) {
    subject.decks.forEach((deck) {
      deckNames.add(deck.name);
    });
  });

  // Crea le voci del menu a discesa per i nomi dei deck
  return deckNames.map((deckName) {
    return DropdownMenuItem<String>(
      value: deckName,
      child: Text(deckName),
    );
  }).toList();
}

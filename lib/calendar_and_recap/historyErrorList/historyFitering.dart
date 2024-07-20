import 'package:flashcard/bloc/subject_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';
import '../pastErrors/storage/NewSavings.dart';

List<DropdownMenuItem<String>> computeItemsForSubject(BuildContext context) {
  // Filtra i soggetti in base a user_id
  final subjects = NewSavings.savings.where((savingsObject) {
    return savingsObject.user_id == globalUserId;
  }).map((savingsObject) => savingsObject.subject).toSet().toList();

  // Crea le voci del menu a discesa per i soggetti filtrati
  return subjects.map((subject) {
    return DropdownMenuItem<String>(
      value: subject,
      child: Text(subject),
    );
  }).toList();
}
List<DropdownMenuItem<String>> computeItemsForDeck(BuildContext context) {
  Set<String> deckNames = {};

  // Filtra i soggetti in base a user_id
  final savings = NewSavings.savings.where((savingsObject) {
    return savingsObject.user_id == globalUserId;
  }).toList();

  // Itera sui soggetti filtrati per raccogliere i nomi dei deck
  savings.forEach((savingsObject) {
    deckNames.add(savingsObject.deck);
  });

  // Crea le voci del menu a discesa per i nomi dei deck
  return deckNames.map((deckName) {
    return DropdownMenuItem<String>(
      value: deckName,
      child: Text(deckName),
    );
  }).toList();
}

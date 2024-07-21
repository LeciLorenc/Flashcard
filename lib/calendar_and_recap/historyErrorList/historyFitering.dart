import 'package:flutter/material.dart';
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
      value: subject.length>10 ? "${subject.substring(0,7)}...": subject,
      child: Text(subject.length>10 ? "${subject.substring(0,7)}...": subject,),
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
      value: deckName.length>10 ? "${deckName.substring(0,7)}...": deckName,
      child: Text(deckName.length>10 ? "${deckName.substring(0,7)}...": deckName,),
    );
  }).toList();
}

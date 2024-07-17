import 'package:flashcard/calendar_and_recap/pastErrors/model/newObject.dart';
import 'package:flutter/material.dart';

import '../pastErrors/storage/utilitiesStorage.dart';

class HistoryErrorViewModel extends ChangeNotifier {

  String deckFilter='';
  String subjectFilter='';
  String dateFilter='';

  String orderingVariable=OrderingEnum.dateDecrease.toString();

  void updateDeckFilter(String deck) {
    deckFilter=deck;
    notifyListeners();
  }
  void updateSubjectFilter(String subject) {
    subjectFilter=subject;
    notifyListeners();
  }
  void updateDateFilter(String date) {
    dateFilter=date;
    notifyListeners();
  }

  void updateOrdering(String ordering)
  {
    List<String> values = OrderingEnum.values.map((e) => e.name).toList();

    for(String v in values)
    {
      String adapted = "OrderingEnum.$v";
      if(ordering==adapted) {
        orderingVariable = adapted;
        notifyListeners();
        break;
      }
    }
  }

  void removeAllFilters() {
    dateFilter='';
    deckFilter='';
    subjectFilter='';
    notifyListeners();
  }

  // Define method to get filtered savings based on filters
  List<pastErrorsObject> getFilteredSavings(List<pastErrorsObject> allSavings)
  {
    List<pastErrorsObject> listFiltered = List<pastErrorsObject>.from(allSavings);

    for(var item in allSavings){

      if(deckFilter!='') {
        if (item.deck != deckFilter) {
          listFiltered.remove(item);
        }
      }
      if(subjectFilter!='') {
        if (item.subject != subjectFilter) {
          listFiltered.remove(item);
        }
      }
      if(dateFilter!='') {
        String finalDate = UtilitiesStorage.getOnlyDateFromStringDate(item.date);

        if (finalDate != dateFilter) {
          listFiltered.remove(item);
        }
      }

    }
        return listFiltered;
  }



  List<pastErrorsObject>  getOrderedSavings(List<pastErrorsObject> allSavings)
  {
    List<pastErrorsObject> listOrdered = List<pastErrorsObject>.from(allSavings);
    switch (orderingVariable) {
      case "OrderingEnum.subjectNameAZ":
        listOrdered.sort((a, b) => b.subject.compareTo(a.subject));
        break;
      case "OrderingEnum.subjectNameZA":
        listOrdered.sort((a, b) => a.subject.compareTo(b.subject));
        break;
      case "OrderingEnum.deckNameAZ":
        listOrdered.sort((a, b) => b.deck.compareTo(a.deck));
        break;
      case "OrderingEnum.deckNameZA":
        listOrdered.sort((a, b) => a.deck.compareTo(b.deck));
        break;
      case "OrderingEnum.dateIncrease":
        listOrdered.sort((a, b) => '${b.date} ${b.time}'.compareTo('${a.date} ${a.time}'));
        break;
      case "OrderingEnum.dateDecrease":
        listOrdered.sort((a, b) => '${a.date} ${a.time}'.compareTo('${b.date} ${b.time}'));
        break;
      default:
        print("Unknown ordering");
        break;
    }
      return listOrdered;
  }



}


enum OrderingEnum{
  subjectNameAZ,
  subjectNameZA,
  deckNameAZ,
  deckNameZA,
  dateIncrease,
  dateDecrease
}
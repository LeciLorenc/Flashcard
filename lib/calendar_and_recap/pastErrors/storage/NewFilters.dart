import 'package:flashcard/calendar_and_recap/pastErrors/model/newObject.dart';
import 'package:flashcard/calendar_and_recap/pastErrors/storage/NewSavings.dart';
import 'package:flashcard/calendar_and_recap/pastErrors/storage/utilitiesStorage.dart';


class NewFiltersStorage{

  static NewObject? getASpecificSaving(String date, String time) {
    NewObject? itemsWithDate;

    for (var item in NewSavings.savings) {
      if (item.date == date && item.time == time) {
        itemsWithDate = item;
        break;
      }
    }
    return itemsWithDate;
  }




  static List<NewObject> getSavingsFilteredByDate(String date) {
    List<NewObject> itemsWithDate=[];

    for (var item in NewSavings.savings) {
      if (item.date == date) {
        itemsWithDate.add(item);
      }
    }

    return itemsWithDate;
  }


  static NewObject? getSavingsFilteredByDateSubjectDeck(String date, String time, String subject, String deck) {
    NewObject? itemsWithDate;

    for (var item in NewSavings.savings) {
      if (item.date == date && item.deck == deck && item.subject == subject && item.time == time) {
        itemsWithDate = item;
        break;
      }
    }

    return itemsWithDate;
  }


  static NewObject? getSavingsFilteredByMonthAndYear(int month, int year) {
    NewObject? itemsWithMonthAndYear;

    for (var item in NewSavings.savings) {
      DateTime itemDate = DateTime.parse(item.date);
      if (itemDate.month == month && itemDate.year == year) {
        itemsWithMonthAndYear = item;
        break;
      }
    }

    return itemsWithMonthAndYear;
  }

  static List<NewObject> calculatePlayedListWithOnlyDate(DateTime selectedDate)
  {
    return NewFiltersStorage.
    getSavingsFilteredByDate(UtilitiesStorage.getOnlyDateFromSelectedDate(selectedDate));
  }
}
import 'package:flashcard/calendar_and_recap/pastErrors/model/newObject.dart';
import 'package:flashcard/calendar_and_recap/pastErrors/storage/NewSavings.dart';
import 'package:flashcard/calendar_and_recap/pastErrors/storage/utilitiesStorage.dart';


class NewFiltersStorage{

  static pastErrorsObject? getASpecificSaving(String date, String time , List<pastErrorsObject> list) {
    pastErrorsObject? itemsWithDate;

    for (var item in list) {
      if (item.date == date && item.time == time) {
        itemsWithDate = item;
        break;
      }
    }
    return itemsWithDate;
  }




  static List<pastErrorsObject> filterByUser(String user_id, List<pastErrorsObject> list)
  {
    List<pastErrorsObject> itemsByUser=[];

    for (var item in list) {
      if (item.user_id == user_id) {
        itemsByUser.add(item);
      }
    }

    return itemsByUser;
  }



  static List<pastErrorsObject> getSavingsFilteredByDate(String date, List<pastErrorsObject> list) {
    List<pastErrorsObject> itemsWithDate=[];

    for (var item in list) {
      if (item.date == date) {
        itemsWithDate.add(item);
      }
    }

    return itemsWithDate;
  }


  static pastErrorsObject? getSavingsFilteredByDateSubjectDeck(String date, String time, String subject, String deck,  List<pastErrorsObject> list) {
    pastErrorsObject? itemsWithDate;

    for (var item in list) {
      if (item.date == date && item.deck == deck && item.subject == subject && item.time == time) {
        itemsWithDate = item;
        break;
      }
    }

    return itemsWithDate;
  }


  static pastErrorsObject? getSavingsFilteredByMonthAndYear(int month, int year,  List<pastErrorsObject> list) {
    pastErrorsObject? itemsWithMonthAndYear;

    for (var item in list) {
      DateTime itemDate = DateTime.parse(item.date);
      if (itemDate.month == month && itemDate.year == year) {
        itemsWithMonthAndYear = item;
        break;
      }
    }

    return itemsWithMonthAndYear;
  }

  static List<pastErrorsObject> calculatePlayedListWithOnlyDate(DateTime selectedDate, List<pastErrorsObject>  list)
  {
    return NewFiltersStorage.
    getSavingsFilteredByDate(UtilitiesStorage.getOnlyDateFromSelectedDate(selectedDate), list );
  }
}
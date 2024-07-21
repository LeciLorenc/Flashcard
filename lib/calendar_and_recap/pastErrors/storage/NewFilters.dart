import 'package:flashcard/calendar_and_recap/pastErrors/model/newObject.dart';
import 'package:flashcard/calendar_and_recap/pastErrors/storage/NewSavings.dart';
import 'package:flashcard/calendar_and_recap/pastErrors/storage/utilitiesStorage.dart';


class NewFiltersStorage{

  static PastErrorsObject? getASpecificSaving(String date, String time , List<PastErrorsObject> list) {
    PastErrorsObject? itemsWithDate;

    for (var item in list) {
      if (item.date == date && item.time == time) {
        itemsWithDate = item;
        break;
      }
    }
    return itemsWithDate;
  }




  static List<PastErrorsObject> filterByUser(String user_id, List<PastErrorsObject> list)
  {
    List<PastErrorsObject> itemsByUser=[];

    for (var item in list) {
      if (item.user_id == user_id) {
        itemsByUser.add(item);
      }
    }

    return itemsByUser;
  }



  static List<PastErrorsObject> getSavingsFilteredByDate(String date, List<PastErrorsObject> list) {
    List<PastErrorsObject> itemsWithDate=[];

    for (var item in list) {
      if (item.date == date) {
        itemsWithDate.add(item);
      }
    }

    return itemsWithDate;
  }


  static PastErrorsObject? getSavingsFilteredByDateSubjectDeck(String date, String time, String subject, String deck,  List<PastErrorsObject> list) {
    PastErrorsObject? itemsWithDate;

    for (var item in list) {
      if (item.date == date && item.deck == deck && item.subject == subject && item.time == time) {
        itemsWithDate = item;
        break;
      }
    }

    return itemsWithDate;
  }


  static PastErrorsObject? getSavingsFilteredByMonthAndYear(int month, int year,  List<PastErrorsObject> list) {
    PastErrorsObject? itemsWithMonthAndYear;

    for (var item in list) {
      DateTime itemDate = DateTime.parse(item.date);
      if (itemDate.month == month && itemDate.year == year) {
        itemsWithMonthAndYear = item;
        break;
      }
    }

    return itemsWithMonthAndYear;
  }

  static List<PastErrorsObject> calculatePlayedListWithOnlyDate(DateTime selectedDate, List<PastErrorsObject>  list)
  {
    return NewFiltersStorage.
    getSavingsFilteredByDate(UtilitiesStorage.getOnlyDateFromSelectedDate(selectedDate), list );
  }
}
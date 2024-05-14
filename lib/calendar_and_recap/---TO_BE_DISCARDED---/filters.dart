/*
import 'package:flashcard/calendar_and_recap/---TO_BE_DISCARDED---/storageData.dart';
import 'incorrectItem.dart';
import 'playedItems.dart';

class FiltersStorage{
  //TO BE RESOLVED


  static List<PlayedDeck> getPlayedItemsFilteredByDate(String date) {
    List<PlayedDeck> itemsWithDate = [];

    for (var item in StorageData.playedList) {
      if (item.date == date) {
        itemsWithDate.add(item);
      }
    }

    return itemsWithDate;
  }
  static List<IncorrectItem> getErrorItemsFilteredByDateSubjectDeck(String date, String time, String subject, String deck) {
    List<IncorrectItem> itemsWithDate = [];

    for (var item in StorageData.errorList) {
      if (item.date == date && item.deck == deck && item.subject == subject && item.time == time) {
        itemsWithDate.add(item);
      }
    }

    return itemsWithDate;
  }





  //OK

  static List<IncorrectItem> getErrorsFilteredByDateAndTime(String date, String time) {
    List<IncorrectItem> itemsWithDate = [];

    for (var item in StorageData.errorList) {
      if (item.date == date && item.time == time) {
        itemsWithDate.add(item);
      }
    }

    return itemsWithDate;
  }

  static List<IncorrectItem> getErrorItemsFilteredByDate(String date) {
    List<IncorrectItem> itemsWithDate = [];

    for (var item in StorageData.errorList) {
      if (item.date == date) {
        itemsWithDate.add(item);
      }
    }

    return itemsWithDate;
  }



  static List<PlayedDeck> getPlayedItemsFilteredByDateSubjectDeck(String date, String subject, String deck) {
    List<PlayedDeck> itemsWithDate = [];

    for (var item in StorageData.playedList) {
      if (item.date == date && item.deck == deck && item.subject == subject) {
        itemsWithDate.add(item);
      }
    }

    return itemsWithDate;
  }



  static List<IncorrectItem> getErrorItemsFilteredByMonthAndYear(int month, int year) {
    List<IncorrectItem> itemsWithMonthAndYear = [];

    for (var item in StorageData.errorList) {
      DateTime itemDate = DateTime.parse(item.date);
      if (itemDate.month == month && itemDate.year == year) {
        itemsWithMonthAndYear.add(item);
      }
    }

    return itemsWithMonthAndYear;
  }
  static List<PlayedDeck> getPlayedItemsFilteredByMonthAndYear(int month, int year) {
    List<PlayedDeck> itemsWithMonthAndYear = [];

    for (var item in StorageData.playedList) {
      DateTime itemDate = DateTime.parse(item.date);
      if (itemDate.month == month && itemDate.year == year) {
        itemsWithMonthAndYear.add(item);
      }
    }

    return itemsWithMonthAndYear;
  }


  static String getDayFromDate(String date)
  {
    DateTime itemDate = DateTime.parse(date);
    return itemDate.day.toString();
  }
  static String getMonthFromDate(String date)
  {
    DateTime itemDate = DateTime.parse(date);
    return itemDate.month.toString();
  }
  static String getYearFromDate(String date)
  {
    DateTime itemDate = DateTime.parse(date);
    return itemDate.year.toString();
  }


}

 */
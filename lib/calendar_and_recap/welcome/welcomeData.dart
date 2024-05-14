import 'package:flashcard/calendar_and_recap/playErrors/model/newObject.dart';
import 'package:flashcard/calendar_and_recap/playErrors/storage/utilitiesStorage.dart';
import 'package:intl/intl.dart';

import '../playErrors/storage/NewFilters.dart';

class WelcomeData
{
  static List<int> computeCorrectPoints(DateTime selectedDate) {

    int dayInTheMonth =
    retrieveNumberOfDaysInAMonth(
        int.parse(UtilitiesStorage.getMonthFromDate(selectedDate.toString())),
        int.parse(UtilitiesStorage.getYearFromDate(selectedDate.toString())));

    int playedInADay = 0;
    List<int> array = List<int>.filled(dayInTheMonth, 0);

    for(int i=0;i<dayInTheMonth;i++)
    {
      playedInADay = 0;
      String dateIteration= constructDate(selectedDate.toString(), i+1);
      List<NewObject> listOfPlayedInTheDay = NewFiltersStorage.getSavingsFilteredByDate(dateIteration);

      for(int j=0;j<listOfPlayedInTheDay.length;j++)
      {
        int wrong = listOfPlayedInTheDay[j].wrongAnswers.length;
        int total = int.parse(listOfPlayedInTheDay[j].numberOfTotalFlashcards);
        playedInADay += total-wrong;
      }

      array[i]=playedInADay;
    }

    //return array;
    return [1,2,1,1,2,1,1,1,1,1,1,1,1,1,1,1,2,1,1,2,1,1,1,1,1,1,1,1,1,1];
  }

  static List<String> computeLabels(DateTime selectedDate)
  {
    List<String> listOfLabels=[];
    for(int i=0;i<retrieveNumberOfDaysInAMonth(selectedDate.month, selectedDate.year);i++)
    {
      int tempLabel= i+1;
      listOfLabels.add("$tempLabel");
    }
    return listOfLabels;
  }

  static List<int> computeTotalPoints(DateTime selectedDate)
  {

    int dayInTheMonth =
    retrieveNumberOfDaysInAMonth(
        int.parse(UtilitiesStorage.getMonthFromDate(selectedDate.toString())),
        int.parse(UtilitiesStorage.getYearFromDate(selectedDate.toString())));

    int playedInADay = 0;
    List<int> array = List<int>.filled(dayInTheMonth, 0);

    for(int i=0;i<dayInTheMonth;i++)
    {
      playedInADay = 0;
      String dateIteration= constructDate(selectedDate.toString(), i+1);
      List<NewObject> listOfPlayedInTheDay = NewFiltersStorage.getSavingsFilteredByDate(dateIteration);

      for(int j=0;j<listOfPlayedInTheDay.length;j++)
      {
        playedInADay += int.parse(listOfPlayedInTheDay[j].numberOfTotalFlashcards);
      }

      array[i]=playedInADay;
    }

    //return array;
    return [2,3,4,1,5,2,2,2,2,2,3,3,3,3,3,8,8,8,8,8,2,2,2,2,2,3,3,3,3,3];
  }



  static String constructDate(String date, int i) {

    DateTime currentDate = DateTime.parse(date);
    DateTime newDate = DateTime(currentDate.year, currentDate.month, i);
    String formattedDate = DateFormat('yyyy-MM-dd').format(newDate);

    return formattedDate;
  }

  static int retrieveNumberOfDaysInAMonth(int month, int year) {

    DateTime firstDayOfNextMonth = DateTime(year, month + 1, 1);

    // Subtract one day from the first day of the next month to get the last day of the current month
    DateTime lastDayOfCurrentMonth = firstDayOfNextMonth.subtract(Duration(days: 1));
    int numberOfDaysInMonth = lastDayOfCurrentMonth.day;
    return numberOfDaysInMonth;
  }
}
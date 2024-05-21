import 'package:intl/intl.dart';

class UtilitiesStorage
{

  static String getOnlyDateFromSelectedDate(DateTime selectedDate)
  {
    return DateFormat('yyyy-MM-dd').format(selectedDate).toString();
  }
  static String getOnlyTimeFromSelectedDate(DateTime selectedDate) {
    return DateFormat('HH:mm:ss').format(selectedDate);
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

  static String getOnlyDateFromStringDate(String date)
  {
    String year = UtilitiesStorage.getYearFromDate(date);
    String month = UtilitiesStorage.getMonthFromDate(date);
    String day = UtilitiesStorage.getDayFromDate(date);
    String finalDate = "";

    if(int.parse(month)<10) {
      finalDate = "$year-0$month-$day";
    } else {
      finalDate = "$year-$month-$day";
    }

    return finalDate;
  }






  /*
  static List<PlayedDeck> calculatePlayedListWithOnlyDate(DateTime selectedDate)
  {
    return  FiltersStorage.
    getPlayedItemsFilteredByDate(getOnlyDateFromSelectedDate(selectedDate));
  }
 */


  /*
  static List<IncorrectItem> calculateNumberOfErrors(String time, DateTime selectedDate, String subject, String deck)
  {
    return NewFiltersStorage().getSavingsFilteredByDateSubjectDeck(getOnlyDateFromSelectedDate(selectedDate), time,subject, deck);
  }
*/
}
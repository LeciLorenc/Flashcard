import 'package:flashcard/calendar_and_recap/playErrors/model/newObject.dart';
import 'package:flashcard/calendar_and_recap/playErrors/storage/NewFilters.dart';
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

  
  /*
  static List<PlayedDeck> calculatePlayedListWithOnlyDate(DateTime selectedDate)
  {
    return  FiltersStorage.
    getPlayedItemsFilteredByDate(getOnlyDateFromSelectedDate(selectedDate));
  }
 */
  static List<NewObject> calculatePlayedListWithOnlyDate(DateTime selectedDate)
  {
    return NewFiltersStorage.
    getSavingsFilteredByDate(getOnlyDateFromSelectedDate(selectedDate));
  }

  /*
  static List<IncorrectItem> calculateNumberOfErrors(String time, DateTime selectedDate, String subject, String deck)
  {
    return NewFiltersStorage().getSavingsFilteredByDateSubjectDeck(getOnlyDateFromSelectedDate(selectedDate), time,subject, deck);
  }
*/
}
import 'package:flashcard/calendar_and_recap/---TO_BE_DISCARDED---/incorrectItem.dart';
import 'package:flashcard/calendar_and_recap/---TO_BE_DISCARDED---/playedItems.dart';
import 'package:flashcard/calendar_and_recap/---TO_BE_DISCARDED---/filters.dart';
//import 'package:flashcard/calendar_and_recap/playErrors/storage/storageData.dart';
import 'package:flashcard/calendar_and_recap/pastErrors/storage/utilitiesStorage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
/*
  test('testOfMonthAndYearFilter_forError', () {
    void testOfMonthAndYearFilter_forError() {
      WidgetsFlutterBinding.ensureInitialized();


      DateTime dateTime = DateTime.now();
      String onlyDate = UtilitiesStorage.getOnlyDateFromSelectedDate(dateTime);
      String onlyTime = UtilitiesStorage.getOnlyTimeFromSelectedDate(dateTime);

      StorageData.errorList.clear();
      expect(0, StorageData.errorList.length);
      StorageData.addToErrorList(IncorrectItem(subject: "subject",
          deck: "deck",
          question: "question",
          answer: "answer",
          date: onlyDate,
          time: onlyTime));
      expect(1, StorageData.errorList.length);
      StorageData.addToErrorList(IncorrectItem(subject: "subject2",
          deck: "deck2",
          question: "question2",
          answer: "answer2",
          date: "2024-04-12",
          time: onlyTime));
      expect(2, StorageData.errorList.length);

      List<IncorrectItem> errorsOfApril = FiltersStorage
          .getErrorItemsFilteredByMonthAndYear(4, 2024);
      List<IncorrectItem> errorsOfNovember = FiltersStorage
          .getErrorItemsFilteredByMonthAndYear(11, 2024);
      expect(2, errorsOfApril.length);
      expect(0, errorsOfNovember.length);
    }
    testOfMonthAndYearFilter_forError();
  });




  test('testOfMonthAndYearFilter_forPlayed', ()
  {
    void testOfMonthAndYearFilter_forPlayed()
    {
      WidgetsFlutterBinding.ensureInitialized();


      DateTime dateTime= DateTime.now();
      String onlyDate = UtilitiesStorage.getOnlyDateFromSelectedDate(dateTime);
      String onlyTime = UtilitiesStorage.getOnlyTimeFromSelectedDate(dateTime);

      StorageData.playedList.clear();
      expect(0, StorageData.playedList.length);
      StorageData.addToPlayedList(PlayedDeck(subject: "subject", deck: "deck", date: onlyDate, time: onlyTime, length: "2"));
      expect(1, StorageData.playedList.length);
      StorageData.addToPlayedList(PlayedDeck(subject: "subject2", deck: "deck2", date: "2024-04-12", time: onlyTime, length: "4"));
      expect(2, StorageData.playedList.length);

      List<PlayedDeck> errorsOfApril = FiltersStorage.getPlayedItemsFilteredByMonthAndYear(4, 2024);
      List<PlayedDeck> errorsOfNovember = FiltersStorage.getPlayedItemsFilteredByMonthAndYear(11, 2024);
      expect(2, errorsOfApril.length);
      expect(0, errorsOfNovember.length);
    }
    testOfMonthAndYearFilter_forPlayed();
    });*/
}
/*

import 'dart:convert';
import 'package:flashcard/bloc/play_bloc.dart';
import 'package:flashcard/model/flashcard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../---TO_BE_DISCARDED---/incorrectItem.dart';
import '../../---TO_BE_DISCARDED---/playedItems.dart';

class StorageData {
  static List<IncorrectItem> errorList=[];
  static List<PlayedDeck> playedList = [];


  static void addToErrorList(IncorrectItem incorrectItem)
  {
      if( ! isContainedInErrorList(incorrectItem)) {
      errorList.add(incorrectItem);
      saveErrorList().then((_){});
    }
  }
  static void addToPlayedList(PlayedDeck playedDeck)
  {
    if( ! isContainedInPlayedList(playedDeck)) {
      playedList.add(playedDeck);
      saveErrorList().then((_){});
    }
  }



  static bool isContainedInPlayedList(PlayedDeck playedDeck)
  {
    if(playedList.isEmpty) {
      return false;
    }
    for(int i=0;i<playedList.length;i++)
    {
      PlayedDeck inTheList = playedList[i];
      if(inTheList.deck == playedDeck.deck &&
          inTheList.subject == playedDeck.subject &&
          inTheList.date == playedDeck.date &&
          inTheList.time == playedDeck.time
      )
      {
        return true;
      }
    }
    return false;
  }
  static bool isContainedInErrorList(IncorrectItem incorrectItem)
  {
    if(errorList.isEmpty) {
      return false;
    }
    for(int i=0;i<errorList.length;i++)
    {
      IncorrectItem inTheList = errorList[i];
      if(inTheList.deck == incorrectItem.deck &&
          inTheList.subject == incorrectItem.subject &&
          inTheList.question == incorrectItem.question &&
          inTheList.answer == incorrectItem.answer &&
          inTheList.date == incorrectItem.date &&
          inTheList.time == incorrectItem.time
        )
      {
        return true;
      }
    }
    return false;
  }





  static IncorrectItem createIncorrectItem(PlayBloc context, Flashcard incorrectFlashcard, String date, String time)
  {
    String subject = context.subject.name;
    String deck = context.deck.name;
    String question = incorrectFlashcard.question;
    String answer = incorrectFlashcard.answer;
    return IncorrectItem(subject: subject, deck: deck, question: question, answer: answer, date: date, time: time);
  }
  static PlayedDeck createPlayedDeck(PlayBloc context,String date, String time)
  {
    String subject = context.subject.name;
    String deck = context.deck.name;
    String length = context.deck.flashcards.length.toString();
    return PlayedDeck(subject: subject, deck: deck, date: date, time: time, length: length);
  }




  static Future<void> saveErrorList() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonList = errorList.map((item) => item.toJson()).toList();

    final errorListJson = jsonEncode(jsonList);

    prefs.setString('errorList', errorListJson);
  }
  static Future<void> savePlayedList() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonList = playedList.map((item) => item.toJson()).toList();

    final playedListJson = jsonEncode(jsonList);

    prefs.setString('playedList', playedListJson);
  }





  static Future<void> loadErrorList() async {
    final prefs = await SharedPreferences.getInstance();
    final errorListJson = prefs.getString('errorList');
    if (errorListJson != null) {

      List<dynamic> jsonList = jsonDecode(errorListJson);
      List<IncorrectItem> loadedErrorList =   jsonList.map((itemJson) => IncorrectItem.fromJson(itemJson)).toList();
      errorList = loadedErrorList;
    } else {
      errorList = [];
    }
  }
  static Future<void> loadPlayedList() async {
    final prefs = await SharedPreferences.getInstance();
    final playedListJson = prefs.getString('playedList');
    if (playedListJson != null) {

      List<dynamic> jsonList = jsonDecode(playedListJson);
      List<PlayedDeck> loadedPlayedList =   jsonList.map((itemJson) => PlayedDeck.fromJson(itemJson)).toList();
      playedList = loadedPlayedList;
    } else {
      playedList = [];
    }
  }


  static Future<void> deleteAll() async
  {
    errorList.clear();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('errorList', "");
  }

}


*/

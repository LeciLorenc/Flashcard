import 'dart:convert';
import 'package:flashcard/bloc/play_bloc.dart';
import 'package:flashcard/calendar_and_recap/playErrors/model/newObject.dart';
import 'package:flashcard/model/flashcard.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NewSavings {

  static List<NewObject> savings = [];


  static void addToNewSavings(NewObject playedDeck)
  {
    if( ! isContainedInTheSavings(playedDeck)) {
      savings.add(playedDeck);
      saveNewObject().then((_){});
    }
  }



  static bool isContainedInTheSavings(NewObject newObject)
  {
    if(savings.isEmpty) {
      return false;
    }
    for(int i=0;i<savings.length;i++)
    {
      NewObject inTheList = savings[i];
      if(inTheList.deck == newObject.deck &&
          inTheList.subject == newObject.subject &&
          inTheList.date == newObject.date &&
          inTheList.time == newObject.time
      )
      {
        return true;
      }
    }
    return false;
  }





  static NewObject createNewObject(PlayBloc context, List<Flashcard> incorrectFlashcard, String date, String time)
  {
    String subject = context.subject.name;
    String deck = context.deck.name;
    String length = context.deck.flashcards.length.toString();
    List<String> questions=[];
    List<String> answers=[];

    for(int i=0;i<incorrectFlashcard.length;i++)
    {
      questions.add(incorrectFlashcard[i].question);
      answers.add(incorrectFlashcard[i].answer);
    }
    return NewObject(subject: subject, deck: deck, date: date, time: time, numberOfTotalFlashcards: length, wrongQuestions: questions,wrongAnswers: answers);
  }





  static Future<void> saveNewObject() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonList = savings.map((item) => item.toJson()).toList();

    final errorListJson = jsonEncode(jsonList);

    prefs.setString('savings', errorListJson);
  }



  static Future<void> loadNewObject() async {
    final prefs = await SharedPreferences.getInstance();
    final errorListJson = prefs.getString('savings');
    if (errorListJson != null) {

      List<dynamic> jsonList = jsonDecode(errorListJson);
      List<NewObject> loadedErrorList =   jsonList.map((itemJson) => NewObject.fromJson(itemJson)).toList();
      savings = loadedErrorList;
    } else {
      savings = [];
    }
  }



  static Future<void> deleteAll() async
  {
    savings.clear();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('savings', "");
  }

}



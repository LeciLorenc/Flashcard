import 'dart:convert';
import 'package:flashcard/bloc/play_bloc.dart';
import 'package:flashcard/calendar_and_recap/pastErrors/model/newObject.dart';
import 'package:flashcard/model/flashcard.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NewSavings {

  static List<PastErrorsObject> savings = [];


  static void addToNewSavings(PastErrorsObject playedDeck)
  {
    if( ! isContainedInTheSavings(playedDeck)) {
      savings.add(playedDeck);
      saveNewObject().then((_){});
    }
  }



  static bool isContainedInTheSavings(PastErrorsObject newObject)
  {
    if(savings.isEmpty) {
      return false;
    }
    for(int i=0;i<savings.length;i++)
    {
      PastErrorsObject inTheList = savings[i];
      if(inTheList.deck == newObject.deck &&
          inTheList.subject == newObject.subject &&
          inTheList.date == newObject.date &&
          inTheList.time == newObject.time &&
          inTheList.user_id == newObject.user_id
      )
      {
        return true;
      }
    }
    return false;
  }

  //get List<pastErrorsObject> from the user_id
static List<PastErrorsObject> getPastErrorsObjectList(String user_id)
  {
    List<PastErrorsObject> userPastErrorsObjectList = [];
    for(int i=0;i<savings.length;i++)
    {
      if(savings[i].user_id == user_id)
      {
        userPastErrorsObjectList.add(savings[i]);
      }
    }
    return userPastErrorsObjectList;
  }

  //toJson
  static List<Map<String, dynamic>> toJson() {
    List<Map<String, dynamic>> jsonList = savings.map((item) => item.toJson()).toList();
    return jsonList;
  }

  //fromJson
  static void fromJson(List<dynamic> jsonList) {
    List<PastErrorsObject> loadedErrorList =   jsonList.map((itemJson) => PastErrorsObject.fromJson(itemJson)).toList();
    savings = loadedErrorList;
  }





  static PastErrorsObject createNewObject(String user_id,PlayBloc context, List<Flashcard> incorrectFlashcard, String date, String time)
  {
    String userId = user_id;
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
    return PastErrorsObject(user_id: userId, subject: subject, deck: deck, date: date, time: time, numberOfTotalFlashcards: length, wrongQuestions: questions,wrongAnswers: answers);
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
      List<PastErrorsObject> loadedErrorList =   jsonList.map((itemJson) => PastErrorsObject.fromJson(itemJson)).toList();
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

  static void addPastErrorsObject(PastErrorsObject error) {
    savings.add(error);
  }

}



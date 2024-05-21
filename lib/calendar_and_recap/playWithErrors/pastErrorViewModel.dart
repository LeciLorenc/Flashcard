import 'dart:math';
import 'package:flashcard/model/flashcard.dart';
import 'package:flutter/material.dart';
import '../../model/deck.dart';
import '../../model/subject.dart';
import '../pastErrors/model/newObject.dart';
import '../pastErrors/storage/NewSavings.dart';

class PastErrorsViewModel extends ChangeNotifier {
  String subjectChosen = '';
  String deckChosen = '';
  PhasePlayChoice phasePlayChoice = PhasePlayChoice.choice;

  late Deck deck;
  late Subject subject;
  late List<Flashcard> flashcards = [];
  bool notOnly5Flashcards=false;

  PastErrorsViewModel();


  void createAllStuff()
  {
    createListFlashcard();
    List<Deck> temp=[];
    createSubject("0",subjectChosen, temp, Icons.add_call);
    createDeck("0",deckChosen, Icons.accessible, flashcards);
  }

  void createSubject(id,name,decks,icon)
  {
    subject= Subject(id: id, name: name, decks: decks, icon: icon);
  }
  void createDeck(id,name,icon,flashcards)
  {
    deck= Deck(id: id, name: name, icon: icon, flashcards: flashcards);
  }
  void createListFlashcard()
  {
    List<NewObject> listFiltered = List<NewObject>.from(NewSavings.savings);
    List<Flashcard> listOfAllThePossibleFlashcards = [];

    if(subjectChosen!= '')
    {
      flashcardFromSubject(listFiltered, listOfAllThePossibleFlashcards);
      listOfAllThePossibleFlashcards.shuffle();
    }else if(deckChosen!= '' )
    {
      flashcardFromDeck(listFiltered, listOfAllThePossibleFlashcards);
      listOfAllThePossibleFlashcards.shuffle();
    }
    else
    {
      print("error in the creation of the deck");
    }

    if(!notOnly5Flashcards)
    {
      adjustIfNotEnough(listOfAllThePossibleFlashcards);
      for(var j=0; j<5;j++)
      {
        flashcards.add(listOfAllThePossibleFlashcards[j]);
      }
    }
    else
    {
      flashcards= listOfAllThePossibleFlashcards;
    }



    print("list of the one played : ");
    for(int i=0 ; i<listOfAllThePossibleFlashcards.length;i++) {
      print(listOfAllThePossibleFlashcards[i]);
    }
  }

  void flashcardFromSubject(List<NewObject> listFiltered, List<Flashcard> listOfAllThePossibleFlashcards)
  {
    int i=0;

    for (var item in listFiltered) {
      if(item.subject == subjectChosen) {
        if (item.wrongQuestions.isNotEmpty) {
          for(int j=0;j<item.wrongQuestions.length;j++) {

            setUnknownDeckName(subjectChosen);

            listOfAllThePossibleFlashcards.add(Flashcard(
                id: i.toString(),
                question: item.wrongQuestions[j],
                answer: item.wrongAnswers[j],
                index: i));
            i++;
          }
        }
      }
    }
  }
  void flashcardFromDeck(List<NewObject> listFiltered, List<Flashcard> listOfAllThePossibleFlashcards)
  {
    int i=0;

    for (var item in listFiltered) {
      if(item.deck == deckChosen) {
        if (item.wrongQuestions.isNotEmpty) {

          setUnknownSubjectName(item.subject);

          for(int j=0;j<item.wrongQuestions.length;j++) {
            listOfAllThePossibleFlashcards.add(Flashcard(
                id: i.toString(),
                question: item.wrongQuestions[j],
                answer: item.wrongAnswers[j],
                index: i));
            i++;
          }

        }
      }
    }
  }

  void adjustIfNotEnough(List<Flashcard> listOfAllThePossibleFlashcards)
  {
    while(listOfAllThePossibleFlashcards.length<5)
    {
      Random random = Random();
      listOfAllThePossibleFlashcards.add(
          listOfAllThePossibleFlashcards [ random.nextInt (listOfAllThePossibleFlashcards.length-1) ] );
    }
  }

  void setUnknownDeckName(String subj){
    deckChosen = "Review$subj";
  }
  void setUnknownSubjectName(String subj)
  {
    subjectChosen=subj;
  }


  List<String> getSubjects()
  {
    List<NewObject> listFiltered = List<NewObject>.from(NewSavings.savings);
    List<String> listOfNames = [];

    for(var item in listFiltered)
    {
      if(item.wrongQuestions.isNotEmpty) {
        if (!listOfNames.contains(item.subject)) {
          listOfNames.add(item.subject);
        }
      }
    }
    return listOfNames;
    //return ["Deck111","Deck222","Deck333","Deck444","Deck555","Deck666"];
  }
  List<String> getDecks()
  {
    List<NewObject> listFiltered = List<NewObject>.from(NewSavings.savings);
    List<String> listOfNames = [];

    for(var item in listFiltered){
      if(item.wrongQuestions.isNotEmpty) {

        if(! listOfNames.contains(item.deck)  && !item.deck.startsWith("Review")) {
          listOfNames.add(item.deck);
        }
      }
    }
    return listOfNames;
    //return ["Deck111","Deck222","Deck333","Deck444","Deck555","Deck666"];
  }
}

enum PhasePlayChoice{
  choice,
  subject,
  deck,
  play
}
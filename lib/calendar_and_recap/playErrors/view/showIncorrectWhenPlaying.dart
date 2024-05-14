import 'package:flashcard/calendar_and_recap/---TO_BE_DISCARDED---/incorrectItem.dart';
import 'package:flashcard/calendar_and_recap/playErrors/model/newObject.dart';
import 'package:flutter/material.dart';
import '../view/customListItem.dart';
/*
Widget buildListOfErrors( List<IncorrectItem> incorrectFlashcards)
{
  return SingleChildScrollView(
    child: Column(
      children: [
        Container(
          width: 600,
          height: 600,
          margin: const EdgeInsets.all(2),
          child:
          ListView.builder(
            itemCount: incorrectFlashcards.length,
            itemBuilder: (context, index) {
              final flashcard = incorrectFlashcards[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomListItemInErrorDialog(
                  question: flashcard.question,
                  answer: flashcard.answer,
                ),
              );
            },
          ),
        ),
      ],
    ),
  );*/


Widget buildListOfErrors( NewObject incorrectFlashcards)
{
  return SingleChildScrollView(
    child: Column(
      children: [
        Container(
          width: 600,
          height: 600,
          margin: const EdgeInsets.all(2),
          child:
          ListView.builder(
            itemCount: incorrectFlashcards.wrongAnswers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomListItemInErrorDialog(
                  question: incorrectFlashcards.wrongQuestions[index],
                  answer: incorrectFlashcards.wrongAnswers[index],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

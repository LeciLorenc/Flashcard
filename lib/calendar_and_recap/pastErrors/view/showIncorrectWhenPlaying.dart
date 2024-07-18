import 'package:flashcard/calendar_and_recap/pastErrors/model/newObject.dart';
import 'package:flutter/material.dart';
import '../view/customListItem.dart';


class ErrorsList extends StatelessWidget {
  final pastErrorsObject incorrectFlashcards;

  const ErrorsList({Key? key, required this.incorrectFlashcards}) : super(key: key);


  @override
  Widget build(BuildContext context) {
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
}

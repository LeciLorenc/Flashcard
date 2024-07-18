import 'package:flashcard/calendar_and_recap/pastErrors/model/newObject.dart';
import 'package:flutter/material.dart';
import '../view/customListItem.dart';


class ErrorsList extends StatelessWidget {
  final pastErrorsObject incorrectFlashcards;
  final double width;final double height;

  const ErrorsList({Key? key, required this.incorrectFlashcards, required this.width, required this.height}) : super(key: key);


  @override
  Widget build(BuildContext context) {
  return Expanded(
    child: Column(
      children: [
        Container(
          width: width,
          height: height,
          margin: const EdgeInsets.all(2),
          child:
          ListView.builder(
            itemCount: incorrectFlashcards.wrongAnswers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
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

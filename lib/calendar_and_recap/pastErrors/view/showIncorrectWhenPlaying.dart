import 'package:flashcard/calendar_and_recap/pastErrors/model/newObject.dart';
import 'package:flashcard/layoutUtils.dart';
import 'package:flutter/material.dart';
import '../view/customListItem.dart';


class ErrorsList extends StatelessWidget {
  final PastErrorsObject incorrectFlashcards;
  final double width;final double height;

  const ErrorsList({Key? key, required this.incorrectFlashcards, required this.width, required this.height}) : super(key: key);


  @override
  Widget build(BuildContext context) {
  return Column(
    children: [
      SizedBox(
        height: setHeightForErrors(context),
        width: 200,
        child:
        ListView.builder(
          shrinkWrap: true,
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
  );
  }

  double setHeightForErrors(BuildContext context)
  {
    if (LayoutUtils.getHeight(context)>400 && LayoutUtils.isPortrait(context)) {
      return 530;
    } else if(LayoutUtils.getHeight(context)>400 && LayoutUtils.isLandscape(context)){
      return 270;
    }
    else {
      return 135;
    }
  }
}

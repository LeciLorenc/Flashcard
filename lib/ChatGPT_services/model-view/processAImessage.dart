
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/subject_bloc.dart';
import '../../model/deck.dart';
import '../../model/subject.dart';
import 'package:flashcard/ChatGPT_services/view/dialogs/infoChat_dialog.dart';
import 'package:flashcard/ChatGPT_services/view/dialogs/loading_dialog.dart';

constructionOfTheMessage(String name, String description, int number, String language)
{
  String message="Create a json file with this structure: "
      "1-'question':'...' ,'answer' :'...', 2-'question':'...','answer':'...', 3- ecc... "
      "In particular it should be composed of $number questions with the corresponding answers"
      " on the topic with this name :'$name' and this description :'$description'"
      " and all the q&a must be in this language : $language"
      "NECESSARY CONDITION : In the response that you will send to me I want only a json file"
      "So I don't need any other explanatory or introducing section or sentence."
      "ONLY THE JSON FILE AND ONLY WITH THE STRUCTURE DESCRIBED BEFORE";
  return message;
}

showLoadingMessage(BuildContext context) async
{
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const LoadingDialog();
    },
  );

  await Future.delayed(const Duration(seconds: 2));
}

showInfoMessage(BuildContext context, String message) async
{
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return InfoDialog(message: message);
    },
  );
}

dialogResponseArrived(String response, BuildContext context)
{
  print(response);

  Navigator.pop(context);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const InfoDialog(message: "The response arrived");
    },
  );
}

badResponseUnexpected(dynamic error, BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return InfoDialog(message: "Error in the communication with Chat GPT: $error");
    },
  );
}


badResponseHandling(dynamic error, BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return InfoDialog(message: "Error in the communication with Chat GPT: $error");
    },
  );
}

insertionOfDeck(BuildContext context, String name, String description, int number, String language, IconData iconFromDialog, Subject subject) async
{
  String nameOfTheDeck = '$name';
  context.read<SubjectBloc>().add(
    AddDeck(
      name: nameOfTheDeck,
      icon: iconFromDialog,
    ),
  );
  await Future.delayed(Duration.zero);
  return  subject.decks.firstWhere((element) => element.name == nameOfTheDeck);

}

insertionOfTheFlashcard(BuildContext context, Deck deckCreatedByAI, String response) async
{
  context.read<SubjectBloc>().add(SelectDeck(deckCreatedByAI, visualize: true));

  Map<String, dynamic> data = json.decode(response);
  List<String> questions = [];
  List<String> answers = [];

  data.forEach((key, value) {
    questions.add(value['question']);
    answers.add(value['answer']);
  });


  for (int i = 0; i < questions.length; i++) {
    await timer();
    await timer();


    context.read<SubjectBloc>().add(AddFlashcard(question: questions[i], answer: answers[i], index: i));

    await timer();
    await timer();
  }
  await timer();
  await timer();
}


timer() async {
  Future.delayed(Duration.zero);
}

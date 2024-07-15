import 'package:flutter/material.dart';

import '../../../ChatGPT_services/view/minorDialogs/infoChat_dialog.dart';
import '../../../ChatGPT_services/view/minorDialogs/loading_dialog.dart';

String constructionOfTheMessageForDetails(List<String> wrongQuestions, List<String> wrongAnswers )
{
  String message="I will provide you a list of questions and related answers and I want you"
      " to motivate why that is the correct answer. So for each couple question and answer "
      "you should provide me a description explaining the answer. (List of question and answer provided"
      "at the end)."
      "If you are not able to do that reply with 'I'm not able to respond' for the corresponding"
      " couple and go on with the other couples provided."
      "In particular you should create a json file with this structure: "
      "{ '1': { 'question': '...', 'answer': '...', 'description': '...' },"
      "'2': { 'question': '...', 'answer': '...', 'description': '...' }, ...}. "
      "I want that the description string contains the description of the answer, that"
      "explains why the answer is correct, based also on the related question."
      "Note that you should be compliant with the language that is used in the wrong answers and "
      "in the wrongQuestions provided"
      "Now here is the list of questions and then the corresponding answers:"
      "questions : $wrongQuestions; answers: $wrongAnswers"
      "NECESSARY CONDITION : In the response that you will send to me I want only a json file"
      "So I don't need any other explanatory or introducing section or sentence."
      "ONLY THE JSON FILE AND ONLY WITH THE STRUCTURE DESCRIBED BEFORE";
  return message;
}

void showLoadingMessage(BuildContext context) async
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
      return InfoDialog(message: "We are sorry, there is an error in the parsing of the reply from chatGpt.\n"
          "We ask you kindly to retry. \n(That's the error: $error )");
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
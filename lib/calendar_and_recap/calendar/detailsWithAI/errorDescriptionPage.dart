import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../ChatGPT_services/model-view/api_service.dart';
import '../../../ChatGPT_services/model-view/processAImessage.dart';
import '../../../ChatGPT_services/view/minorDialogs/loading_dialog.dart';
import '../../../constants.dart';
import '../../../main.dart';

class ErrorDescriptionWidgetWithAI extends StatefulWidget {
  final String messageToBeSent;

  ErrorDescriptionWidgetWithAI(this.messageToBeSent, {Key? key}) : super(key: key);

  @override
  _ErrorDescriptionWidgetWithAIState createState() => _ErrorDescriptionWidgetWithAIState();
}

class _ErrorDescriptionWidgetWithAIState extends State<ErrorDescriptionWidgetWithAI> {
  late String responseFromGpt = "";
  List<String> questions = [];
  List<String> answers = [];
  List<String> descriptions = [];


  @override
  void initState() {
    super.initState();
    Future.microtask(() => sendAndReceive());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details about the errors'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text("Here is your response:"),
                  SizedBox(height: 10),
                  widgetResponseAIWithRecap(context),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: goBackButton(),
            ),
          ),
        ],
      ),
    );
  }


  Widget goBackButton() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ListTile(
        leading: const Icon(Icons.arrow_back),
        title: const Text('Go back'),
        onTap: () => Navigator.pop(context),
      ),
    );
  }

  Future<void> sendAndReceive() async {
    String response = "";
    LoadingDialog.isLoading = true;

    showLoadingMessage(context);

    try {
      response = await ApiService.sendMessageToChatGPT(widget.messageToBeSent);
      print(response);
      if (LoadingDialog.isLoading) {
        dialogResponseArrived(response, context);
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pop(context);

        showInfoMessage(context, "Now will be displayed the description of the answers created by the AI");
        await Future.delayed(const Duration(seconds: 3));
        Navigator.pop(context);
      }
    } catch (error) {
      Navigator.pop(context);
      badResponseHandling(error, context);
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pop(context);
    }

    setState(() {
      responseFromGpt = response;
    });

    Map<String, dynamic> jsonMap = jsonDecode(response);

    jsonMap.forEach((key, value) {
      questions.add(value['question']);
      answers.add(value['answer']);
      descriptions.add(value['description']);
    });
    print("ciao");
  }

  Widget widgetResponseAIWithRecap(BuildContext context) {

    return Expanded(
      child: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 10.0, 8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Item ${index + 1}"),
                    Text('Question - :${questions[index]}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                    const SizedBox(height: 4),
                    Text('Answer - ${answers[index]}',
                        style: TextStyle(
                          color: isDark? shade2light:  shade1dark,
                          fontSize: 14,
                        )),
                    const SizedBox(height: 4),
                    Text('Description - ${descriptions[index]}',
                        style:  TextStyle(
                          color: isDark? shade1light: shade2dark,
                          fontSize: 12,
                        )),
                    //const Divider(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
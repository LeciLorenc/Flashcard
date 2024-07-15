import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../ChatGPT_services/model-view/api_service.dart';
import '../../../ChatGPT_services/model-view/processAImessage.dart';
import '../../../ChatGPT_services/view/minorDialogs/loading_dialog.dart';

class ErrorDescriptionWidget extends StatefulWidget {
  final String messageToBeSent;

  ErrorDescriptionWidget(this.messageToBeSent, {Key? key}) : super(key: key);

  @override
  _ErrorDescriptionWidgetState createState() => _ErrorDescriptionWidgetState();
}

class _ErrorDescriptionWidgetState extends State<ErrorDescriptionWidget> {
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
      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text("data"),
              Text(responseFromGpt),
              const Text("fine"),
              Align(
                alignment: Alignment.bottomCenter,
                child: goBackButton(),
              ),
            ],
          ),
        ),
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
        await Future.delayed(const Duration(seconds: 2));
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
}
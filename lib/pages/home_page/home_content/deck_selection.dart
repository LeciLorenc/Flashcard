import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ChatGPT_services/model/deckCreation.dart';
import '../../../ChatGPT_services/model-view/processAImessage.dart';
import '../../../bloc/subject_bloc.dart';
import '../../../model/deck.dart';
import '../../../model/subject.dart';
import '../../../presentation/education_icons.dart';
import '../../play_page/play_page.dart';
import '../../../ChatGPT_services/view/creationWithAIDialog.dart';
import 'package:flashcard/ChatGPT_services/view/minorDialogs/loading_dialog.dart';

import 'package:flashcard/ChatGPT_services/model-view/api_service.dart';
class DeckSelection extends StatelessWidget {
  const DeckSelection({
    super.key,
    required this.subject,
  });

  final Subject subject;

  @override
  Widget build(BuildContext context) {

    return ListView(
      shrinkWrap: true,
      children: [
        if(MediaQuery.of(context).size.width < 600)
          widgetPortraitOrientation(context)
        else
          widgetLandscapeOrientation(context),
        Column(
          children: [
            ListTile(
              onTap: () => onAddDeck(context),
              leading: const Icon(Icons.add),
              title: const Text('Add deck'),
            ),
            ListTile(
              onTap: () => onAddDeckWithAI(context),
              leading: const Icon(Icons.add),
              title: const Text('Add deck with AI'),
            ),
          ],
        )
      ],
    );
  }

  Widget widgetPortraitOrientation(BuildContext context) {
    return Column(
      children: subject.decks.map((deck) => Column(
        children: [
          ListTile(
            leading: Icon(deck.icon),
            title: Text(deck.name),
            subtitle: Text('${deck.flashcards.length} cards'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widgetForEachDeck(deck, context),
            ],
          ),
          const Divider(),
        ],
      )).toList(),
    );
  }

  Widget widgetLandscapeOrientation(BuildContext context) {
    return Column(
      children: subject.decks.map((deck) => Column(
        children: [
          ListTile(
            leading: Icon(deck.icon),
            title: Text(deck.name),
            subtitle: Text('${deck.flashcards.length} cards'),
            trailing: widgetForEachDeck(deck, context),
          ),
          const Divider(),
        ],
      )).toList(),
    );
  }

  //MediaQuery.of(context).size.height > 700
  Widget widgetForEachDeck(Deck deck, BuildContext context)
  {
    return  StatefulBuilder(
        builder: (BuildContext context, Function setState)
        {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Play',
                onPressed: deck.flashcards.isEmpty
                    ? null
                    : () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => PlayPage(
                      subject: subject,
                      deck: deck,
                    ),
                  ),
                ),
                icon: const Icon(Icons.play_arrow_outlined),
              ),
              const SizedBox(width: 16.0),
              IconButton(
                tooltip: 'View',
                icon: const Icon(Icons.visibility_outlined),
                onPressed: () => context.read<SubjectBloc>().add(SelectDeck(
                  deck,
                  visualize: true,
                )),
              ),
              const SizedBox(width: 16.0),
              IconButton(
                tooltip: 'Edit',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.read<SubjectBloc>().add(SelectDeck(
                  deck,
                  visualize: false,
                )),
              ),
              const SizedBox(width: 16.0),
              IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outlined),
                onPressed: () => setState(() {  onDeleteDeck(context, deck); }),
              ),
            ],);
        }
    );
  }

  void onDeleteDeck(BuildContext context, Deck deck) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete deck'),
        content: const Text('Are you sure you want to delete this deck?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {

              context.read<SubjectBloc>().add(
                DeleteDeck(
                  deck: deck,
                ),
              );

              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void onAddDeck(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    String errorMessage = '';
    IconData icon = EducationIcons.openBook;

    showDialog<String>(
      barrierColor: Colors.black.withOpacity(0.3),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, Function setState) {
              return AlertDialog(

                title: const Text('Create new deck'),
                content: Flex(
                  direction: Axis.vertical,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(icon),
                          onPressed: () async {
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            children: [
                              TextField(
                                decoration: const InputDecoration(
                                  hintText: 'Enter the name of the deck',
                                ),
                                controller: textEditingController,
                              ),
                              if (errorMessage.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    errorMessage,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {

                      String newSubjectName = textEditingController.text.trim();
                      String? validationResult = validateDeckName(context, newSubjectName);

                      if (validationResult != null) {
                        setState(() {
                          errorMessage = validationResult;
                        });
                        return;
                      }

                      context.read<SubjectBloc>().add(
                        AddDeck(
                          name: textEditingController.text,
                          icon: icon,
                        ),
                      );
                      Navigator.pop(context, 'OK');
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            }
        );
      },
    );
  }



  void onAddDeckWithAI(BuildContext context) async {
    BuildContext oldContext = context;


    DeckCreationViewModel deckCreationViewModel = DeckCreationViewModel();
    final List<dynamic> result = await creationWithAIDialog(oldContext, deckCreationViewModel);

    String response="";
    if (result.isNotEmpty && result[0] == 'OK') {

      // Accesso ai parametri selezionati
      final String name = result[1];
      final String descriptionForGPT = result[2];
      final int numberOfFlashcard = result[3];
      final String languageForGPT = result[4];
      final IconData iconFromDialog = result[5];


      LoadingDialog.isLoading=true;

      showLoadingMessage(context);

      String message= constructionOfTheMessage(name, descriptionForGPT,numberOfFlashcard,languageForGPT);

      try {
        response= await ApiService.sendMessageToChatGPT(message);
        if( LoadingDialog.isLoading ) {
          dialogResponseArrived(response, context);
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pop(context);

          //TODO prima di mettere l'add del deck verificare che il response passi tutta una serie di parametri
          showInfoMessage(
              context, "Now will be displayed the flashcard created by the AI");
          await Future.delayed(const Duration(seconds: 3));
          Navigator.pop(context);
          await Future.delayed(const Duration(seconds: 2));

          try {
            dynamic deckCreatedByAI = await insertionOfDeck(
                context,
                name,
                descriptionForGPT,
                numberOfFlashcard,
                languageForGPT,
                iconFromDialog,
                subject);

            await insertionOfTheFlashcard(context, deckCreatedByAI, response);

            context.read<SubjectBloc>().add(SelectSubject(subject));
          }catch (error)
          {
            context.read<SubjectBloc>().add(SelectSubject(subject));
            badResponseUnexpected(error, context);
          }
        }

      } catch (error) {
        Navigator.pop(context);
        badResponseHandling(error, context);
        await Future.delayed(const Duration(seconds: 3));
        Navigator.pop(context);
      }

      await Future.delayed(const Duration(seconds: 1));
    }

  }

  String? validateDeckName(BuildContext context, String name) {
    if (name.isEmpty) {
      return 'Subject name cannot be empty';
    }

    List<String> existingDecks = subject.decks.map((deck) => deck.name).toList();
    if (existingDecks.contains(name)) {
      return 'Subject name already exists';
    }

    return null; // No validation errors
  }

}
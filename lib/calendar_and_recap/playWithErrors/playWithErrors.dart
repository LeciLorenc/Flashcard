
import 'package:flashcard/calendar_and_recap/pastErrors/storage/NewSavings.dart';
import 'package:flashcard/calendar_and_recap/playWithErrors/pastErrorViewModel.dart';
import 'package:flashcard/calendar_and_recap/playWithErrors/choice.dart';
import 'package:flashcard/calendar_and_recap/playWithErrors/subjectChoice.dart';
import 'package:flutter/material.dart';

import 'deckChoice.dart';

class PlayWithPastErrors extends StatefulWidget {
  final PastErrorsViewModel viewModel;
  bool areThereErrors = true;

  PlayWithPastErrors({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  _PlayWithPastErrors createState() => _PlayWithPastErrors();
}

class _PlayWithPastErrors extends State<PlayWithPastErrors> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      if (widget.viewModel.phasePlayChoice == PhasePlayChoice.choice ||
          widget.viewModel.phasePlayChoice == PhasePlayChoice.play) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 16,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height - 16 - 56-34, //padding + appBar
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Choice(orderingCallback: updateChoice),

                      Visibility(
                        visible: !widget.areThereErrors,
                        child: const Text(
                          "No errors done till now",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),),
              ],),),
        );
      }
      else {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 16,
                height: MediaQuery
                    .of(context)
                    .size
                    .height - 16 - 56 -34, //padding + appBar
                child: Transform.translate(
                  offset: const Offset(0,0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder(
                        future: Future.delayed(const Duration(seconds: 1)),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState
                              .waiting) {
                            return Center(child: circularProgressWidget());
                          } else {
                            if (widget.viewModel.phasePlayChoice ==
                                PhasePlayChoice.subject) {
                              return SubjectChoice(
                                  orderingCallback: updateSubject,
                                  pastErrorsViewModel: widget.viewModel);
                            } else {
                              return DeckChoice(
                                  orderingCallback: updateDeck,
                                  pastErrorsViewModel: widget.viewModel);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    },
    );
  }

  void updateChoice(String choice) {
    setState(() {
      if (NewSavings.savings.isEmpty) {
        widget.areThereErrors = false;
      } else if (choice == 'Subject') {
        widget.viewModel.phasePlayChoice = PhasePlayChoice.subject;
      } else if (choice == 'Deck') {
        widget.viewModel.phasePlayChoice = PhasePlayChoice.deck;
      }
    });
  }

  void updateSubject(String subject) {
    setState(() {
      if (subject != '') {
        widget.viewModel.phasePlayChoice = PhasePlayChoice.play;
        widget.viewModel.subjectChosen = subject;
      } else {
        widget.viewModel.phasePlayChoice = PhasePlayChoice.choice;
      }
    });
  }

  void updateDeck(String deck) {
    setState(() {
      if (deck != '') {
        widget.viewModel.phasePlayChoice = PhasePlayChoice.play;
        widget.viewModel.deckChosen = deck;
      } else {
        widget.viewModel.phasePlayChoice = PhasePlayChoice.choice;
      }
    });
  }

  Widget circularProgressWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}


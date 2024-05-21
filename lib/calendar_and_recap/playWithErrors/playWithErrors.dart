
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
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 16,
              height: MediaQuery.of(context).size.height - 16 - 56, //padding + appBar
              child: ListView(
                physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                children: [
                  Visibility(
                    visible: (widget.viewModel.phasePlayChoice == PhasePlayChoice.choice ||
                        widget.viewModel.phasePlayChoice == PhasePlayChoice.play),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Choice(orderingCallback: updateChoice),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: (widget.viewModel.phasePlayChoice == PhasePlayChoice.subject ||
                        widget.viewModel.phasePlayChoice == PhasePlayChoice.deck),
                    child: FutureBuilder(
                      future: Future.delayed(const Duration(seconds: 1)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: circularProgressWidget());
                        } else {
                          if (widget.viewModel.phasePlayChoice == PhasePlayChoice.subject) {
                            return SubjectChoice(
                                orderingCallback: updateSubject, pastErrorsViewModel: widget.viewModel);
                          } else {
                            return DeckChoice(
                                orderingCallback: updateDeck, pastErrorsViewModel: widget.viewModel);
                          }
                        }
                      },
                    ),
                  ),
                  Visibility(
                    visible: !widget.areThereErrors,
                    child: const Text(
                      "No errors done till now",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
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
        widget.viewModel.subjectChosen = subject;
        widget.viewModel.phasePlayChoice = PhasePlayChoice.play;
      } else {
        widget.viewModel.phasePlayChoice = PhasePlayChoice.choice;
      }
    });
  }

  void updateDeck(String deck) {
    setState(() {
      if (deck != '') {
        widget.viewModel.deckChosen = deck;
        widget.viewModel.phasePlayChoice = PhasePlayChoice.play;
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



  /*
  @override
  Widget build(BuildContext context) {

    print("Here we go with the context ");
    context.read<SubjectBloc>().state.subjects.map((x) {
      print(x);
    }).toList();
    return StatefulBuilder(
      builder: (context, setState) {
        return
          Padding(
            padding: EdgeInsets.all(8.0),
            child:
            Center(
              child: Column(
                children: [
                  const Text("Hello, here you can choose which past error you want to revise : ",
                    style: TextStyle(
                    fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,),),



                  ElevatedButton(
                    onPressed: () {
                      widget.choiceViewModel.selectChoice(Choice.Subject);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                        if (widget.choiceViewModel._selectedChoice == Choice.Subject) {
                          return Colors.lightGreenAccent; // Change to light blue when selected
                        } else {
                          return Colors.white; // Change to white when not selected
                        }
                      }),
                    ),
                    child: const Text("Subject"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      widget.choiceViewModel.selectChoice(Choice.Deck);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                        if (widget.choiceViewModel._selectedChoice == Choice.Deck) {
                          return Colors.lightGreenAccent; // Change to light blue when selected
                        } else {
                          return Colors.white; // Change to white when not selected
                        }
                      }),
                    ),
                    child: const Text("Deck"),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: widget.choiceViewModel.selectedChoice != null
                        ? Text(
                      widget.choiceViewModel.selectedChoice == Choice.Subject ? "Subject Selected" : "Deck Selected",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : const SizedBox.shrink(),
                  ),






                  IconButton(
                    tooltip: 'Play',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => PlayPage(
                          subject: Subject(id: '', name: '', decks: [], icon: Icons.android_outlined,),
                          deck: PastErrorsViewModel().deck,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_outlined),
                  ),
                ],
              ),
            ),
          );
      },
    );
  }
}
*/


/*


  Navigator.push(
  context,
  MaterialPageRoute(
  builder: (BuildContext context) =>
  PlayPage(
  subject: Subject(id: '', name: '', decks: [], icon: Icons.android_outlined,),
  deck: PastErrorsViewModel().deck,
  ),
  ),
  );
*/


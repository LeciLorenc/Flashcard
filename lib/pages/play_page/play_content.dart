import 'package:flashcard/calendar_and_recap/pastErrors/model/newObject.dart';
import 'package:flashcard/calendar_and_recap/---TO_BE_DISCARDED---/playedItems.dart';
import 'package:flashcard/calendar_and_recap/---TO_BE_DISCARDED---/filters.dart';
//import 'package:flashcard/calendar_and_recap/playErrors/storage/storageData.dart';
import 'package:flashcard/calendar_and_recap/---TO_BE_DISCARDED---/incorrectItem.dart';
import 'package:flashcard/model/flashcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/play_bloc.dart';
import '../../calendar_and_recap/pastErrors/storage/NewFilters.dart';
import '../../calendar_and_recap/pastErrors/storage/NewSavings.dart';
import '../../calendar_and_recap/pastErrors/view/showIncorrectWhenPlaying.dart';
import '../../main.dart';
import '../../widget/adaptable_card/adaptable_card.dart';
import '../../widget/flashcard_text_editing_controller/flashcard_text_editing_controller.dart';

class PlayContent extends StatefulWidget {
  const PlayContent({
    super.key,
    required this.hiddenAnswer,
    required this.onHiddenAnswer,
  });

  final bool hiddenAnswer;
  final Function(bool) onHiddenAnswer;

  @override
  State<PlayContent> createState() => _PlayContentState();
}

class _PlayContentState extends State<PlayContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<PlayBloc, PlayState>(
          builder: (BuildContext context, PlayState state) {
        if (state is Playing) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: AdaptableCard(
                  readOnly: true,
                  hiddenAnswer: widget.hiddenAnswer,
                  flashcardTextEditingController:
                      FlashcardTextEditingController(
                    flashcard: state.nextFlashcard,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              if (widget.hiddenAnswer)
                ElevatedButton(
                  onPressed: () => widget.onHiddenAnswer(false),
                  child: const Text(
                    'Reveal answer',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (!widget.hiddenAnswer)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onHiddenAnswer(true);
                          context.read<PlayBloc>().add(Answer(correct: true));
                        },
                        child: const Text(
                          'Correct',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onHiddenAnswer(true);
                          context.read<PlayBloc>().add(
                                Answer(correct: false),
                              );
                        },
                        child: const Text(
                          'Wrong',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          );
        }
        if (state is Finished) {

          final incorrectFlashcards= context.read<PlayBloc>().getIncorrectFlashcards();
          String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
          String currentTime = DateFormat.Hms().format(DateTime.now());

          //ADD OF ERRORS
          /*
          for(Flashcard wrongFlash in incorrectFlashcards)
          {
            IncorrectItem incorrectItem = StorageData.createIncorrectItem(context.read<PlayBloc>(),
                                                    wrongFlash, currentDate, currentTime);
            StorageData.addToErrorList(incorrectItem);
          }
          StorageData.saveErrorList().then((value) => null);

          //ADD OF PLAYED DECK
          PlayedDeck playedDeck = StorageData.createPlayedDeck(context.read<PlayBloc>(),
                                                  currentDate,currentTime);
          StorageData.addToPlayedList(playedDeck);
          StorageData.savePlayedList().then((value) => null);
          */

                        //SUBSTITUTE
          pastErrorsObject newObject = NewSavings.createNewObject(globalUserId, context.read<PlayBloc>(), incorrectFlashcards, currentDate, currentTime);
          NewSavings.addToNewSavings(newObject);
          NewSavings.saveNewObject().then((value) => null);



          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Finished!',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Correct: ${state.flashcards.fold<int>(0, (previousValue, (
                        bool?,
                        Flashcard
                      ) element) => element.$1 ?? false ? previousValue + 1 : previousValue)}',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Wrong: ${state.flashcards.fold<int>(0, (previousValue, (
                        bool?,
                        Flashcard
                      ) element) => element.$1 ?? false ? previousValue : previousValue + 1)}',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16.0),


                Visibility(
                  //visible: FiltersStorage.getErrorsFilteredByDateAndTime(currentDate, currentTime).isNotEmpty,

                  visible: isButtonVisible(currentDate,currentTime),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierColor: Colors.black.withOpacity(0.3),
                        builder: (context) {
                          final specificSaving = NewFiltersStorage.getASpecificSaving(currentDate, currentTime, NewFiltersStorage.filterByUser(globalUserId, NewSavings.savings));
                          if (specificSaving != null)
                          {
                            return AlertDialog(
                              title: const Text("Those are your errors"),
                              //content: buildListOfErrors(FiltersStorage.getErrorsFilteredByDateAndTime(currentDate, currentTime)),
                              content: buildListOfErrors(specificSaving),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Close"),
                                ),
                              ],
                            );
                          }
                          else
                          {
                            return const SizedBox(child: Text("error parsing"),);
                          }
                        },
                      );
                    },
                    child: const Text(
                      'Show Errors',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),


                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => context.read<PlayBloc>().add(Play()),
                  child: const Text(
                    'Play again',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ],
            ),
          );
        }
        return const SizedBox();
      }),
    );
  }

  bool isButtonVisible(String currentDate, String currentTime)
  {
    pastErrorsObject? result = NewFiltersStorage.getASpecificSaving(currentDate, currentTime, NewFiltersStorage.filterByUser(globalUserId, NewSavings.savings));
    if( result != null && result.wrongQuestions.isNotEmpty && result.wrongAnswers.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
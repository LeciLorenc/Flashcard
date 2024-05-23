import 'package:flashcard/ChatGPT_services/view/lists_of_small_widgets.dart';
import 'package:flutter/material.dart';
import '../../../presentation/education_icons.dart';
import '../model/deckCreation.dart';

Future<List<dynamic>> creationWithAIDialog(BuildContext context, DeckCreationViewModel deckCreationViewModel) async {
  PageController _pageController = PageController();
  int _currentPage = 0;


  final result = await showDialog<List<dynamic>>(
    barrierColor: Colors.black.withOpacity(0.3),
    context: context,

    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState)
        {

          if(MediaQuery.of(context).size.height > 700)
          {
            return AlertDialog(
              title: const Text('Create new deck with AI'),
              content: SingleChildScrollView(
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildDeckNameInput(context, EducationIcons.teaching, deckCreationViewModel),

                    buildLabelForNumberOfFlashcards(context),
                    buildNumberOfFlashcards(context,deckCreationViewModel),

                    buildLabelForLanguagesOfFlashcards(),
                    buildLanguageOfFlashcards(deckCreationViewModel, setState),

                    buildLabelForDescriptionOfFlashcards(deckCreationViewModel),

                    buildLabelForIconOfFlashcards(),
                    buildIconSelectionWidget(context, deckCreationViewModel, setState),

                  ],
                ),
              ),
              actions: <Widget>[
                okButtonAction(deckCreationViewModel ,context),
                cancelButtonAction(context),
              ],
            );
          }
          else
          {
            return AlertDialog(
              title: const Text('Create new deck with AI'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 110.0,
                      width: 300,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              buildDeckNameInput(context, EducationIcons.teaching, deckCreationViewModel),
                            ],
                          ),
                          Column(
                            children: [
                              buildLabelForNumberOfFlashcards(context),
                              buildNumberOfFlashcards(context, deckCreationViewModel),
                            ],
                          ),
                          Column(
                            children: [
                              buildLabelForLanguagesOfFlashcards(),
                              buildLanguageOfFlashcards(deckCreationViewModel, setState),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              buildLabelForDescriptionOfFlashcards(deckCreationViewModel),
                            ],
                          ),
                          Column(
                            children: [
                              buildLabelForIconOfFlashcards(),
                              buildIconSelectionWidget(context, deckCreationViewModel, setState),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(5, (int index) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: 10,
                          width: 10,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (_currentPage > 0) {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: _currentPage ==0 ? const Text('Close'):  const Text('Back'),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_currentPage < 4) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        } else {
                          Navigator.pop(context, ['OK',
                            deckCreationViewModel.textEditingController.text,
                            deckCreationViewModel.textDescriptionController.text,
                            deckCreationViewModel.number,
                            deckCreationViewModel.selectedLanguage,
                            deckCreationViewModel.selectedIcon]);
                        }
                      },
                      child: _currentPage <4 ? const Text('Next') : const Text('Send Request'),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      );
    },
  );

  return result ?? [];

}



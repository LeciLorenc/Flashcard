import 'package:flashcard/bloc/subject_bloc.dart';
import 'package:flashcard/calendar_and_recap/historyErrorList/historyError.dart';
import 'package:flashcard/calendar_and_recap/pastErrors/storage/NewSavings.dart';
import 'package:flashcard/calendar_and_recap/playWithErrors/pastErrorViewModel.dart';
import 'package:flashcard/constants.dart';
import 'package:flashcard/pages/enumParamountWidgets.dart';
import 'package:flashcard/pages/home_page/home_content/home_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../calendar_and_recap/calendar/calendar.dart';
import '../../calendar_and_recap/historyErrorList/historyErrorViewModel.dart';
import '../../calendar_and_recap/playWithErrors/playWithErrors.dart';
import '../../calendar_and_recap/settings/settingsWidget.dart';
import '../../calendar_and_recap/welcome/welcomeWidget.dart';
import '../../main.dart';
import '../../model/subject.dart';
import '../../widget/adaptable_button.dart';
import '../../widget/adaptable_page.dart';
import 'subject_selection.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  static var expanded = false;
  static var bodyContent = EssentialWidgets.welcome;
}

class _HomePageState extends State<HomePage> {

  _HomePageState()
  {
    NewSavings.loadNewObject().then((_) {});
  }



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectBloc, SubjectState>(
      builder: (BuildContext context, SubjectState subjectState) {
        return AdaptablePage(
          expanded: HomePage.expanded,
          onExpand: onExpand,
          // drawer: Drawer(
          //   backgroundColor: Colors.green,
          //child: SubjectSelection(
          drawer: SubjectSelection(
            subjects: subjectState.subjects,
            onThemeChanged: (isDarkMode) {
              MyApp.of(context)!.toggleTheme(isDarkMode);
            },
            // expanded: HomePage.expanded, onThemeChanged: (bool ) {  },
          ),
          // ),
          content: defineBodyWidget(),
          title: defineTitle(subjectState),
          actions: [
            if (subjectState.subject != null)
              IntrinsicWidth(
                child: AdaptableButton(
                  onPressed: () => onDeleteSubject(subjectState.subject!),
                  title: 'Delete subject',
                  icon: Icons.delete_outline,
                  expanded: false, textColor: primaryColor, iconColor: primaryColor,
                ),
              ),
          ],
        );
      },
    );
  }


  String defineTitle(subjectState) {
    switch (HomePage.bodyContent) {
      case EssentialWidgets.welcome:
        return "Welcome";
      case EssentialWidgets.subject:
        return defineStringTitleForSubject(subjectState);
      case EssentialWidgets.calendar:
        return "Calendar";
      case EssentialWidgets.historyError:
        return "History of all the errors";
      case EssentialWidgets.playWithError:
        return "Play with past errors";
      case EssentialWidgets.settings:
        return "Settings";
      default:
        return "error";
    }
  }
  String defineStringTitleForSubject(subjectState)
  {
    int maxLengthTotal= 25;
    int maxTrimSubject = 10;

    if(subjectState.subject == null){
      return 'Select subject';
    }
    else
    {
      String subjName= '${subjectState.subject!.name}';
      String deckName= subjectState.deck?.name ?? '';

      if(deckName == '')
      {
        if(subjName.length>maxLengthTotal) {
          return subjName.substring(0,maxLengthTotal);
        }
        else
        {
          return subjName;
        }
      }
      else if(subjName=='')
      {
        if(deckName.length>maxLengthTotal-1) {
          return '-${deckName.substring(0,maxLengthTotal-1)}';
        }
        else
        {
          return '-$deckName';
        }
      }
      else
      {
        if(subjName.length + deckName.length > maxLengthTotal-1)
        {
          if(subjName.length> maxTrimSubject)
          {
            subjName = '${subjName.substring(0,maxTrimSubject-3)}...';
          }
          int remainingDeckSpace = maxLengthTotal-1-subjName.length-3;
          if(deckName.length > remainingDeckSpace)
          {
            deckName = '${deckName.substring(0,remainingDeckSpace+1)}...';
          }
        }
        return '$subjName-$deckName';
      }
    }
  }

  Widget defineBodyWidget()
  {
    if(HomePage.bodyContent == EssentialWidgets.subject) {
      return const HomeContent();
    }
    else if(HomePage.bodyContent == EssentialWidgets.welcome){
      return WelcomeWidget();
    }
    else if(HomePage.bodyContent == EssentialWidgets.calendar){
      return const CalendarWidget();
    }
    else if(HomePage.bodyContent == EssentialWidgets.historyError){
      return HistoryError(viewModel: HistoryErrorViewModel());
    }
    else if(HomePage.bodyContent == EssentialWidgets.playWithError){
      return  PlayWithPastErrors(viewModel: PastErrorsViewModel(), );
    }
    else if(HomePage.bodyContent == EssentialWidgets.settings){
      return  SettingsWidget( onThemeChanged: (isDarkMode) {
        MyApp.of(context)!.toggleTheme(isDarkMode);
      }, );
    }
    else
    {
      return const AlertDialog(semanticLabel: "Errorrr");
    }
  }


  void onExpand() => setState(() {
    HomePage.expanded = !HomePage.expanded;
  });


  void onDeleteSubject(Subject subject) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete subject'),
        content: const Text('Are you sure you want to delete this subject?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<SubjectBloc>().add(
                DeleteSubject(
                  subject: subject,
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
}

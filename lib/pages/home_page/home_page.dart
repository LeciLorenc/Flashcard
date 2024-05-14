import 'package:flashcard/bloc/subject_bloc.dart';
import 'package:flashcard/calendar_and_recap/historyErrorList/historyError.dart';
import 'package:flashcard/calendar_and_recap/playErrors/storage/NewSavings.dart';
import 'package:flashcard/pages/enumParamountWidgets.dart';
import 'package:flashcard/pages/home_page/home_content/home_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../calendar_and_recap/calendar/calendar.dart';
import '../../calendar_and_recap/welcome/welcomeWidget.dart';
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
          drawer: SubjectSelection(
            subjects: subjectState.subjects,
            expanded: HomePage.expanded,
          ),
          content: defineBodyWidget(),
          title: defineTitle(subjectState),
          actions: [
            if (subjectState.subject != null)
              IntrinsicWidth(
                child: AdaptableButton(
                  onPressed: () => onDeleteSubject(subjectState.subject!),
                  title: 'Delete subject',
                  icon: Icons.delete_outline,
                  expanded: false,
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
        return subjectState.subject == null
            ? 'Select subject'
            : '${subjectState.subject!.name}${subjectState.deck == null ? '' : ' - ${subjectState.deck!.name}'}';
      case EssentialWidgets.calendar:
        return "Calendar";
      case EssentialWidgets.historyError:
        return "History of all the errors";
      default:
        return "error";
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
      return const HistoryError();
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

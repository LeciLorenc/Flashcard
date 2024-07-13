import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/subject_bloc.dart';
import '../../bloc/user/authentication_bloc.dart';
import '../../constants.dart';
import '../../model/subject.dart';
import '../../presentation/education_icons.dart';
import '../../service/local_repository_service.dart';
import '../../widget/adaptable_button.dart';
import '../../widget/logoutButton.dart';
import '../enumParamountWidgets.dart';
import 'home_page.dart';

class SubjectSelection extends StatelessWidget {
  const SubjectSelection({
    super.key,
    required this.subjects,
    this.expanded = true,
  });

  final List<Subject> subjects;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data : Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: primaryColor,
            background: secondaryColor
          ),),
      child: ListView(
        children:
        [
          AdaptableButton(
            onPressed: () => { whenPressed(context, EssentialWidgets.welcome), },
            icon: Icons.home,
            title: 'Home',
            expanded: expanded,
          ),
          const Divider(),
          for (Subject subject in subjects) ...[
            AdaptableButton(
              onPressed: ()
              {
                context.read<SubjectBloc>().add(SelectSubject(subject));
                if(MediaQuery.of(context).orientation == Orientation.portrait) {
                  HomePage.expanded=false;
                }
                HomePage.bodyContent = EssentialWidgets.subject;
              },
              icon: subject.icon,
              title: subject.name.length>25? '${subject.name.substring(0,25)}...' : subject.name,
              expanded: expanded,
              selected: context.read<SubjectBloc>().state.subject == subject,
            ),
          ],


          AdaptableButton(
            onPressed: () => onAddSubject(context),
            icon: Icons.add,
            title: 'Add subject',
            expanded: expanded,
          ),
          const Divider(),
          AdaptableButton(
            onPressed: () => { whenPressed(context, EssentialWidgets.calendar), },
            icon: Icons.access_time,
            title: 'Calendar',
            expanded: expanded,
          ),
          AdaptableButton(
            onPressed: () => { whenPressed(context, EssentialWidgets.playWithError),},
            icon: Icons.error,
            title: 'Play the errors',
            expanded: expanded,
          ),
          AdaptableButton(
            onPressed: () => { whenPressed(context, EssentialWidgets.historyError),},
            icon: Icons.add_chart,
            title: 'History of progress',
            expanded: expanded,
          ),
          if (kDebugMode) ...[
            const Divider(),
            AdaptableButton(
              onPressed: () => LocalRepositoryService.debug(),
              icon: Icons.info_outline,
              title: 'Debug info',
              expanded: expanded,
            ),
            AdaptableButton(
              onPressed: () =>
                  context.read<SubjectBloc>().add(DeleteAllSubjects()),
              icon: Icons.remove_outlined,
              title: 'Delete all subjects',
              expanded: expanded,
            ),
          ],

          Expanded(
            flex: 3,
            child: AdaptableButton(
              onPressed: () {
                context.read<AuthenticationBloc>().logout();
              },
              icon: Icons.logout,
              title: 'Logout',
              expanded: expanded,
            ),
          ),
        ],
      ),
    );
  }

  void whenPressed(BuildContext context,EssentialWidgets choice)
  {
    context.read<SubjectBloc>().add(SelectSubject(null));
    if(MediaQuery.of(context).orientation == Orientation.portrait) {
      HomePage.expanded=false;
    }
    HomePage.bodyContent = choice;
  }

  void onAddSubject(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    String errorMessage = '';
    IconData icon = EducationIcons.openBook;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, Function setState) {
            return AlertDialog(
              title: const Text('Create new subject'),
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
                                hintText: 'Enter the name of the subject',
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
                    String? validationResult = validateSubjectName(context, newSubjectName);

                    if (validationResult != null) {
                      setState(() {
                        errorMessage = validationResult;
                      });
                      return;
                    }


                    context.read<SubjectBloc>().add(
                      AddSubject(
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
          },
        );
      },
    );
  }


  String? validateSubjectName(BuildContext context, String name) {
    if (name.isEmpty) {
      return 'Subject name cannot be empty';
    }

    List<String> existingSubjects = context.read<SubjectBloc>().state.subjects.map((subject) => subject.name).toList();
    if (existingSubjects.contains(name)) {
      return 'Subject name already exists';
    }

    return null; // No validation errors
  }
}

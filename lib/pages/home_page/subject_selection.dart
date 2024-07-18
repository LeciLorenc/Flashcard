import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ChatGPT_services/view/minorDialogs/iconPicker_dialog.dart';
import '../../bloc/subject_bloc.dart';
import '../../bloc/user/authentication_bloc.dart';
import '../../constants.dart';
import '../../main.dart';
import '../../model/subject.dart';
import '../../presentation/education_icons.dart';
import '../../service/local_repository_service.dart';
import '../../widget/adaptable_button.dart';
import '../../widget/logoutButton.dart';
import '../enumParamountWidgets.dart';
import 'home_page.dart';

class SubjectSelection extends StatelessWidget {
  SubjectSelection({
    super.key,
    required this.subjects,
    this.expanded = true,
    required this.onThemeChanged,
  });

  final List<Subject> subjects;
  final bool expanded;
  final Function(bool) onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? darkBackgroundColor : lightBackgroundColor;
    final textColor = isDarkMode ? darkTextColor : lightTextColor;
    final iconColor = isDarkMode ? darkIconColor : lightIconColor;
    final dividerColor = isDarkMode ? Colors.white : Colors.black;

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme(
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
          primary: primaryColor,
          onPrimary: textColor,
          secondary: isDarkMode ? darkSecondaryColor : lightSecondaryColor,
          onSecondary: textColor,
          surface: backgroundColor,
          onSurface: textColor,
          error: Colors.red,
          onError: Colors.white,
          background: backgroundColor,
          onBackground: textColor,
        ),
        dividerColor: dividerColor,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: textColor,
          displayColor: textColor,
        ),
      ),
      child: Container(
        color: backgroundColor,
        child: ListView(
          children: [
            AdaptableButton(
              onPressed: () => { whenPressedSwitchEssentialWidgets(context, EssentialWidgets.welcome) },
              icon: Icons.home,
              title: 'Home',
              expanded: expanded, textColor: textColor, iconColor: iconColor,
            ),
            Divider(color: dividerColor),
            for (Subject subject in computeListSubjectToShow(subjects)) ...[
              AdaptableButton(
                onPressed: () {
                  context.read<SubjectBloc>().add(SelectSubject(subject));
                  if (MediaQuery.of(context).orientation == Orientation.portrait) {
                    HomePage.expanded = false;
                  }
                  HomePage.bodyContent = EssentialWidgets.subject;
                },
                icon: subject.icon,
                title: subject.name.length > 25 ? '${subject.name.substring(0, 25)}...' : subject.name,
                expanded: expanded,
                selected: context.read<SubjectBloc>().state.subject == subject, textColor: textColor, iconColor: iconColor,
              ),
            ],
            AdaptableButton(
              onPressed: () => onAddSubject(context),
              icon: Icons.add,
              title: 'Add subject',
              expanded: expanded, textColor: textColor, iconColor: iconColor,
            ),
            Divider(color: dividerColor),
            AdaptableButton(
              onPressed: () => { whenPressedSwitchEssentialWidgets(context, EssentialWidgets.calendar) },
              icon: Icons.access_time,
              title: 'Calendar',
              expanded: expanded, textColor: textColor, iconColor: iconColor,
            ),
            AdaptableButton(
              onPressed: () => { whenPressedSwitchEssentialWidgets(context, EssentialWidgets.playWithError) },
              icon: Icons.error,
              title: 'Play the errors',
              expanded: expanded, textColor: textColor, iconColor: iconColor,
            ),
            AdaptableButton(
              onPressed: () => { whenPressedSwitchEssentialWidgets(context, EssentialWidgets.historyError) },
              icon: Icons.add_chart,
              title: 'History of progress',
              expanded: expanded, textColor: textColor, iconColor: iconColor,
            ),
            if (kDebugMode) ...[
              Divider(color: dividerColor),
              AdaptableButton(
                onPressed: () => LocalRepositoryService.debug(),
                icon: Icons.info_outline,
                title: 'Debug info',
                expanded: expanded, textColor: textColor, iconColor: iconColor,
              ),
              AdaptableButton(
                onPressed: () => context.read<SubjectBloc>().add(DeleteAllSubjects()),
                icon: Icons.remove_outlined,
                title: 'Delete all subjects',
                expanded: expanded, textColor: textColor, iconColor: iconColor,

              ),
              AdaptableButton(
                onPressed: () => { whenPressedSwitchEssentialWidgets(context, EssentialWidgets.settings) },
                icon: Icons.settings,
                title: 'Settings',
                expanded: expanded, textColor: textColor, iconColor: iconColor,

              ),
              AdaptableButton(
                onPressed: () {
                  context.read<SubjectBloc>().add(BackupData(FirebaseAuth.instance.currentUser!.uid));
                },
                icon: Icons.backup,
                title: 'Backup Data Full',
                expanded: expanded,
                textColor: textColor,
                iconColor: iconColor,
              ),
              AdaptableButton(
                onPressed: () {
                  context.read<SubjectBloc>().add(RestoreData(FirebaseAuth.instance.currentUser!.uid));
                },
                icon: Icons.restore,
                title: 'Restore Data Full',
                expanded: expanded,
                textColor: textColor,
                iconColor: iconColor,  ),

            ],
            AdaptableButton(
              onPressed: () {
                context.read<AuthenticationBloc>().logout();
              },
              icon: Icons.logout,
              title: 'Logout',
              expanded: expanded, textColor: textColor, iconColor: iconColor,
            ),
          ],
        ),
      ),
    );
  }

  void whenPressedSwitchEssentialWidgets(BuildContext context, EssentialWidgets choice) {
    context.read<SubjectBloc>().add(SelectSubject(null));
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      HomePage.expanded = false;
    }
    HomePage.bodyContent = choice;
  }

  void onAddSubject(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? darkTextColor : lightTextColor;
    final iconColor = isDarkMode ? darkIconColor : lightIconColor;

    TextEditingController textEditingController = TextEditingController();
    String errorMessage = '';
    IconData icon = Icons.book;
    IconData iconForSubject = EducationIcons.openBook;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, Function setState) {
            return AlertDialog(
              title: Text('Create new subject', style: TextStyle(color: textColor)),
              content: Flex(
                direction: Axis.vertical,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(icon, color: iconColor),
                        onPressed: () async {},
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration:  InputDecoration(
                            hintText: 'Enter the name of the subject',
                            hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                          ),
                          controller: textEditingController,
                          style: TextStyle(color: textColor),
                        ),
                      ),

                    ],
                  ),

                  Row (mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 8),
                        Icon(iconForSubject),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            showIconPickerDialog(context, (IconData newValue) {
                              iconForSubject = newValue;
                              setState(() {
                                iconForSubject = newValue;
                              });
                            });
                          },
                          child: const Text('Change'),
                        ),

                      ]
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
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: Text('Cancel', style: TextStyle(color: textColor)),
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
                        icon: iconForSubject,
                        user_id: globalUserId,
                      ),
                    );

                    Navigator.pop(context, 'OK');
                  },
                  child: Text('OK', style: TextStyle(color: textColor)),
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

    List<String> existingSubjects =
    context.read<SubjectBloc>().state.subjects.map((subject) => subject.name).toList();
    if (existingSubjects.contains(name)) {
      return 'Subject name already exists';
    }

    return null; // No validation errors
  }

  List<Subject> computeListSubjectToShow(List<Subject> list) {
    List<Subject> listFilteredByUser = [];
    for (Subject subject in list) {
      if (subject.user_id == globalUserId) {
        listFilteredByUser.add(subject);
      }
    }
    return listFilteredByUser;
  }
}

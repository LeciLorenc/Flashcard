import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/subject_bloc.dart';
import '../../model/subject.dart';
import '../../presentation/education_icons.dart';
import '../../service/local_repository_service.dart';
import '../../widget/adaptable_button.dart';
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

  void whenPressed(BuildContext context,EssentialWidgets choice)
  {
    context.read<SubjectBloc>().add(SelectSubject(null));
    if(MediaQuery.of(context).orientation == Orientation.portrait) {
      HomePage.expanded=false;
    }
    HomePage.bodyContent = choice;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
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
            title: subject.name,
            expanded: expanded,
            selected: context.read<SubjectBloc>().state.subject == subject,
          ),
        ],

        const Divider(),
        AdaptableButton(
          onPressed: () => onAddSubject(context),
          icon: Icons.add,
          title: 'Add subject',
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
          AdaptableButton(
            onPressed: () => { whenPressed(context, EssentialWidgets.calendar), },
            icon: Icons.access_time,
            title: 'Calendar',
            expanded: expanded,
          ),
          AdaptableButton(
            onPressed: () => { whenPressed(context, EssentialWidgets.historyError),},
            icon: Icons.add_chart,
            title: 'History of progress',
            expanded: expanded,
          ),
        ]
      ],
    );
  }

  void onAddSubject(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

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
                          // Implement your custom icon picker logic here
                          // Example: You can show a dialog with a list of icons to choose from
                          // After the user selects an icon, update the 'icon' variable
                          // You can use IconData to represent the selected icon
                          // implement the logic to update the 'icon' variable  here

                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Enter the name of the subject',
                          ),
                          controller: textEditingController,
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
}



// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_iconpicker/flutter_iconpicker.dart';
// import '../../bloc/subject_bloc.dart';
// import '../../model/subject.dart';
// import '../../presentation/education_icons.dart';
// import '../../service/local_repository_service.dart';
// import '../../widget/adaptable_button.dart';
//
// class SubjectSelection extends StatelessWidget {
//   const SubjectSelection({
//     super.key,
//     required this.subjects,
//     this.expanded = true,
//   });
//
//   final List<Subject> subjects;
//   final bool expanded;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: [
//         for (Subject subject in subjects) ...[
//           AdaptableButton(
//             onPressed: () =>
//                 context.read<SubjectBloc>().add(SelectSubject(subject)),
//             icon: subject.icon,
//             title: subject.name,
//             expanded: expanded,
//             selected: context.read<SubjectBloc>().state.subject == subject,
//           ),
//         ],
//         const Divider(),
//         AdaptableButton(
//           onPressed: () => onAddSubject(context),
//           icon: Icons.add,
//           title: 'Add subject',
//           expanded: expanded,
//         ),
//         if (kDebugMode) ...[
//           const Divider(),
//           AdaptableButton(
//             onPressed: () => LocalRepositoryService.debug(),
//             icon: Icons.info_outline,
//             title: 'Debug info',
//             expanded: expanded,
//           ),
//           AdaptableButton(
//             onPressed: () =>
//                 context.read<SubjectBloc>().add(DeleteAllSubjects()),
//             icon: Icons.remove_outlined,
//             title: 'Delete all subjects',
//             expanded: expanded,
//           ),
//         ]
//       ],
//     );
//   }
//
//   void onAddSubject(BuildContext context) {
//     TextEditingController textEditingController = TextEditingController();
//
//     showDialog<String>(
//       context: context,
//       builder: (BuildContext context) {
//         IconData icon = EducationIcons.openBook;
//
//         return StatefulBuilder(
//           builder: (BuildContext context, Function setState) {
//             return AlertDialog(
//               title: const Text('Create new subject'),
//               content: Flex(
//                 direction: Axis.vertical,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   AdaptableButton(
//                     onPressed: () async {
//                       IconData? newIcon =
//                           await FlutterIconPicker.showIconPicker(context,
//                               iconPackModes: [IconPack.custom],
//                               customIconPack: EducationIcons.icons);
//
//                       setState(() {
//                         icon = newIcon;
//                       });
//                                         },
//                     icon: icon,
//                     expanded: true,
//                     title: 'Select icon',
//                   ),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   TextField(
//                     decoration: const InputDecoration(
//                       hintText: 'Enter the name of the subject',
//                     ),
//                     controller: textEditingController,
//                   ),
//                 ],
//               ),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () => Navigator.pop(context, 'Cancel'),
//                   child: const Text('Cancel'),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     context.read<SubjectBloc>().add(
//                           AddSubject(
//                             name: textEditingController.text,
//                             icon: icon,
//                           ),
//                         );
//
//                     Navigator.pop(context, 'OK');
//                   },
//                   child: const Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }

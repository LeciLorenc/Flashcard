import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/subject_bloc.dart';
import '../../../model/deck.dart';
import '../../../model/subject.dart';
import '../../../presentation/education_icons.dart';
import '../../../widget/adaptable_button.dart';
import '../../play_page/play_page.dart';

class DeckSelection extends StatelessWidget {
  const DeckSelection({
    super.key,
    required this.subject,
  });

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final Deck deck in subject.decks) ...[
          ListTile(
            leading: Icon(deck.icon),
            title: Text(deck.name),
            subtitle: Text('${deck.flashcards.length} cards'),
            trailing: Row(
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
                  onPressed: () => onDeleteDeck(context, deck),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
        ListTile(
          onTap: () => onAddDeck(context),
          leading: const Icon(Icons.add),
          title: const Text('Add deck'),
        )
      ],
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
            onPressed: () {
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

    IconData icon = EducationIcons.openBook;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
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
                      // Implement your custom icon picker logic here
                      // Example: You can show a dialog with a list of icons to choose from
                      // After the user selects an icon, update the 'icon' variable
                      // You can use IconData to represent the selected icon
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter the name of the deck',
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
      },
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_iconpicker/flutter_iconpicker.dart';
//
// import '../../../bloc/subject_bloc.dart';
// import '../../../model/deck.dart';
// import '../../../model/subject.dart';
// import '../../../presentation/education_icons.dart';
// import '../../../widget/adaptable_button.dart';
// import '../../play_page/play_page.dart';
//
// class DeckSelection extends StatelessWidget {
//   const DeckSelection({
//     super.key,
//     required this.subject,
//   });
//
//   final Subject subject;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: [
//         for (final Deck deck in subject.decks) ...[
//           ListTile(
//             leading: Icon(deck.icon),
//             title: Text(deck.name),
//             subtitle: Text('${deck.flashcards.length} cards'),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   tooltip: 'Play',
//                   onPressed: deck.flashcards.isEmpty
//                       ? null
//                       : () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (BuildContext context) => PlayPage(
//                                 subject: subject,
//                                 deck: deck,
//                               ),
//                             ),
//                           ),
//                   icon: const Icon(Icons.play_arrow_outlined),
//                 ),
//                 const SizedBox(width: 16.0),
//                 IconButton(
//                   tooltip: 'View',
//                   icon: const Icon(Icons.visibility_outlined),
//                   onPressed: () => context.read<SubjectBloc>().add(SelectDeck(
//                         deck,
//                         visualize: true,
//                       )),
//                 ),
//                 const SizedBox(width: 16.0),
//                 IconButton(
//                   tooltip: 'Edit',
//                   icon: const Icon(Icons.edit_outlined),
//                   onPressed: () => context.read<SubjectBloc>().add(SelectDeck(
//                         deck,
//                         visualize: false,
//                       )),
//                 ),
//                 const SizedBox(width: 16.0),
//                 IconButton(
//                   tooltip: 'Delete',
//                   icon: const Icon(Icons.delete_outlined),
//                   onPressed: () => onDeleteDeck(context, deck),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(),
//         ],
//         ListTile(
//           onTap: () => onAddDeck(context),
//           leading: const Icon(Icons.add),
//           title: const Text('Add deck'),
//         )
//       ],
//     );
//   }
//
//   void onDeleteDeck(BuildContext context, Deck deck) {
//     showDialog<String>(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         title: const Text('Delete deck'),
//         content: const Text('Are you sure you want to delete this deck?'),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () => Navigator.pop(context, 'Cancel'),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               context.read<SubjectBloc>().add(
//                     DeleteDeck(
//                       deck: deck,
//                     ),
//                   );
//
//               Navigator.pop(context, 'OK');
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void onAddDeck(BuildContext context) {
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
//               title: const Text('Create new deck'),
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
//                       hintText: 'Enter the name of the deck',
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
//                           AddDeck(
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

import 'package:flutter/material.dart';
import 'package:flashcard/presentation/education_icons.dart';

List<IconData> myIcons = [
  Icons.home,
  Icons.star,
  Icons.favorite,
  Icons.shopping_cart,
  Icons.shopping_bag,
  Icons.science,
  Icons.sports,
  Icons.account_balance,
  Icons.add,
  Icons.calculate,
  Icons.language,
  Icons.history,
  Icons.explore,
  Icons.palette,
  Icons.music_note,
  Icons.directions_run,
  Icons.computer,
  Icons.menu_book,
  Icons.bug_report,
  Icons.attach_money,
  Icons.psychology,
  Icons.group,
  Icons.lightbulb,
  Icons.thumbs_up_down,
  Icons.theaters,
  Icons.translate,
  Icons.create,
  Icons.library_books,
  Icons.edit,
  Icons.spellcheck,
  Icons.table_chart,
  Icons.functions,
  Icons.category,
  Icons.calculate,
  Icons.functions,
  Icons.analytics,
  Icons.threesixty,
  Icons.local_florist,
  Icons.nature_people,
  Icons.accessibility,
  Icons.eco,
  Icons.nightlight_round,
  Icons.cloud,
  Icons.engineering,
  Icons.apartment,
  Icons.access_time_filled,
  Icons.account_circle,
  Icons.adb,
  Icons.add_alert,
  EducationIcons.arts,
  EducationIcons.astronomy,
  EducationIcons.atom,
  EducationIcons.boyGraduation,
  EducationIcons.bag,
  EducationIcons.bookApple,

  EducationIcons.biology,
  EducationIcons.boyStudent,
  EducationIcons.bookPen,
  EducationIcons.certificate,
  EducationIcons.calculator,
  EducationIcons.compass,
  EducationIcons.clock,
  EducationIcons.chemistry,
  EducationIcons.deskChair,
  EducationIcons.discussionClass,
  EducationIcons.energyEquivalency,
  EducationIcons.femaleTeacher,
  EducationIcons.girlGraduation,
  EducationIcons.girlStudent,
  EducationIcons.graduationCap,
  EducationIcons.geology,
  EducationIcons.geometric,
  EducationIcons.language,
  EducationIcons.libraryIcon,
  EducationIcons.locker,
  EducationIcons.maleTeacher,
  EducationIcons.math,
  EducationIcons.momentum,
  EducationIcons.music,
  EducationIcons.notebook,
  EducationIcons.notes,
  EducationIcons.numeracy,
  EducationIcons.onlineLearning,
  EducationIcons.openBook,
  EducationIcons.pdf,
  EducationIcons.presentation,
  EducationIcons.school,
  EducationIcons.schoolBus,
  EducationIcons.sport,
  EducationIcons.squareRoot,
  EducationIcons.studentQuestion,
  EducationIcons.studyLamp,
  EducationIcons.teacherDesk,
  EducationIcons.teaching,
  EducationIcons.test,
  EducationIcons.theatre,
  EducationIcons.tools,
  EducationIcons.trophy,
  EducationIcons.tutorial,
  // Aggiungi altre icone secondo necessità
];

showIconPickerDialog(BuildContext context, Function(IconData) onIconSelected) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return IconPickerDialog(
        icons: myIcons,
        onIconSelected: onIconSelected,
      );
    },
  );
}

class IconPickerDialog extends StatelessWidget {
  final List<IconData> icons;
  final Function(IconData) onIconSelected;

  const IconPickerDialog({
    super.key,
    required this.icons,
    required this.onIconSelected,
  });
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SizedBox(
        height: 190,
        width: 200,
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                ),
                itemCount: icons.length,
                itemBuilder: (context, index) {
                  final icon = icons[index];
                  return GestureDetector(
                    onTap: () {
                      onIconSelected(icon);
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      width: 4, // Larghezza dell'icona
                      height: 4, // Altezza dell'icona
                      child: Icon(icon),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}
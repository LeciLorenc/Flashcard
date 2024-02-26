import 'package:flashcard/constants.dart';
import 'package:flashcard/input/selection/selection_element.dart';
import 'package:flashcard/input/show_text.dart';
import 'package:flashcard/utils/utils.dart';
import 'package:flutter/material.dart';

class Selection extends StatelessWidget {
  const Selection({
    super.key,
    required this.elements,
    this.onChanged,
    this.direction = Axis.horizontal,
    this.spacing = spaceBetweenWidgets,
    this.title,
    this.errorTitle,
    this.error = false,
  });

  final List<SelectionElement> elements;
  final Function(int)? onChanged;
  final Axis direction;
  final double spacing;
  final String? title;
  final bool error;
  final String? errorTitle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              error ? errorTitle ?? title! : title!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: error
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).primaryColor,
              ),
            ),
          if (title != null) const Divider(),
          Wrap(
            direction: direction,
            runSpacing: spacing,
            spacing: spacing,
            children: elements.map(
              (element) {
                return ShowText(
                  wight: (constraints.maxWidth -
                          spacing * ((isWide(constraints) ? 4 : 2) - 1)) /
                      (isWide(constraints) ? 4 : 2),
                  onPressed: () {
                    if (onChanged == null) return;
                    onChanged!(elements.indexOf(element));
                  },
                  centerText: true,
                  backgroundColor: (error
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).primaryColor)
                      .withOpacity(element.selected ? .26 : .12),
                  leadingIcon: element.icon,
                  text: element.name,
                );
              },
            ).toList(),
          ),
        ],
      );
    });
  }
}

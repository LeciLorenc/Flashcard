import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../main.dart';
import '../historyErrorViewModel.dart';


typedef OrderingCallback = void Function(String ordering);
class OrderMenu extends StatefulWidget {
  final OrderingCallback orderingCallback;

  const OrderMenu({Key? key, required this.orderingCallback}) : super(key: key);

  @override
  _OrderMenuState createState() => _OrderMenuState();
}

class _OrderMenuState extends State<OrderMenu> {
  String? selectedOrdering = OrderingEnum.dateDecrease.toString();

  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).size.width>400) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              buildButton("By Subject Name (A-Z)", OrderingEnum.subjectNameAZ.toString()),
              const SizedBox(height: 6),
              buildButton("By Subject Name (Z-A)", OrderingEnum.subjectNameZA.toString()),
              const SizedBox(height: 6),

            ],
          ),
          SizedBox(width: 20,),
          Column(
            children: [
              buildButton("By Deck Name (A-Z)", OrderingEnum.deckNameAZ.toString()),
              const SizedBox(height: 6),
              buildButton("By Deck Name (Z-A)", OrderingEnum.deckNameZA.toString()),
              const SizedBox(height: 6),

            ],
          ),
          SizedBox(width: 20,),
          Column(
            children: [
              buildButton("By Date (Increasing)", OrderingEnum.dateIncrease.toString()),
              const SizedBox(height: 6),
              buildButton("By Date (Decreasing)", OrderingEnum.dateDecrease.toString()),
              const SizedBox(height: 6),
            ],
          )

        ],
      );
    }
    else
      {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton("By Subject Name (A-Z)", OrderingEnum.subjectNameAZ.toString()),
            const SizedBox(height: 6),
            buildButton("By Subject Name (Z-A)", OrderingEnum.subjectNameZA.toString()),
            const SizedBox(height: 6),
            buildButton("By Deck Name (A-Z)", OrderingEnum.deckNameAZ.toString()),
            const SizedBox(height: 6),
            buildButton("By Deck Name (Z-A)", OrderingEnum.deckNameZA.toString()),
            const SizedBox(height: 6),
            buildButton("By Date (Increasing)", OrderingEnum.dateIncrease.toString()),
            const SizedBox(height: 6),
            buildButton("By Date (Decreasing)", OrderingEnum.dateDecrease.toString()),
          ],
        );

    }
  }

  Widget buildButton(String label, String ordering) {


    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedOrdering = ordering;
        });
        widget.orderingCallback(ordering);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (selectedOrdering == ordering) {
            return isDark? backgroundButtonColorDark: backgroundButtonColorLight ; // Change to light blue when selected
          } else {
            return Colors.white; // Change to white when not selected
          }
        }),
      ),
      child: Row(
        children: [
          Text(label),
        ],
      ),
    );
  }
}

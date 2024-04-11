import 'package:flutter/material.dart';

class NumberManipulationWidget extends StatefulWidget {
  final void Function(int) onNumberChanged;

  const NumberManipulationWidget({Key? key, required this.onNumberChanged}) : super(key: key);

  @override
  _NumberManipulationWidgetState createState() => _NumberManipulationWidgetState();
}

class _NumberManipulationWidgetState extends State<NumberManipulationWidget> {
  int _number = 5;

  void _increment() {
    setState(() {
      _number++;
      widget.onNumberChanged(_number); // Notify the parent about the change
    });
  }

  void _decrement() {
    setState(() {
      _number--;
      widget.onNumberChanged(_number); // Notify the parent about the change
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _decrement,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(3, 3),
            padding: const EdgeInsets.all(2),
          ),
          child: const Icon(Icons.remove),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '$_number',
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
        ElevatedButton(
          onPressed: _increment,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(3, 3),
            padding: const EdgeInsets.all(2),
          ),
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}

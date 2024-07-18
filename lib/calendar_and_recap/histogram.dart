import 'package:flutter/material.dart';

import '../constants.dart';
import '../main.dart';

class Histogram extends StatelessWidget {
  final List<int> points; // Lista dei punti di ogni giorno
  final List<String> labels; // Etichette sull'asse delle ascisse
  final List<int> maxTotal; // Valore massimo sull'asse delle ordinate

  Histogram({required this.points, required this.labels, required this.maxTotal});


  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(300, 300),
      painter: HistogramPainter(pointsDone: points, labels: labels, maxTotal: maxTotal),
    );
  }
}

class HistogramPainter extends CustomPainter {
  final List<int> pointsDone;
  final List<String> labels;
  final List<int> maxTotal;


  HistogramPainter({required this.pointsDone, required this.labels, required this.maxTotal});



  int maxOfTheTotal(){
      if (maxTotal.isEmpty) {
        throw Exception("La lista è vuota");
      }

      int massimo = maxTotal[0];
      for (int i = 1; i < maxTotal.length; i++) {
        if (maxTotal[i] > massimo) {
          massimo = maxTotal[i];
        }
      }
      return massimo;
  }


  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()..color = isDark ? darkBackgroundColor : lightBackgroundColor;
    Paint columnPaint = Paint()..color = Colors.blue;
    Paint redColumnPaint = Paint()..color = Colors.orange;
    Paint linePaint = Paint()..color = isDark ? lightTextColor : darkTextColor;
    double columnWidth = size.width / pointsDone.length;
    double maxColumnHeight = size.height; // Maximum column height

    // Draw background rounded rectangle
    RRect backgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(-5, -5, size.width + 10, size.height + 10),
      const Radius.circular(5.0), // Adjust the radius to change the roundness of the corners
    );
    canvas.drawRRect(backgroundRect, backgroundPaint);

    // Draw X-axis labels
    List<int> xLabels = [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30]; // Desired X-axis labels
    for (int i = 0; i < labels.length; i++) {
      if (!xLabels.contains(i)) continue; // Skip labels not in the xLabels list

      TextPainter textPainter = TextPainter(
        text: TextSpan(text: labels[i], style:  TextStyle(fontSize: 10, color: isDark ? darkTextColor: lightTextColor)),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(i * columnWidth, size.height + 10));
    }

    // Draw Y-axis labels
    int k = maxOfTheTotal();
    int maxIndexValue = k > 5 ? k : 5;
    double offsetForLeftAxisLabel = -12;

    for (int i = 1; i <= maxIndexValue; i++) { // Start from 1 instead of 0
      TextPainter textPainter = TextPainter(
        text: TextSpan(text: i.toString(), style:  TextStyle(fontSize: 10, color: isDark ? darkTextColor: lightTextColor)),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(offsetForLeftAxisLabel, size.height - (i * maxColumnHeight / maxIndexValue) - 5));
    }

    double columnSpacing = 3.0; // Adjust this value to increase/decrease the space between columns
    double totalSpacing = columnSpacing * (pointsDone.length - 1); // Total space taken by the gaps between columns
    double totalColumnWidth = size.width - totalSpacing; // Total width available for columns after considering the gaps
    double finalColumnWidth = totalColumnWidth / pointsDone.length; // Adjusted width of each column

    for (int i = 0; i < pointsDone.length; i++) {
      if (pointsDone[i] == 0) continue; // Skip drawing if pointsDone[i] is 0

      double columnX = i * (finalColumnWidth + columnSpacing); // Adjusted X position for the column
      double columnHeight = (pointsDone[i] / maxOfTheTotal()) * maxColumnHeight;

      RRect columnRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(columnX, size.height - columnHeight, finalColumnWidth, columnHeight),
        Radius.circular(2.0), // Adjust the radius to change the roundness of the corners
      );
      canvas.drawRRect(columnRect, columnPaint);

      double orangeColumnHeight = ((maxTotal[i] - pointsDone[i]) / maxOfTheTotal()) * maxColumnHeight;
      RRect orangeColumnRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(columnX, size.height - (orangeColumnHeight + columnHeight), finalColumnWidth, orangeColumnHeight),
        Radius.circular(2.0), // Adjust the radius to change the roundness of the corners
      );

      canvas.drawRRect(orangeColumnRect, redColumnPaint);
    }
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
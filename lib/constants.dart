import 'package:flashcard/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

List<Map<String, String>> defaultActivities(BuildContext context) => [
      {
        'name': S.of(context).park,
        'value': 'park',
      },
      {
        'name': S.of(context).swim,
        'value': 'swim',
      },
      {
        'name': S.of(context).run,
        'value': 'run',
      },
      {
        'name': S.of(context).liveLocation,
        'value': 'live_location',
      },
    ];

const double spaceBetweenWidgets = 20;
const LatLng polimi = LatLng(45.47810857587293, 9.227247297082284);

//
// const Color primaryColor = Color(0xFF007AFF);
// const Color secondaryColor =  Color(0xFFFF9500);
// const Color backGroundColor = Color(0xFFF5F5F5);
// const Color surfaceColor = Color(0xFFFFFFFF);
// const Color errorColor = Color(0xFFFF3B30);
// const Color onPrimaryColor = Color(0xFFFFFFFF);
// const Color onSecondaryColor = Color(0xFFFFFFFF);
// const Color onBackgroundColor = Color(0xFF000000);
// const Color onSurfaceColor = Color(0xFF000000);


const Color lightPrimaryColor = Color(0xFF4FA95E);
const Color darkPrimaryColor = Color(0xFFFFFFFF);
// Primary Color
const Color primaryColor = Color(0xFF0B7E11);

// Background Colors
const Color lightBackgroundColor = Color(0xFFFFFFFF);
const Color darkBackgroundColor = Color(0xD5121212);

// Secondary Colors
const Color lightSecondaryColor = Color(0xFFF5F5F5);
const Color darkSecondaryColor = Color(0xFF1F1F1F);

// Surface Colors
const Color lightSurfaceColor = Color(0xFFE0E0E0);
const Color darkSurfaceColor = Color(0xFF333333);

// Error Colors
const Color errorColor = Color(0xFFB00020);

// On Colors
const Color lightOnPrimaryColor = Color(0xFFFFFFFF);
const Color darkOnPrimaryColor = Color(0xFF000000);
const Color lightOnSecondaryColor = Color(0xFF000000);
const Color darkOnSecondaryColor = Color(0xFFFFFFFF);
const Color lightOnBackgroundColor = Color(0xFF000000);
const Color darkOnBackgroundColor = Color(0xFFFFFFFF);
const Color lightOnSurfaceColor = Color(0xFF000000);
const Color darkOnSurfaceColor = Color(0xFFFFFFFF);


// AppBar Colors
const Color lightAppBarColor = Color(0xFFFFFFFF);
const Color darkAppBarColor = Color(0xFF121212);


// Text Colors
const Color lightTextColor = Color(0xFF000000);
const Color darkTextColor = Color(0xFFFFFFFF);

// Icon Colors
const Color lightIconColor = Color(0xFF4FA95E);
const Color darkIconColor = Color(0xFF4FA95E);


//button COlors
const Color backgroundButtonColorLight=Color(0xFFE9FCEC);
const Color backgroundButtonColorDark=Color(0xF0B7E3BA);

//choose button
const Color chooseButtonColorLight=Color(0xFFAFF5BA);
const Color chooseButtonColorDark=Color(0x90AAECAD);

//shading text
const Color shade1dark= Colors.black54;
const Color shade2dark= Colors.black87;
const Color shade1light= Colors.white60;
const Color shade2light= Colors.white54;

MaterialColor createColors(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}



//
// const Color primaryColor = Color(0xFF287762);
// const Color secondaryColor = Colors.red;
//
//
// // const Color secondaryColor = Color(0xffa0faa9);
// const Color backGroundColor = Color(0xffeefdf2);


const Color dividerColor = Color(0xffe1e7e1);

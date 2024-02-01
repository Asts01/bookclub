import 'package:flutter/material.dart';

class ourTheme{
  Color lightGreen=Color.fromARGB(255, 213, 235, 220);

  ThemeData buildTheme(){
    return ThemeData(
      canvasColor: lightGreen,
    );
  }
}
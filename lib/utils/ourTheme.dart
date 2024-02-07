import 'package:flutter/material.dart';

class ourTheme{
  Color lightGreen=Color.fromARGB(255, 213, 235, 220);

  ThemeData buildTheme(){
    return ThemeData(
      canvasColor: lightGreen,
    );
  }
  var kSendButtonTextStyle = TextStyle(
    color: Color(0xFF679289),
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
  );
  var kMessageTextFieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    hintText: 'Type your message here...',
    border: InputBorder.none,
  );
  var kMessageContainerDecoration = BoxDecoration(
    border: Border(
      top: BorderSide(color: Colors.black, width: 2.0),
    ),
  );

}
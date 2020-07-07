
import 'package:flutter/material.dart';

class TextColors {
  static Color accentColor = Color.fromRGBO(92, 0, 92, 1);
}

class TextSettings {

  static Text titleOneCenter (String _inputText){
    return Text(_inputText, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, ), textAlign: TextAlign.center,);
  }

}
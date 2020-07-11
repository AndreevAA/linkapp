
import 'package:flutter/material.dart';

class TextColors {
  static Color accentColor = Color.fromRGBO(157, 68, 254, 1);

  static Color descriptionColor = Colors.grey;

  static Color deactivatedColor = Colors.grey;

  static Color activeColor = Colors.green;

  static Color enjoyColor = Colors.blue;
}

class TextSettings {

  static Text titleZeroCenter (String _inputText){
    return Text(_inputText, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0, ), textAlign: TextAlign.center,);
  }

  static Text titleOneCenter (String _inputText){
    return Text(_inputText, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 28.0, ), textAlign: TextAlign.center,);
  }

  static Text titleTwoCenter (String _inputText){
    return Text(_inputText, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0, ), textAlign: TextAlign.center,);
  }

  static Text titleTenCenter (String _inputText){
    return Text(_inputText, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10.0, ), textAlign: TextAlign.center,);
  }

  static Text titleTwoLeft (String _inputText){
    return Text(_inputText, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0, ), textAlign: TextAlign.left,);
  }

  static Text descriptionOneLeft (String _inputText){
    return Text(_inputText, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0, color: TextColors.descriptionColor), textAlign: TextAlign.left,);
  }

  static Text descriptionTwoCenter (String _inputText){
    return Text(_inputText, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0, ), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,);
  }

  static Text descriptionFourCenter (String _inputText){
    return Text(_inputText, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10.0, ), textAlign: TextAlign.center,);
  }

  static Text buttonNameTwoCenter (String _inputText){
    return Text(_inputText, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.0, color: Colors.white), textAlign: TextAlign.center,);
  }
}

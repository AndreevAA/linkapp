import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/Settings/textStyleSettings.dart';

class HelpBlockScreen extends StatefulWidget{

  @override
  _HelpBlockScreenState createState() => _HelpBlockScreenState();

}

class _HelpBlockScreenState extends State<HelpBlockScreen>{

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}



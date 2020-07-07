import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/Settings/textStyleSettings.dart';

class DialogsScreen extends StatefulWidget{

  @override
  _DialogsScreenState createState() => _DialogsScreenState();

}

class _DialogsScreenState extends State<DialogsScreen>{

  @override
  void initState() {
  }

  //print("sfssd");

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
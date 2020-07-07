import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/Settings/textStyleSettings.dart';

class ProfileScreen extends StatefulWidget{

  @override
  _ProfileScreenState createState() => _ProfileScreenState();

}

class _ProfileScreenState extends State<ProfileScreen>{

  Container getCircleAvatar(){
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 0, 0, 10),
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey,
        child: Text("АА", style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0)),) ,
        foregroundColor: Colors.white,
      ),
    );
  }

  Container getUserName(_inputName){
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
        child: TextSettings.titleOneCenter(_inputName)
    );
  }

  Container getUserSurname(_inputSurname){
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
        child: TextSettings.titleOneCenter(_inputSurname)
    );
  }

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

            // Получение аватара пользователя
            getCircleAvatar(),

            // Получение имени пользователя
            getUserName("Александр"),

            // Получение фамилии пользователя
            getUserSurname("Андреев"),

          ],
        ),
      ),
    );
  }
}
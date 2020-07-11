import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:linkapp/Screens/profileScreen.dart';
import 'package:linkapp/Service/FBManager.dart';

import 'LogsView.dart';

class AccountSettings extends StatefulWidget {
  @override
  _AccountSettings createState() => _AccountSettings();
}

class _AccountSettings extends  State<AccountSettings> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(

        appBar: AppBar(
          title: Container(
              child:  InkWell(
                onLongPress: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Logs())),
                child: Text('  Настройки', style: TextStyle(color: Colors.black),),
              )
          ),
          leading: BackButton(color: Colors.black, onPressed: (){print("Closing"); Navigator.of(context).pop();},),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
          ],
        ),
        body: Container(
          child: Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: new ListView(
                  children: <Widget>[

                    // Название блока Аккаунт
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        "АККАУНТ", textAlign: TextAlign.left, style: TextStyle(
                        color: Colors.black, fontSize: 12, fontWeight: FontWeight.w300,
                      ),
                      ),
                    ),

                    SizedBox(height: 15,),

                    // Название блок Действия с аккаунтом
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        "Действия с аккаунтом", textAlign: TextAlign.left, style: TextStyle(
                        color: Colors.black, fontSize: 14,
                      ),
                      ),
                    ),

                    // Кнопка деактивации аккаунта
                    Row(children: <Widget>[
                      Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: FlatButton(
                            child: Text('Выйти ' ?? 'Ошибка заголовка', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.red),textAlign: TextAlign.start,),
                            onPressed: () {
                              ProfileScreen.exitUser(context);
                            },
                          )
                      ),
                    ]),

                    SizedBox(height: 100,),
                  ]
              )
          ),
        )
    );
  }
}

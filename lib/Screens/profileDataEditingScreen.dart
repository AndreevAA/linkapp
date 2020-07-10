import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:linkapp/Service/DataBaseNamings.dart';
import 'package:linkapp/Service/FBManager.dart';
import 'package:linkapp/Service/UserSettings.dart';
import 'package:linkapp/Settings/blockStyleSettings.dart';

import '../main.dart';
import 'LogsView.dart';

class ProfileDataEditing extends StatefulWidget {
  @override
  _ProfileDataEditing createState() => _ProfileDataEditing();
}

class UserInputDataVerification {
  static String _allCapitalsRus =
      "абвгдеёжзийклмнопрстуфхцчшщъыьэюя1234567890-+_><?:!.,;()/*@#=][}{`~₽ AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvXxYyZz";

  // Верификация значения имени
  static bool isInputNameRight(String _name) {
    bool answer = true;

    // Проверка на длину
    if (_name.length >= 32)
      answer = false;

    // Провека на инвалидность введенного имени
    else if (_name.length >= 2) {
      for (int i = 0; i < _name.length; i++) {
        if (i == 0) {
          if (_name[0] == _name[0].toLowerCase()) {
            answer = false;
            break;
          }
        } else {
          bool meetFlag = false;
          if (_name[i] == "-" || _name[i] == " ")
            meetFlag = true;
          else {
            for (int j = 0; j < _allCapitalsRus.length; j++) {
              if (_name[i].toLowerCase() == _allCapitalsRus[j]) {
                meetFlag = true;
                break;
              }
            }
          }
          if (meetFlag == false) {
            answer = false;
            break;
          }
        }
      }
    }

    return answer;
  }

  // Верификация значения фамилии
  static bool isInputSurnameRight(String _surname) {
    bool answer = true;

    // Проверка на длину
    if (_surname.length >= 32)
      answer = false;

    // Проверка на корректность введенной фамилии
    else if (_surname.length >= 2) {
      for (int i = 0; i < _surname.length; i++) {
        if (i == 0) {
          if (_surname[0] == _surname[0].toLowerCase()) {
            answer = false;
            break;
          }
        } else {
          bool meetFlag = false;
          if (_surname[i] == "-" || _surname[i] == " ")
            meetFlag = true;
          else {
            for (int j = 0; j < _allCapitalsRus.length; j++) {
              if (_surname[i].toLowerCase() == _allCapitalsRus[j]) {
                meetFlag = true;
                break;
              }
            }
          }
          if (meetFlag == false) {
            answer = false;
            break;
          }
        }
      }
    }

    return answer;
  }

  // Верификация значения даты рождения
  static bool isInputBirthday(String _birthday) {
    bool answer = true;

    DateTime date = DateTime.now();

    // Проверка на длину
    if (date.year - int.parse(_birthday) <= 4) answer = false;

    return answer;
  }
}

class _ProfileDataEditing extends State<ProfileDataEditing> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _name, _surname, _gender, _country, _birthday, _patent, _status;
  TextEditingController dateCtl;

  _ProfileSettings(DocumentSnapshot document) {
    // Переменны, которые выводятся в полях заполения при заполнении. Обновляются при закполнении ячейки
    _name = (document['name'] ?? 'null').toString();
    _surname = (document['surname'] ?? 'null').toString();
    _gender = UserSettings.userDocument['gender'].toString();
    _country = UserSettings.userDocument['country'].toString();
    _birthday = UserSettings.userDocument['birthday'].toString();
    _patent = UserSettings.userDocument['patent'].toString();
    dateCtl = TextEditingController();
  }

  bool _loading = false;

  Future<dynamic> showConfirmation(BuildContext context) {
    if (UserInputDataVerification.isInputNameRight(_name) == true &&
        UserInputDataVerification.isInputSurnameRight(_surname) == true &&
        UserInputDataVerification.isInputBirthday(_birthday) == true) {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              title: Text(
                'Вы уверены, что хотите обновить данные?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: new FlatButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Text(
                          "Нет",
                          style: TextStyle(color: Colors.red),
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: _loading
                        ? CircularProgressIndicator()
                        : FlatButton(
                            color: BlockColors.accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                side:
                                    BorderSide(color: BlockColors.accentColor)),
                            onPressed: () async {
                              setState(() {
                                _loading = true;
                              });
                              await FBManager.fbStore
                                  .collection(USERS_COLLECTION)
                                  .document(UserSettings.UID)
                                  .updateData({
                                'name': _name,
                                'surname': _surname,
                                'birthday': _birthday,
                                'country': _country,
                                'gender': _gender,
                                'patent': _patent,
                                'status': _status,
                                'latest_update': Timestamp.now()
                              });

                              // Обновление данных document из FB
                              UserSettings.userDocument =
                                  await FBManager.getUserStats(
                                      UserSettings.UID);

                              // Закрытие окна и возврат в профиль
                              Navigator.pop(context, true);
                            },
                            child: Text(
                              "Да",
                              style: TextStyle(color: Colors.white),
                            )),
                  ),
                ],
              ),
            );
          });
    } else if (UserInputDataVerification.isInputNameRight(_name) == false) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(
          'Проверьте введенное имя',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ));
    } else if (UserInputDataVerification.isInputSurnameRight(_surname) ==
        false) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(
          'Проверьте введенную фамилию',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ));
    } else if (UserInputDataVerification.isInputBirthday(_birthday) == false) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(
          'Проверьте введенную дату рождения',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            // Проверка на инвалидность введенных данных и прошедшего времени
            var updated = await showConfirmation(context);
            if (updated) Navigator.pop(context, true);
            //Обновление информации в ячейке информации о последнем редактировании настроект профиля
            //FBManager.addLastProfileChange();
          },
          icon: Icon(
            Icons.playlist_add_check,
            color: Colors.white,
          ),
          label: Text(
            "Сохранить",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: BlockColors.accentColor,
        ),
        appBar: AppBar(
          title: Container(
              child: InkWell(
            onLongPress: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Logs())),
            child: Text(
              '      Настройки',
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          )),
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              print("Closing");
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[],
        ),
        body: Container(
          child: Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: new ListView(children: <Widget>[
                new Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  height: 1,
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                ),

                SizedBox(
                  height: 10,
                ),

                // Название блока КОНТАКТЫ
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "КОНТАКТЫ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),

                SizedBox(
                  height: 15,
                ),

                // Название блок "Name"
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Имя",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),

                // Блок ввода данных Name
                Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: Colors.white,
                  ),
                  child: new Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      autofocus: false,

                      style: TextStyle(color: Colors.black),
                      maxLines: null, // ne
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        //errorText: "",
                        errorStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black, //this has no effect
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.black,
                        )),

                        focusColor: Colors.black,

                        fillColor: Colors.black,
                        hoverColor: Colors.black,
                        border: OutlineInputBorder(),
                        // Вывод данных индекса пользователя в блок до нажатия
                        hintText: _name,

                        //counterText: _index,
                        //suffixText: _index,
                        //helperText: _name,
                        //semanticCounterText: _name,
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onChanged: (value) async {
                        _name = value;
                      },
                      initialValue: _name,
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                // Подпись к блоку имени
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Имя может содержать только символы русского языка, знаки пробела и тире",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 11,
                    ),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),

                // Название блок "Surname"
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Фамилия",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),

                // Блок ввода данных Surname
                Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: Colors.black,
                  ),
                  child: new Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      autofocus: false,

                      style: TextStyle(color: Colors.black),
                      maxLines: null, // ne
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        //errorText: "",
                        errorStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black, //this has no effect
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.black,
                        )),

                        focusColor: Colors.black,

                        fillColor: Colors.black,
                        hoverColor: Colors.black,
                        border: OutlineInputBorder(),
                        //labelText: 'Edit',

                        // Вывод данных индекса пользователя в блок до нажатия
                        hintText: _surname,

                        //counterText: _index,
                        //suffixText: _index,
                        //helperText: _surname,
                        //semanticCounterText: _surname,
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onChanged: (value) async {
                        _surname = value;
                      },
                      initialValue: _surname,
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                // Подпись к блоку имени
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Фамилия может содержать только символы русского языка, знаки пробела и тире",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 11,
                    ),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),

                // Название блок "Surname"
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Статус",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),

                // Блок ввода данных Surname
                Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: Colors.black,
                  ),
                  child: new Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      autofocus: false,

                      style: TextStyle(color: Colors.black),
                      maxLines: null, // ne
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        //errorText: "",
                        errorStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black, //this has no effect
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.black,
                        )),

                        focusColor: Colors.black,

                        fillColor: Colors.black,
                        hoverColor: Colors.black,
                        border: OutlineInputBorder(),
                        //labelText: 'Edit',

                        // Вывод данных индекса пользователя в блок до нажатия
                        hintText: _status,

                        //counterText: _index,
                        //suffixText: _index,
                        //helperText: _status,
                        //semanticCounterText: _status,
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onChanged: (value) async {
                        _status = value;
                      },
                      initialValue: _status,
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                // Подпись к блоку имени
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Статус может содержать только символы русского языка, знаки пробела и тире",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 11,
                    ),
                  ),
                ),

                SizedBox(
                  height: 50,
                ),

                // Название блока CONTACT
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "ИНФОРМАЦИЯ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),

                SizedBox(
                  height: 15,
                ),

                // Блок Пола
                Row(
                  children: <Widget>[
                    // Название блок "Выберите пол"
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 25),
                      child: Text(
                        "Пол",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    // Блок выбора пола "Муж, Жен"
                    RadioButtonGroup(
                      padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
                      orientation: GroupedButtonsOrientation.HORIZONTAL,
                      activeColor: BlockColors.accentColor,
                      labels: <String>[
                        "Муж",
                        "Жен",
                      ],
                      picked: _gender,
                      onSelected: (String selected) => setState(() {
                        _gender = selected;
                      }),
                    ),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                // Блок Статуса РФ
                Row(
                  children: <Widget>[
                    // Блок названия выбора Гражданства / Патента
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 25),
                      child: Text(
                        "Статус РФ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    // Блок выбора Гражданства / Патента
                    RadioButtonGroup(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        orientation: GroupedButtonsOrientation.HORIZONTAL,
                        activeColor: BlockColors.accentColor,
                        labels: <String>[
                          " Патент ",
                          " Гражданство ",
                          " Нет",
                        ],
                        picked: _patent == "patent" ||
                                _patent == "patent_confirmed"
                            ? " Патент "
                            : _patent == "residence" ? " Гражданство " : " Нет",
                        onSelected: (String selected) {
                          setState(() {
                            print("chosen: " + selected);
                            switch (selected) {
                              case " Патент ":
                                _patent = "patent";
                                break;
                              case " Гражданство ":
                                _patent = "residence";
                                break;
                              case " Нет":
                              default:
                                _patent = "null";
                                break;
                            }
                          });
                        }),
                  ],
                ),

                SizedBox(height: 20),

                // Блок названия выбора даты рождения
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Дата рождения",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),

                SizedBox(height: 15),

                // Блок выбора даты рождения
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextField(
                    controller: dateCtl,
                    maxLines: null,
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: _birthday),
                    onChanged: (birthday) {
                      _birthday = birthday;
                    },
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(1950, 1, 1),
                          maxTime: DateTime(2022, 12, 31),
                          onConfirm: (birthday) {
                        print(Timestamp.fromDate(birthday).toString());
                        setState(() {
                          dateCtl.text = birthday.year.toString();
                          _birthday = dateCtl.text;
                          print(_birthday);
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.ru);
                    },
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                // Подпись к блоку имени
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Приложением могут пользоваться только лица старше четырех лет",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 11,
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Блок названия выбора Гражданства
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Гражданство",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),

                SizedBox(height: 15),

                // Блок выбора страны гражданства
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: DropDownFormField(
                    titleText: 'Вы гражданин(-ка)..',
                    hintText: 'Укажите страну',
                    value: _country,
                    onSaved: (value) {
                      setState(() {
                        _country = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _country = value;
                      });
                    },
                    dataSource: [
                      {
                        "display": "Россия",
                        "value": "Россия",
                      },
                      {
                        "display": "Казахстан",
                        "value": "Казахстан",
                      },
                      {
                        "display": "Беларусь",
                        "value": "Беларусь",
                      },
                      {
                        "display": "Киргизия",
                        "value": "Киргизия",
                      },
                      {
                        "display": "Грузия/Абхазия",
                        "value": "Грузия/Абхазия",
                      },
                      {
                        "display": "Украина",
                        "value": "Украина",
                      },
                      {
                        "display": "Таджикистан",
                        "value": "Таджикистан",
                      },
                      {
                        "display": "Азербайджан",
                        "value": "Азербайджан",
                      },
                      {
                        "display": "Армения",
                        "value": "Армения",
                      },
                      {
                        "display": "Молдавия",
                        "value": "Молдавия",
                      },
                      {
                        "display": "Другое",
                        "value": "Другое",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),
                ),

                SizedBox(
                  height: 100,
                ),
              ])),
        ));
  }
}

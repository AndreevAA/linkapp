
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:linkapp/Service/FBManager.dart';
import 'package:linkapp/Service/NotifManager.dart';
import 'package:linkapp/Service/UserSettings.dart';
import 'package:linkapp/Service/iputDataVerification.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'Registration.dart';

class StepperDemo extends StatefulWidget {
  final bool ispublic;

  StepperDemo({Key key, this.ispublic}) : super(key: key);

  final String title = "Stepper Demo";

  @override
  StepperDemoState createState() => StepperDemoState();
}

class StepperDemoState extends State<StepperDemo> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _currentStep = 0;
  DateTime selectedDate = DateTime.now();
  String _country;
  String _surname;
  String _name;
  String _patent = 'null';
  String _sex;
  String _birthday;
  TextEditingController dateCtl = TextEditingController();
  String date;

  List<Step> get steps =>
      [
        // Первый шаг: ввода имени и фамилии
        Step(
          title: Text('Укажите, как к вам обращаться'),
          isActive: true,
          content: Column(
            children: <Widget>[

              // Блок ввода имени
              Container(
                child: TextField(
                  maxLines: null,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Имя'
                  ),
                  onChanged: (name) {
                    _name = name;
                  },
                ),
              ),

              SizedBox(height: 10,),

              // Подпись к блоку имени
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  "Поле имени может содержать только символы русского и английского языков, знаки пробела и тире", textAlign: TextAlign.left, style: TextStyle(
                  color: Colors.black38, fontSize: 11,
                ),
                ),
              ),

              SizedBox(height: 25),

              // Блок ввода фамилии
              Container(
                child: TextField(
                  maxLines: null,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Фамилия'
                  ),
                  onChanged: (name) {
                    _surname = name;
                  },
                ),
              ),

              SizedBox(height: 10,),

              // Подпись к блоку фамилии
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  "Поле фамилии может содержать только символы русского и английского языков, знаки пробела и тире", textAlign: TextAlign.left, style: TextStyle(
                  color: Colors.black38, fontSize: 11,
                ),
                ),
              ),

              SizedBox(height: 10),
            ],
          ),
        ),

        // Второй шаг: ввод страны
        Step(
          title: Text('Введите Ваши данные'),
          content: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Container(
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
                SizedBox(height: 10),
              ]
          ),
          isActive: true,
        ),

        // Третий шаг: Выбор поля, птента, даты рождения
        Step(
          title: Text('Дополните ваши данные'),
          content: Column(
              children: <Widget>[
                Container(child: Text("Выбирите пол:"),
                ),
                RadioButtonGroup(
                    orientation: GroupedButtonsOrientation.HORIZONTAL,
                    activeColor: Colors.deepPurpleAccent,
                    labels: <String>[
                      "Муж",
                      "Жен",
                    ],
                    onSelected: (String selected) => _sex = selected,
                ),
                RadioButtonGroup(
                    orientation: GroupedButtonsOrientation.HORIZONTAL,
                    activeColor: Colors.deepPurpleAccent,
                    labels: <String>[
                      " Патент ",
                      " Гражданство ",
                      " Нет",
                    ],
                    onSelected: (String selected){
                      print("chosen: " + selected);
                      switch (selected){
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
                    }
                ),
                SizedBox(height: 10),
                SizedBox(height: 15),
                Container(
                  child: TextField(
                    controller: dateCtl,
                    maxLines: null,
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Дата рождения'
                    ),
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
                              dateCtl.text = birthday.day.toString() + "." + birthday.month.toString() + "." + birthday.year.toString();
                              _birthday = dateCtl.text;
                              print(_birthday);

                            });
                          }, currentTime: DateTime.now(), locale: LocaleType.ru);
                    },
                  ),
                ),
                SizedBox(height: 10),
              ]),
          state: StepState.complete,
          isActive: true,
        ),
      ];

  @override
  Widget build(BuildContext context) {
return MaterialApp(
  debugShowCheckedModeBanner: false,
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    supportedLocales: [
      const Locale('ru','RU'),
    ],
    home: Scaffold(

      key: _scaffoldKey,

      body:Theme(data: ThemeData( primaryColor: Colors.deepPurpleAccent),

        child: Stepper(
            currentStep: this._currentStep,
            steps: steps,
            type: StepperType.vertical,
            onStepTapped: (step) {
              setState(() {
                _currentStep = step;
              });
            },
            onStepContinue: () {
              setState(() {

                // Верификация первого шага регистрации (Имя и фамилия)
                if (_currentStep == 0)
                {

                  // Введено пустое поле имени
                  if (_name == null){
                    _scaffoldKey.currentState.showSnackBar(new SnackBar(
                      content: new Text('Заполните имя', textAlign: TextAlign.center,),
                      backgroundColor: Colors.red,));
                  }

                  // Поля фамилии пустое
                  else if (_surname == null){
                    _scaffoldKey.currentState.showSnackBar(new SnackBar(
                      content: new Text('Заполните фамилию', textAlign: TextAlign.center,),
                      backgroundColor: Colors.red,));
                  }

                  // Поля фамилии и имени не пустые
                  else if (_surname != null && _name != null){

                    // Первые символы становятся заглавными в имени
                    _name = _name[0].toUpperCase() + _name.substring(1, _name.length);

                    // Первые символы становятся заглавными в фамилии
                    _surname = _surname[0].toUpperCase() + _surname.substring(1, _surname.length);

                    // Поле имени содержит запрещенные символы
                    if (UserInputDataVerification.isInputNameRight(_name) == false) {
                      _scaffoldKey.currentState.showSnackBar(new SnackBar(
                        content: new Text('Проверьте введенное имя', textAlign: TextAlign.center,),
                        backgroundColor: Colors.red,));
                    }
                    // Фамилия введена неверно
                    else if (UserInputDataVerification.isInputSurnameRight(_surname) == false) {
                      _scaffoldKey.currentState.showSnackBar(new SnackBar(
                        content: new Text('Проверьте введенную фамилию', textAlign: TextAlign.center,),
                        backgroundColor: Colors.red,));
                    }

                    // Поля имени и фамилии непустые и содержат разрешенные символы
                    else if (UserInputDataVerification.isInputNameRight(_name) == true && UserInputDataVerification.isInputSurnameRight(_surname) == true){
                      _currentStep++;
                    }
                  }

                  print("Ladding: " + _currentStep.toString());
                }

                // Верификация второго шага регистрации (Страна)
                else if (_currentStep == 1)
                {

                  // Поле выбора выбора страны пустое пустое
                  if (_country == null){
                    _scaffoldKey.currentState.showSnackBar(new SnackBar(
                      content: new Text('Заполните блок <Ваши данные>', textAlign: TextAlign.center,),
                      backgroundColor: Colors.red,));
                  }

                  // Указана страна работника
                  else if (_country != null){
                    _currentStep++;
                  }

                  print("Ladding: " + _currentStep.toString());
                }

                // Верификация третьего шага регистрации
                else if (_currentStep == 2){

                  print(_patent ?? "Ne nol");
                  print(_birthday ?? "Ne nol");
                  print(_sex ?? "Ne nol");
                  print(_country ?? "Ne nol");
                  print(_surname ?? "Ne nol");
                  print(_name ?? "Ne nol");


                  // Поле выбора типа работодателя пустое
                  if (_sex == null){
                    _scaffoldKey.currentState.showSnackBar(new SnackBar(
                      content: new Text('Укажите пол', textAlign: TextAlign.center,),
                      backgroundColor: Colors.red,));
                  }

                  if (_patent == null){
                    _scaffoldKey.currentState.showSnackBar(new SnackBar(
                      content: new Text('Укажите Патент / Гражданство / Нет', textAlign: TextAlign.center,),
                      backgroundColor: Colors.red,));
                  }

                  if (_birthday == null){
                    _scaffoldKey.currentState.showSnackBar(new SnackBar(
                      content: new Text('Укажите дату рождения', textAlign: TextAlign.center,),
                      backgroundColor: Colors.red,));
                  }

                  if (UserInputDataVerification.isInputBirthday(_birthday) == false){
                    _scaffoldKey.currentState.showSnackBar(new SnackBar(
                      content: new Text('Проверьте введенную дату рождения', textAlign: TextAlign.center,),
                      backgroundColor: Colors.red,));
                  }

                  else if (_patent != null && _birthday != null && _sex != null){
                    if ((_sex != null) && (_country != null) &&
                        (_surname != null) && (_name != null) &&
                        (_birthday != null) && (_birthday != null)  &&
                        UserInputDataVerification.isInputNameRight(_name) == true && UserInputDataVerification.isInputSurnameRight(_surname) == true && UserInputDataVerification.isInputBirthday(_birthday) == true)
                      createUser();

                    else {
                      _currentStep = 0;
                      _scaffoldKey.currentState.showSnackBar(new SnackBar(
                        content: new Text('Не все поля заполнены', textAlign: TextAlign.center,),
                        backgroundColor: Colors.red,));
                    }
                  }

                  print("Ladding: " + _currentStep.toString());
                }

              });
            },
            onStepCancel: () {
              setState(() {
                if (_currentStep > 0) {
                  _currentStep = _currentStep - 1;
                } else {
                  _currentStep = 0;
                }
              });
            },
            controlsBuilder: (BuildContext context,
                {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  FlatButton(
                    color: Colors.deepPurpleAccent,
                    textColor: Colors.white,
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                    onPressed: onStepContinue,
                    child: const Text('ДАЛЕЕ'),
                  ),
                  FlatButton(
                    onPressed: onStepCancel,
                    child: const Text('НАЗАД'),
                  ),
                ],
              );
            }),
      ),
    ));
  }

  Future<void> createUser() async {
    SharedPreferences.getInstance().then((SharedPreferences prefs) async {
      prefs.setString('uid', UserSettings.UID);
      String _token = await NotifManager.GetDeviceToken();
      String _phone = (await FirebaseAuth.instance.currentUser()).phoneNumber;
      await FBManager.addNewUser({
        'country': _country,
        'name': _surname,
        'surname': _name,
        'gender': _sex,
        'role' : 'user',
        'device_token' : _token,
        'birthday':  _birthday,
        'ispublic': widget.ispublic,
        'phone' : _phone,
        'friends' : [],
        'dialogs' : [],
        'publics' : [],
        'posts' : [],
        'status' : "Добавьте статус!",
        'seen' : Timestamp.now(),
        'token' : UserSettings.UID },);
    });

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyApp()));
  }

  }
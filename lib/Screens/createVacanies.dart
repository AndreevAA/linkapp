import 'dart:convert';
import 'dart:io';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:giphy_client/giphy_client.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkapp/Screens/profileDataEditingScreen.dart';
import 'package:linkapp/Service/DataBaseNamings.dart';
import 'package:linkapp/Service/FBManager.dart';
import 'package:linkapp/Service/UserSettings.dart';
import 'package:linkapp/Settings/textStyleSettings.dart';
import 'package:location/location.dart';

//https://pub.dev/packages/image_picker#-readme-tab- ДОБАВИТЬ ВЕБ ПОДДЕРЖКУ
class CreateVacancies extends StatefulWidget {
  @override
  _CreateVacanciesState createState() => _CreateVacanciesState();
}

// Окно создания поста
class _CreateVacanciesState extends State<CreateVacancies> {
  String _postText, _authorRole, _authorToken, _postTitle, _pathImage;
  GiphyGif _gif;

  String _postType = 'Выберете тип поста';

  _CreateVacanciesState() {
    _authorRole = UserSettings.userDocument['role'].toString();
    _authorToken = UserSettings.userDocument['token'].toString();
  }

  File _image;
  final picker = ImagePicker();
  TextEditingController dateCtl;

  var storage = FirebaseStorage.instance;

  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  getPermision() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    return _locationData;
  }

  getLocation() async {
    _locationData = await location.getLocation();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<String> tags = [];
  List<String> _skills = [
    "Уборка",
    "Строительство",
    "Производство",
    "Погрузка / разгрузка / доставка",
    "Вождение автомобилем",
    "Работа в зале: выкладка и контроль",
    "Готовка",
    "Разнорабочий",
    "Другое",
  ];

  int _currentStep = 0;
  DateTime selectedDate = DateTime.now();
  String _country;
  String _surname;
  String _name;
  String _patent = 'null';
  String _sex;
  String _birthday;
  //TextEditingController dateCtl = TextEditingController();
  String date;


  List<Step> get steps =>
      [
        // Первый шаг: ввода имени и фамилии
        Step(
          title: Text(''),
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
                      labelText: 'Название'
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
                  "Поле имени может содержать только символы русского языка, знаки пробела и тире",
                  textAlign: TextAlign.left, style: TextStyle(
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
                      labelText: 'Описание'
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
                  "Поле фамилии может содержать только символы русского языка, знаки пробела и тире",
                  textAlign: TextAlign.left, style: TextStyle(
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
          title: Text('2'),
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
          title: Text('3'),
          content: Column(
              children: <Widget>[
                Container(child: Text("Выбирите пол:"),
                ),
                RadioButtonGroup(
                  orientation: GroupedButtonsOrientation.HORIZONTAL,
                  activeColor: Colors.green,
                  labels: <String>[
                    "Муж",
                    "Жен",
                  ],
                  onSelected: (String selected) => _sex = selected,
                ),
                RadioButtonGroup(
                    orientation: GroupedButtonsOrientation.HORIZONTAL,
                    activeColor: Colors.green,
                    labels: <String>[
                      " Патент ",
                      " Гражданство ",
                      " Нет",
                    ],
                    onSelected: (String selected) {
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
                              dateCtl.text = birthday.year.toString();
                              _birthday = dateCtl.text;
                              print(_birthday);
                            });
                          },
                          currentTime: DateTime.now(),
                          locale: LocaleType.ru);
                    },
                  ),
                ),
                SizedBox(height: 30),
                Text('Выберите ваши професии'),
                SizedBox(height: 10),
                Container(
                  child: ChipsChoice<String>.multiple(
                    isWrapped: true,
                    value: tags,
                    options: ChipsChoiceOption.listFrom<String, String>(
                      source: _skills,
                      value: (i, v) => v,
                      label: (i, v) => v,
                    ),
                    onChanged: (val) {
                      setState(() {
                        tags = val;
                      });
                    },
                  ),
                ),
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
          const Locale('ru', 'RU'),
        ],
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              'Новый пост',
              style: TextStyle(color: Colors.black),
            ),
            leading: BackButton(color: Colors.black),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),

          key: _scaffoldKey,

          body: Theme(data: ThemeData(primaryColor: Colors.green),

            child: Stepper(
                currentStep: this._currentStep,
                steps: steps,
                type: StepperType.horizontal,
                onStepTapped: (step) {
                  setState(() {
                    _currentStep = step;
                  });
                },
                onStepContinue: () {
                  setState(() {
                    // Верификация первого шага регистрации (Имя и фамилия)
                    if (_currentStep == 0) {
                      // Введено пустое поле имени
                      if (_name == null) {
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(
                          content: new Text('Заполните имя',
                            textAlign: TextAlign.center,),
                          backgroundColor: Colors.red,));
                      }

                      // Поля фамилии пустое
                      else if (_surname == null) {
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(
                          content: new Text(
                            'Заполните фамилию', textAlign: TextAlign.center,),
                          backgroundColor: Colors.red,));
                      }

                      // Поля фамилии и имени не пустые
                      else if (_surname != null && _name != null) {
                        // Первые символы становятся заглавными в имени
                        _name = _name[0].toUpperCase() +
                            _name.substring(1, _name.length);

                        // Первые символы становятся заглавными в фамилии
                        _surname = _surname[0].toUpperCase() +
                            _surname.substring(1, _surname.length);

                        // Поле имени содержит запрещенные символы
                        if (UserInputDataVerification.isInputNameRight(_name) ==
                            false) {
                          _scaffoldKey.currentState.showSnackBar(new SnackBar(
                            content: new Text('Проверьте введенное имя',
                              textAlign: TextAlign.center,),
                            backgroundColor: Colors.red,));
                        }
                        // Фамилия введена неверно
                        else if (UserInputDataVerification.isInputSurnameRight(
                            _surname) == false) {
                          _scaffoldKey.currentState.showSnackBar(new SnackBar(
                            content: new Text('Проверьте введенную фамилию',
                              textAlign: TextAlign.center,),
                            backgroundColor: Colors.red,));
                        }

                        // Поля имени и фамилии непустые и содержат разрешенные символы
                        else if (UserInputDataVerification.isInputNameRight(
                            _name) == true &&
                            UserInputDataVerification.isInputSurnameRight(
                                _surname) == true) {
                          _currentStep++;
                        }
                      }

                      print("Ladding: " + _currentStep.toString());
                    }

                    // Верификация второго шага регистрации (Страна)
                    else if (_currentStep == 1) {
                      // Поле выбора выбора страны пустое пустое
                      if (_country == null) {
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(
                          content: new Text('Заполните блок <Ваши данные>',
                            textAlign: TextAlign.center,),
                          backgroundColor: Colors.red,));
                      }

                      // Указана страна работника
                      else if (_country != null) {
                        _currentStep++;
                      }

                      print("Ladding: " + _currentStep.toString());
                    }

                    // Верификация третьего шага регистрации
                    else if (_currentStep == 2) {
                      // Поле выбора типа работодателя пустое
                      if (_sex == null) {
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(
                          content: new Text(
                            'Укажите пол', textAlign: TextAlign.center,),
                          backgroundColor: Colors.red,));
                      }

                      if (_patent == null) {
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(
                          content: new Text(
                            'Укажите Патент / Гражданство / Нет',
                            textAlign: TextAlign.center,),
                          backgroundColor: Colors.red,));
                      }

                      if (_birthday == null) {
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(
                          content: new Text('Укажите дату рождения',
                            textAlign: TextAlign.center,),
                          backgroundColor: Colors.red,));
                      }


                      if (UserInputDataVerification.isInputBirthday(
                          _birthday) == false) {
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(
                          content: new Text('Проверьте введенную дату рождения',
                            textAlign: TextAlign.center,),
                          backgroundColor: Colors.red,));
                      }

                      if (_skills == null) {
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(
                          content: new Text('Укажите вашу профессию',
                            textAlign: TextAlign.center,),
                          backgroundColor: Colors.red,));
                      }
                      else if (_patent != null && _birthday != null &&
                          _sex != null) {
                        if ((_sex != null) && (_country != null) &&
                            (_surname != null) && (_name != null) &&
                            (_birthday != null) && (_skills != null) &&
                            UserInputDataVerification.isInputNameRight(_name) ==
                                true &&
                            UserInputDataVerification.isInputSurnameRight(
                                _surname) == true &&
                            UserInputDataVerification.isInputBirthday(
                                _birthday) == true)
                          createUser();
                        else {
                          _currentStep = 0;
                          _scaffoldKey.currentState.showSnackBar(new SnackBar(
                            content: new Text('Не все поля заполнены',
                              textAlign: TextAlign.center,),
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
                        onPressed: onStepCancel,
                        child: const Text('НАЗАД'),
                      ),
                      FlatButton(
                        color: Colors.purple,
                        textColor: Colors.white,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0)),
                        onPressed: onStepContinue,
                        child: const Text('ДАЛЕЕ'),
                      ),
                    ],
                  );
                }),
          ),
        ));
  }

  Future<void> createUser() async {
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:linkapp/Service/FBManager.dart';
import 'package:linkapp/Service/UserSettings.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../main.dart';
import 'Ladding.dart';
import 'LogsView.dart';

enum GenderList { male, female }

class MyForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyFormState();
}

class MyFormState extends State {
  final _formKey = GlobalKey<FormState>();
  String _phoneNum;
  String verifCode;
  String verifId;
  String smsCode;
  bool _agreement = false;

  bool _user = false;

  Future<void> redirectUser(String uid) async {
    DocumentSnapshot snap = await FBManager.getUser(uid);

    UserSettings.UID = uid;
    UserSettings.phone = _phoneNum;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phone', _phoneNum);
    prefs.setString('uid', uid);

      if (snap == null  || !snap.exists) {
        Logs.addNode("Registration", "redirectUser", "NULL"); // WORKER
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StepperDemo(ispublic : _user,),
              settings: RouteSettings(name: 'Profile_filling'),
            ));
      }

      else if ((snap == null  || !snap.exists ) && _user == false){

        Logs.addNode("Registration", "redirectUser", "NULL"); // WORKER
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StepperDemo(),
              settings: RouteSettings(name: 'Profile_filling'),
            ));

      }

      else if (snap['role'] != 'user') {
        Logs.addNode("Registration", "redirectUser", snap['role']); // empl
        prefs.clear();
        UserSettings.clearAll();
        FirebaseAuth.instance.signOut();
        deactivateDialog(context);
      }

      else {
        Logs.addNode("Registration", "redirectUser", snap['role']); // worker
        UserSettings.userDocument = snap;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyApp(),
          settings: RouteSettings(name: 'User_signin'),
        ));
      }


  }

  Future<void> verifyPhoneNum() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verifId) {
      this.verifId = verifId;
    };
    final PhoneCodeSent smsCodeSent = (String verifId, [int forceCodeResend]) {
      this.verifId = verifId;
      smsCodeDialog(context).then((value) async {
        FBManager.init();
        print("Registration: " + "SignedIn");
        //redirectUser();
      });
    };

    final PhoneVerificationCompleted verifSuccess = (AuthCredential user) {
      print("Registration: " + "Successfully verified!");

      //smsCodeDialog(context);
    };

    final PhoneVerificationFailed verifFailed = (AuthException excetpion) {
      print("Registration: " + '${excetpion.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNum,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifSuccess,
        verificationFailed: verifFailed,
        codeSent: smsCodeSent,
        codeAutoRetrievalTimeout: autoRetrieve);
  }

  Future<bool> smsCodeDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            title: Text(" Код из СМС:"),
            content: PinCodeTextField(
              length: 6,
              textInputType: TextInputType.number,
              inactiveColor: Colors.grey,
              selectedColor: Colors.deepPurpleAccent,
              obsecureText: false,
              animationType: AnimationType.fade,
              shape: PinCodeFieldShape.box,
              animationDuration: Duration(milliseconds: 300),
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 40,
              fieldWidth: 30,
              onChanged: (value) {
                setState(() {
                  this.smsCode = value;
                });
              },
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    FirebaseAuth.instance.currentUser().then((user) async {
                      if (user != null) {
                        print("Registration: " +
                            "user phone num: " +
                            user.phoneNumber +
                            " user uid: " +
                            user.uid);
                        UserSettings.UID = user.uid;
                        //Navigator.of(context).pop();

                        FBManager.init();

                        redirectUser(user.uid);
                      } else {
                        Navigator.of(context).pop();
                        signIn();
                      }
                    });
                  },
                  child: Text(
                    "ДАЛЕЕ",
                    style: TextStyle(color: Colors.deepPurpleAccent),
                  ))
            ],
          );
        });
  }

  signIn() {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verifId,
      smsCode: smsCode,
    );

    FirebaseAuth.instance.signInWithCredential(credential).then((user) async {
      FBManager.init();
      redirectUser(user.user.uid);
    }).catchError((e) {
      print("Registration: " + e);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Превышен лимит запросов. Попробуйте позже.'),
        backgroundColor: Colors.deepPurpleAccent,
      ));
    });
  }

  validatePhoneNum() {
    _phoneNum = _phoneNum.trim();
    _phoneNum = _phoneNum.replaceAll('-', '');
    _phoneNum = _phoneNum.replaceAll('(', '');
    _phoneNum = _phoneNum.replaceAll(')', '');
    if (_phoneNum.length == 12 && _phoneNum[0] == "+" && _phoneNum[1] == '7')
      return true;
    if (_phoneNum.length == 11 && _phoneNum[0] == '8') {
      _phoneNum = _phoneNum.replaceFirst('8', '+7');
      print("_phoneNum: " + _phoneNum);
      return true;
    }
    return false;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      body: Theme(
        data: ThemeData(primaryColor: Colors.deepPurpleAccent, backgroundColor: Colors.white),
        child: SingleChildScrollView(
            child: new Form(
                key: _formKey,
                child: new Column(
                  children: <Widget>[
                    SizedBox(height: 50,),

                    new Container(
                      child: Image.asset('assets/LOGO.png'),
                      height: 170.0,
                      width: 300.0,
                    ),

                    Container(
                      child: Text(
                        'Вход в приложение через смс',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                    ),

                    new Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 10.00),
                      child: TextField(
                        maxLines: null, // ne
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          focusColor: Colors.deepPurpleAccent,
                          fillColor: Colors.deepPurpleAccent,
                          hoverColor: Colors.deepPurpleAccent,
                          border: OutlineInputBorder(),
                          labelText: 'Номер телефона',
                        ),
                        onChanged: (value) async {
                          _phoneNum = value;
                          //SharedPreferences prefs = await SharedPreferences.getInstance();
                          //print("Registration: " + 'phooooone DOWN');
                          //print("Registration: " + '$Userphone_local');
                        },
                      ),
                    ),
                    new Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: CheckboxListTile(
                          activeColor: Colors.deepPurpleAccent,
                          value: _agreement,
                          title: new Container(
                            child: new RichText(
                              text: new TextSpan(
                                children: [
                                  new TextSpan(
                                    text: 'Я ознакомлен(а) с ',
                                    style: new TextStyle(color: Colors.black),
                                  ),
                                  new TextSpan(
                                    text: 'условиями',
                                    style: new TextStyle(
                                        color: Colors.deepPurpleAccent,
                                        decoration: TextDecoration.underline),
                                    recognizer: new TapGestureRecognizer()
//                                      ..onTap = () {
//                                        launch(
//                                            'https://job-cleaner.ru/obrabotka_personalnyh_dannyh.pdf');
//                                      },
                                  ),
                                  new TextSpan(
                                    text: ' использования сервиса',
                                    style: new TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onChanged: (bool value) =>
                              setState(() => _agreement = value)),
                    ),
                    new Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: CheckboxListTile(
                          activeColor: Colors.deepPurpleAccent,
                          value: _user,
                          title: new Container(
                              child: Text('Я рекрутер'),
                          ),
                          onChanged: (bool value) =>
                              setState(() => _user = value)),
                    ),
                    new Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.00),
                      child: new RaisedButton(
                        onPressed: () {
                          if (!_agreement)
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('Чтобы продолжить, примите Соглашение'),
                              backgroundColor: Colors.redAccent,
                            ));
                          else if (_formKey.currentState
                              .validate()) if (validatePhoneNum()) {
                            verifyPhoneNum();
                            print("Registration: num: " + _phoneNum);
                          } else {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('Введите корректный номер телефона'),
                              backgroundColor: Colors.redAccent,
                            ));
                          }
                        },
                        child: Text('Продолжить'),
                        color: Colors.deepPurpleAccent,
                        textColor: Colors.white,
                      ),
                    )
                  ],
                ))),
      ),
    );
  }
}

Future<bool> deactivateDialog(BuildContext context, ) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'Ваш аккаунт уже был зарегистрирован как Работадатель. \n'
                      'Деактивируйте ваш аккаунт Работадателя, чтобы зарегистрироваться как Работник. \n' +'\n',
                  style: TextStyle(color: Colors.black.withOpacity(1.0), fontSize: 16),
                ),
                TextSpan(
                  text: "Если проблемы со входом, то напишите в тех. поддержку: CleanER.tech.support@job-cleaner.ru ",
                  style: TextStyle(color: Colors.black.withOpacity(0.6) , fontSize: 10),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: Text(
                  "Ок",
                  style: TextStyle(color: Colors.grey),
                )),

          ],
        );
      });
}


class Regist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      home: new MyForm(),
    );
  }
}

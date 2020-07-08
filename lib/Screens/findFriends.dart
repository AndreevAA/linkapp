import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/Service/FBManager.dart';
import 'package:linkapp/Service/UserSettings.dart';
import 'package:linkapp/Settings/textStyleSettings.dart';

class FindFriends extends StatefulWidget {
  @override
  _FindFriendsState createState() => _FindFriendsState();
}

class _FindFriendsState extends State<FindFriends> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _friendsList, _peopleList, _foundedPeopleList = [];
  int _friendsListLength = 0, _peopleListLength = 0, _foundedPeopleListLength = 0;

  _FindFriendsState(){
    _friendsList = UserSettings.userDocument['friends'].toString();
    _peopleList = FBManager.fbStore.collection("posts").getDocuments();
  }


  // Реализация поиска по подстроке
  bool isSimmilar(String userToken, String inputText){
    bool answer = false;

    // Паша, так и не разобрался, как обращаться к данным конрктеного пользователя по токену
    //String fullUserName = FBManager.fbStore.collection("users").document(userToken);

    String fullUserName = "";

    return fullUserName.contains(inputText);
  }

  // Получение массива token людей по имя + фамилия по параметру поиска
  // В случае отсутствия людей функция вернет строку "Пользователи не найдены"
  void getFoundedPeopleList(String inputText){

    if (_peopleList != null)
      _peopleListLength = _peopleList.length;

    for (int i = 0; i < _peopleListLength; i++){
      if (isSimmilar(_peopleList[i], inputText) == true) {
        _foundedPeopleList.add(_peopleList[i]);
        _foundedPeopleListLength++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    print(_peopleList.toString());

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Container(
              child: InkWell(
//                onLongPress: () => Navigator.push(
//                    context, MaterialPageRoute(builder: (context) => Logs())),
                child: Text('      Добавить друзей', style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
              )
          ),
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
              child: new ListView(
                  children: <Widget>[

                  ])),
        ));
  }
}
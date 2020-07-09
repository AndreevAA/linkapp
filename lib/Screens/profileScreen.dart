import 'package:backdrop_modal_route/backdrop_modal_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/AdditionalFunctions/createdElements.dart';
import 'package:linkapp/AdditionalFunctions/textFormating.dart';
import 'package:linkapp/Screens/dialogsScreen.dart';
import 'package:linkapp/Service/FBManager.dart';
import 'package:linkapp/Service/UserSettings.dart';
import 'package:linkapp/Settings/blockStyleSettings.dart';
import 'package:linkapp/Settings/iconStyleSettings.dart';
import 'package:linkapp/Settings/textStyleSettings.dart';

class ProfileScreen extends StatefulWidget{
  
  DocumentSnapshot document;
  ProfileScreen({@required this.document});

  @override
  _ProfileScreenState createState() => _ProfileScreenState(document);

}

class _ProfileScreenState extends State<ProfileScreen>{

//  DocumentSnapshot document;
  _ProfileScreenState(DocumentSnapshot document) {
    _name = (document['name'] ?? 'null').toString();
    _surname = (document['surname'] ?? 'null').toString();
    _gender = (document['gender'] ?? 'null').toString();
    _country = (document['country'] ?? 'null').toString();
    _birthday = (document['birthday'] ?? 'null').toString();
    _patent = (document['patent'] ?? 'null').toString();
    _status = (document['status'] ?? 'null').toString();

    _friends = document['friends'] ?? new List();
    _followers = document['followers'] ?? new List();
    _publics = document['publics'] ?? new List();

    dateCtl = TextEditingController();
  }
  
  String _name, _surname, _gender, _country, _birthday, _patent, _status;

  List<dynamic> _friends, _followers, _publics, _photos;

  TextEditingController dateCtl;

  Container startDialogueButton(DocumentSnapshot documentSnapshot) {
    if (chatStream == null)
      chatStream = FBManager.getChatStream();
    chatStream.toList().then((List<dynamic> list) {
      list.forEach((element) {
        print("type: " + element.runtimeType.toString());
        return Container(

          padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0,
              BlockPaddings.globalBorderPadding, 0),
          child: Container(
              width: double.infinity,
              color: BlockColors.accentColor,
              child: FlatButton(
                child: TextSettings.buttonNameTwoCenter("Начать диалог"),
                onPressed: () {

                },
              )
          ),
        );
      });
    });
  }

  Container getCircleAvatar(){
    return Container(
      padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0, BlockPaddings.globalBorderPadding, 0),
      child: CircleAvatar(
        radius: IconSizes.avatarCircleSize,
        backgroundColor: IconColors.additionalColor,
        child: TextSettings.titleZeroCenter(_name[0] ?? "-" + _surname[0] ?? "-") ,
        foregroundColor: Colors.white,
      ),
    );
  }

  Container getUserName(_inputName){
    return Container(
        padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0, BlockPaddings.globalBorderPadding, 0),
        child: TextSettings.titleOneCenter(_inputName)
    );
  }

  Container getUserSurname(_inputSurname){
    return Container(
        padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0, BlockPaddings.globalBorderPadding, 0),
        child: TextSettings.titleOneCenter(_inputSurname)
    );
  }

  Container getUserSPersonalStatus(_inputUserStatus){
    return Container(
      padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0, BlockPaddings.globalBorderPadding, 0),
        child: TextSettings.descriptionTwoCenter(_inputUserStatus)
    );
  }

  Container setButtonProfileDataEdit(_buttonName){
    if (_buttonName == "Редактировать" || _buttonName == "Добавить в друзья"){
      return Container(

        padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0, BlockPaddings.globalBorderPadding, 0),
        child: Container(
            width: double.infinity,
            color: BlockColors.accentColor,
            child: FlatButton(
              child: TextSettings.buttonNameTwoCenter(_buttonName),
              onPressed: () {

              },
            )
        ),
      );
    }
    else if (_buttonName == "Удалить из друзей"){
      return Container(

        padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0, BlockPaddings.globalBorderPadding, 0),
        child: Container(

            width: double.infinity,
            color: BlockColors.additionalColor,

            child: FlatButton(
              child: TextSettings.buttonNameTwoCenter(_buttonName),
              onPressed: () {

              },
            )
        ),
      );
    }
  }

  Container setDivisionLineOne(){
    return Container(
      padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0, BlockPaddings.globalBorderPadding, 0),
      child: DisignElements.DivisionLineOne(),
    );
  }

  Container setFriendsInformation(var _inputFriendList){
    int _numberOfFriends = 0;

    if (_inputFriendList != null)
      _numberOfFriends = _inputFriendList.length;

    return Container(
      padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0, BlockPaddings.globalBorderPadding, 0),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,

        children: <Widget>[

          Container(
            child: TextSettings.titleTwoLeft("Друзья"),
          ),

          Container(
            child: TextSettings.descriptionOneLeft(NumberExist.getTextNumber("Друзья: ", _numberOfFriends)),
          )
        ],
      ),
    );
  }

  Container setFriendGrid(var _inputFriendList){

    int _numberOfFriends = 0;

    if (_inputFriendList != null)
      _numberOfFriends = _inputFriendList.length;

    if (_numberOfFriends != 0){
      return Container(
        padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0, BlockPaddings.globalBorderPadding, 0),
        child: TextSettings.titleOneCenter("Здесь фото друзей"),
      );
    }

    else if (_numberOfFriends == 0){
      return Container(
        padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0, BlockPaddings.globalBorderPadding, 0),
        child: TextSettings.titleOneCenter("Пусто"),
      );
    }
  }

  Container setPhotoesInformation(var _inputPhotosList){

    int _numberOfPhotos = 0;

    if (_inputPhotosList != null)
      _numberOfPhotos = _inputPhotosList.length;

    return Container(
      padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0, BlockPaddings.globalBorderPadding, 0),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,

        children: <Widget>[

          Container(
            child: TextSettings.titleTwoLeft("Фотографии"),
          ),

          Container(
            child: TextSettings.descriptionOneLeft(NumberExist.getTextNumber("Фотографии: ", _numberOfPhotos)),
          )
        ],
      ),
    );
  }

  Container setPhotoesGrid(var _inputPhotosList){

    int _numberOfPhotos = 0;

    if (_inputPhotosList != null)
      _numberOfPhotos = _inputPhotosList.length;

    if (_numberOfPhotos != 0){
      return Container(
        padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0, BlockPaddings.globalBorderPadding, 0),
        child: TextSettings.titleOneCenter("Здесь блоки фото"),
      );
    }
    else if (_numberOfPhotos == 0){
      return Container(
        padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0, BlockPaddings.globalBorderPadding, 0),
        child: TextSettings.titleOneCenter("Пусто"),
      );
    }
  }

  Container setPostField(bool _isUserProfile){
    if (_isUserProfile == true){
      return Container(
        padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0, BlockPaddings.globalBorderPadding, 0),
        child: Container(
          width: double.infinity,
          child: Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: Colors.white,
            ),
            child: new Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child:    TextFormField(
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
                      color: Colors.black,//this has no effect
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      )
                  ),

                  focusColor: Colors.black,

                  fillColor: Colors.black,
                  hoverColor: Colors.black,
                  border: OutlineInputBorder(),
                  // Вывод данных индекса пользователя в блок до нажатия
                  hintText: "Расскажите, что у Вас нового?",

                  //counterText: _index,
                  //suffixText: _index,
                  //helperText: _name,
                  //semanticCounterText: _name,
                  labelStyle:  TextStyle(color: Colors.black,),
                ),
                onChanged: (value) async {
                  //_name = value;
                },
                //initialValue: "Расскажите, что у Вас нового?",
              ),
            ),
          ),
        ),
      );
    }
  }

  Container setUserCircleAvatarThree(bool _isUserProfile){
    if (_isUserProfile == true)
      return DisignElements.getlCircleAvatarThree();
  }

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (

      appBar: AppBar(
        title: Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: InkWell(

              // Вывод верхнего меню с количеством ваксий и кнопкой сортировки
              child: Text("", style: TextStyle(color: Colors.black),),
            )
        ),

        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          // Кнопка редактирвоания данных профиля
          Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: Row(
                children: <Widget>[
                  Ink(
                    width: 45.0,
                    height: 45.0,
                    decoration: const ShapeDecoration(
                      //color: Colors.grey,
                      shape: CircleBorder(),

                    ),
                    child: IconButton(
                      icon: Icon(Icons.settings),
                      color: TextColors.accentColor,
                      iconSize: 30,
                      onPressed: ()async {
                        await Navigator.push(
                          context,
                          BackdropModalRoute<void>(
                            topPadding: 290.0,
                            overlayContentBuilder: (context) {

                              return SingleChildScrollView(
                                child: Column(
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                                        child:
                                        Row(
                                          children: <Widget>[
                                            Text('Вывести по:', textAlign: TextAlign.left, style: TextStyle(
                                              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500,
                                            ),),

                                            FlatButton(
                                              padding: const EdgeInsets.fromLTRB(130, 0, 0, 0),
                                              onPressed: () => Navigator.pop(context),
                                              child: Row(
                                                children: <Widget>[
                                                  // Кнопка закрытия окна (Крестик)
                                                  IconButton(
                                                    icon: Icon(Icons.close),
                                                    color: TextColors.accentColor,
                                                    iconSize: 30,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      RadioListTile(
                                        activeColor: TextColors.accentColor,
                                        title: const Text('Дате'),
                                        value: 'Дате',
                                        // groupValue: HomePageExe.sortStatus,
                                        onChanged: (String selected) {
                                          // setState((){HomePageExe.sortStatus = selected;
                                          // // Сортировка по убыванию даты (Сначала новые)
                                          // OrdersSearchManager.sortListByParam(HomePageExe.sortStatus);
                                          Navigator.pop(context);

                                        },
                                      ),

                                      RadioListTile(
                                          activeColor: TextColors.accentColor,
                                          title: const Text('Популярности'),
                                          value: 'Популярности',
                                          // groupValue: HomePageExe.sortStatus,
                                          onChanged: (String selected) {
                                            // setState((){HomePageExe.sortStatus = selected;
                                            // Сортировка по убыванию даты (Сначала новые)
                                            // OrdersSearchManager.sortListByParam(HomePageExe.sortStatus);
                                            Navigator.pop(context);
                                          }
                                      ),

                                      RadioListTile(
                                        activeColor: TextColors.accentColor,
                                        title: const Text('Увеличению оклада'),
                                        value: 'Увеличению оклада',
                                        // groupValue: HomePageExe.sortStatus,
                                        onChanged: (String selected) {
                                          // setState((){HomePageExe.sortStatus = selected;
                                          // // Сортировка по убыванию даты (Сначала новые)
                                          // OrdersSearchManager.sortListByParam(HomePageExe.sortStatus);
                                          Navigator.pop(context);
                                        },
                                      ),

                                      RadioListTile(
                                        activeColor: TextColors.accentColor,
                                        title: const Text('Уменьшению оклада'),
                                        value: 'Уменьшению оклада',
                                        // groupValue: HomePageExe.sortStatus,
                                        onChanged: (String selected) {
                                          // setState((){HomePageExe.sortStatus = selected;
                                          // Сортировка по убыванию даты (Сначала новые)
                                          // OrdersSearchManager.sortListByParam(HomePageExe.sortStatus);
                                          Navigator.pop(context);
                                        },
                                      ),

                                      RadioListTile(
                                        activeColor: TextColors.accentColor,
                                        title: const Text('Увеличению требований'),
                                        value: 'Увеличению требований',
                                        // groupValue: HomePageExe.sortStatus,
                                        onChanged: (String selected) {
                                          // setState((){HomePageExe.sortStatus = selected;
                                          // Сортировка по убыванию даты (Сначала новые)
                                          // OrdersSearchManager.sortListByParam(HomePageExe.sortStatus);
                                          Navigator.pop(context);
                                        },
                                      ),

                                      RadioListTile(
                                          activeColor: TextColors.accentColor,
                                          title: const Text('Уменьшению требований'),
                                          value: 'Уменьшению требований',
                                          // groupValue: HomePageExe.sortStatus,
                                          onChanged: (String selected) {
                                            // setState((){HomePageExe.sortStatus = selected;
                                            // Сортировка по убыванию даты (Сначала новые)
                                            // OrdersSearchManager.sortListByParam(HomePageExe.sortStatus);
                                            Navigator.pop(context);
                                          }
                                      ),

                                    ]



                                ),
                              );

                            },
                          ),
                        );
                      },
                    ),
                  ),

                ],
              )

          ),
        ],
      ),

      body: SingleChildScrollView(
        child: new Column(

          children: <Widget>[

            SizedBox(height: 20,),

            // Верхний блок личных данных
            Center(
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,

                children: <Widget>[
                  // Получение аватара пользователя
                  getCircleAvatar(),

                  SizedBox(height: 20,),

                  // Получение имени пользователя
                  getUserName(_name),

                  // Получение фамилии пользователя
                  getUserSurname(_surname),

                  SizedBox(height: 20,),

                  // Получение фамилии пользователя
                  getUserSPersonalStatus(_status),

                  SizedBox(height: 20,),

                  // Получение фамилии пользователя
                  setButtonProfileDataEdit("Редактировать"),



                  SizedBox(height: 20,),
                ],
              ),
            ),

            DisignElements.setDivisionFieldOne(),

            // Блок с фотографиями пользователя
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,

              children: <Widget>[
              SizedBox(height: 20,),

              setPhotoesInformation(_photos),

              SizedBox(height: 10,),

              setPhotoesGrid(_photos),

                SizedBox(height: 20,),
              ]
            ),

            DisignElements.setDivisionFieldOne(),

            // Блок с иконками друзей
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,

                children: <Widget>[
                  SizedBox(height: 20,),

                  setFriendsInformation(_friends),

                  SizedBox(height: 10,),

                  setFriendGrid(_friends),

                  SizedBox(height: 20,),
                ],
              ),

            DisignElements.setDivisionFieldOne(),

            SizedBox(height: 20,),

            // Блок ввода данных Name
            setPostField(true),

            SizedBox(height: 20,),

            DisignElements.setDivisionFieldOne(),

            SizedBox(height: 1000,),
          ],
        ),
      ),
    );
  }
}
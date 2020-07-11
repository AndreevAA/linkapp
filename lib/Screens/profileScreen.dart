import 'package:backdrop_modal_route/backdrop_modal_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/AdditionalFunctions/createdElements.dart';
import 'package:linkapp/AdditionalFunctions/textFormating.dart';
import 'package:linkapp/Screens/chatScreen.dart';
import 'package:linkapp/Screens/dialogsScreen.dart';
import 'package:linkapp/Screens/profileDataEditingScreen.dart';
import 'package:linkapp/Service/DataBaseNamings.dart';
import 'package:linkapp/Service/FBManager.dart';
import 'package:linkapp/Service/NotifManager.dart';
import 'package:linkapp/Service/UserSettings.dart';
import 'package:linkapp/Settings/blockStyleSettings.dart';
import 'package:linkapp/Settings/iconStyleSettings.dart';
import 'package:linkapp/Settings/textStyleSettings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Registration.dart';
import 'accountSettingsScreen.dart';
import 'createPost.dart';
import 'friendsScreen.dart';

class ProfileScreen extends StatefulWidget{

  static bool blocked = false;


  DocumentSnapshot document;
  ProfileScreen({@required this.document});

  static Future<void> exitUser(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    UserSettings.userDocument = null;
    UserSettings.UID = null;
    FirebaseAuth.instance.signOut();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Regist()));
  }

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
    _token = (document.documentID ?? 'null').toString();

    _friends = document['friends'] ?? new List();
    _followers = document['followers'] ?? new List();
    _publics = document['publics'] ?? new List();
    _dialogs = document['dialogs'] ?? new List();

    _buttonMessageExistance = false;
    _isAuthorProfile = false;

    dateCtl = TextEditingController();


    _tempPositionCursor = -1;
  }

  String _name, _surname, _gender, _country, _birthday, _patent, _status, _token;

  bool _isAuthorProfile, _buttonMessageExistance, _isFriends = false;

  //bool _buttonMessageExistance, _isAuthorProfile;

  List<dynamic> _friends, _followers, _publics, _photos, _dialogs;

  TextEditingController dateCtl;

  static int _tempPositionCursor;

  Container startDialogueButton(DocumentSnapshot documentSnapshot) {

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

  Container setButtonProfileDataEdit(){

    String _buttonOneText = "";
    String _buttonTwoText = "Написать";

    if (ProfileScreen.blocked)
      return Container(

        padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0, BlockPaddings.globalBorderPadding, 0),
        child: Container(

            width: double.infinity,

            decoration:  BoxDecoration(
              borderRadius:  BorderRadius.circular(20.0),

              color: TextColors.deactivatedColor,
            ),
            child: FlatButton(
              child: Text("Загрузка"),
              onPressed: () {

              },
            )
        ),
      );

    if (_isAuthorProfile == true){
      _buttonOneText = "Редактировать";

      return Container(

        padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0, BlockPaddings.globalBorderPadding, 0),
        child: Container(

            width: double.infinity,

            decoration:  BoxDecoration(
              borderRadius:  BorderRadius.circular(20.0),

              color: BlockColors.accentColor,
            ),
            child: FlatButton(
              child: TextSettings.buttonNameTwoCenter(_buttonOneText),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => ProfileDataEditing())
                );
              },
            )
        ),
      );
    }
    else if (_isAuthorProfile == false){
      if (_isFriends == true){
        _buttonOneText = "  Удалить из друзей    ";

        return Container(

          padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0, BlockPaddings.globalBorderPadding, 0),

          child: Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: <Widget>[
              Container(

                  //width: double.infinity,


                  decoration: BoxDecoration(
                      borderRadius:  BorderRadius.circular(20.0),
                    color: BlockColors.additionalColor,
                  ),

                  child: FlatButton(
                    child: TextSettings.buttonNameTwoCenter(_buttonOneText),
                    onPressed: () async {
                      List _friendsListOne = UserSettings.userDocument['friends'] ;
                      List _friendsListTwo = _friends;

                      print(_friendsListOne);

                      List _friendsListOneNew = [];
                      List _friendsListTwoNew = [];

                      int _friendsListOneLength = 0, _friendsListTwoLength = 0;

                      if (_friendsListOne != null)
                        _friendsListOneLength = _friendsListOne.length;

                      if (_friendsListTwo != null)
                        _friendsListTwoLength = _friendsListTwo.length;

                      for (int i = 0; i < _friendsListOneLength; i++){
                        if (_friendsListOne[i].toString() != UserSettings.UID.toString()) {
                          _friendsListOneNew.add(_friendsListOne[i].toString());
                        }
                      }

                      for (int i = 0; i < _friendsListTwoLength; i++){
                        if (_friendsListTwo[i].toString() != _token.toString() ) {
                          _friendsListTwoNew.add(_friendsListTwo[i].toString());
                        }
                      }

                      print(_friendsListOneNew);
                      print(_friendsListTwoNew);

                      setState(() {
                        ProfileScreen.blocked = true;
                      });
                      FBManager.fbStore
                          .collection(USERS_COLLECTION)
                          .document(UserSettings.UID)
                          .updateData({
                        'friends': _friendsListTwoNew ?? []
                      }).then((val) async {
                        UserSettings.userDocument = await FBManager.getUser(UserSettings.UID);
                        setState(() {
                          _isFriends = false;
                          ProfileScreen.blocked = false;
                        });
                      });

                      FBManager.fbStore
                          .collection(USERS_COLLECTION)
                          .document(_token.toString())
                          .updateData({
                        'friends': _friendsListOneNew ?? []
                      }).then((val) async {
//                        UserSettings.userDocument = await FBManager.getUser(_token.toString());
                        setState(() {
                          _isFriends = false;
                          ProfileScreen.blocked = false;
                        });
                      });

                      print(UserSettings.userDocument.data['friends'].toString());

                      _buttonMessageExistance = false;
                      _isAuthorProfile = false;

                      FriendsScreen.needsUpdate = true;
                    },
                  )
              ),

              Container(

                  decoration: BoxDecoration(
                    borderRadius:  BorderRadius.circular(20.0),
                    color: BlockColors.accentColor,
                  ),

                //width: double.infinity,
                  //color: BlockColors.accentColor,

                  child: FlatButton.icon(
                    icon: Icon(Icons.message, color: Colors.white,),

                    label: TextSettings.buttonNameTwoCenter(_buttonTwoText),

                    onPressed: () async {

                      // Если диалог уже начат, то переходим на страницу диалога
                      FBManager.addPrivateChat(_token, _name).then((val) async {
                        await FBManager.fbStore
                            .collection(USERS_COLLECTION)
                            .document(UserSettings.UID.toString())
                            .updateData({
                          'dialogs' : UserSettings.userDocument['dialogs'] + [UserSettings.UID.toString().substring(0, 14) + _token.toString().substring(14)],
                        });
                        await FBManager.fbStore
                            .collection(USERS_COLLECTION)
                            .document(_token.toString())
                            .updateData({
                          'dialogs' : _dialogs + [UserSettings.UID.toString().substring(0, 14) + _token.toString().substring(14)],
                        });
                        UserSettings.userDocument = await FBManager.getUserStats(UserSettings.UID);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderChatView(chatUid: UserSettings.UID.toString().substring(0, 14) + _token.substring(14),)));
                      });


                        // Обновление данных document из FB


                        FriendsScreen.needsUpdate = true;

                        // Закрытие окна и возврат в профиль
                        Navigator.pop(context, true);
                      },
                )
              ),
            ],
          ),
        );
      }
      else if (_isFriends == false){
        _buttonOneText = "Добавить в друзья";

        return Container(

          padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0, BlockPaddings.globalBorderPadding, 0),
          child: Container(
              decoration: BoxDecoration(
                borderRadius:  BorderRadius.circular(20.0),
                color: BlockColors.accentColor,
              ),

              width: double.infinity,

              child: FlatButton(
                child: TextSettings.buttonNameTwoCenter(_buttonOneText),
                onPressed: () async {
                  List _friendsListOne = UserSettings.userDocument['friends'];
                  List _friendsListTwo = UserSettings.userDocument['friends'];

                  _friendsListOne.add(UserSettings.UID.toString());
                  _friendsListTwo.add(_token.toString());

                  setState(() {
                    ProfileScreen.blocked = true;
                  });

                  FBManager.fbStore
                      .collection(USERS_COLLECTION)
                      .document(UserSettings.UID)
                      .updateData({
                    'friends': _friendsListTwo ?? []
                  }).then((val) async {
                    UserSettings.userDocument = await FBManager.getUser(UserSettings.UID);
                    setState(() {
                      _isFriends = true;
                      ProfileScreen.blocked = false;
                    });
                  });

                  FBManager.fbStore
                      .collection(USERS_COLLECTION)
                      .document(_token.toString())
                      .updateData({
                    'friends': _friendsListOne ?? []
                  }).then((val) async {
                    UserSettings.userDocument = await FBManager.getUser(_token.toString());
                    setState(() {
                      _isFriends = true;
                      ProfileScreen.blocked = false;
                    });
                  });

                  _buttonMessageExistance = true;
                  _isAuthorProfile = false;

                  FriendsScreen.needsUpdate = true;

                },
              )
          ),
        );
      }
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

  Container setFriendsPicture(int _numberOfFriends, var _inputFriendList){
      _tempPositionCursor++;

      //print(_tempPositionCursor);
      print(_numberOfFriends);

      String _tempName;

      if (_tempPositionCursor < _numberOfFriends) {
        _tempName = _inputFriendList[_tempPositionCursor].toString();

        return Container(
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: IconSizes.avatarCircleSizeThree,
                backgroundColor: IconColors.additionalColor,
                child: TextSettings.titleZeroCenter(_tempName[0]),
                foregroundColor: Colors.white,
              ),

              SizedBox(height: 5,),

//              Container(
//                  padding: const EdgeInsets.fromLTRB(
//                      BlockPaddings.globalBorderPadding, 0,
//                      BlockPaddings.globalBorderPadding, 0),
//                  child: TextSettings.descriptionTwoCenter(_tempName)
//              ),
            ],
          ),
        );
      }
      else{
        return Container();
      }
  }

 Container setFriendGrid(var _inputFriendList){

    int _numberOfFriends = 0;
    _tempPositionCursor  = -1;

    if (_inputFriendList != null)
      _numberOfFriends = _inputFriendList.length;

    if (_numberOfFriends != 0){
      return Container(
        padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0, BlockPaddings.globalBorderPadding, 0),
        height: 100,
        child: GridView.count(
          scrollDirection: Axis.horizontal,
          crossAxisCount: 1,
          children: <Widget>[
            setFriendsPicture(_numberOfFriends, _inputFriendList),
            setFriendsPicture(_numberOfFriends, _inputFriendList),
            setFriendsPicture(_numberOfFriends, _inputFriendList),
          ]
        ),
      );
    }

    else if (_numberOfFriends == 0){
      return Container(
        padding: const EdgeInsets.fromLTRB(BlockPaddings.globalBorderPadding, 0, BlockPaddings.globalBorderPadding, 0),
        //child: TextSettings.titleOneCenter("Пусто"),
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
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePost()));
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

  Container setSettingsWidget(bool _isAuthorProfile){
    if (_isAuthorProfile == true){
      // Кнопка редактирвоания данных профиля
      return Container(
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountSettings()));
                    },
                  ),
                ),
              ],
            )
        );
    }
    else {
      return Container();
    }
  }

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    print("building prifile");
    // Переход в текущий профиль - это профиль владельца
    if (UserSettings.UID.toString() == _token.toString()){
      _isAuthorProfile = true;
      _buttonMessageExistance = false;
    }

    else if (_token.toString() != UserSettings.userDocument['token'].toString()){
      _isAuthorProfile = false;
      _buttonMessageExistance = true;
    }

    print("1 " + UserSettings.userDocument['friends'].toString() + " | " + _token);
    print("2 " + _friends.contains(_token).toString());

    if (UserSettings.userDocument['friends'].contains(_token) == true || _friends.contains(_token) == true){

      _isFriends = true;
    }

    print("\n\n_isAuthorProfile: " + _isAuthorProfile.toString());

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
          setSettingsWidget(_isAuthorProfile),
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
                  setButtonProfileDataEdit(),



                  SizedBox(height: 20,),
                ],
              ),
            ),

            DisignElements.setDivisionFieldOne(),

//            // Блок с фотографиями пользователя
//            Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              mainAxisSize: MainAxisSize.min,
//
//              children: <Widget>[
//              SizedBox(height: 20,),
//
//              setPhotoesInformation(_photos),
//
//              SizedBox(height: 10,),
//
//              setPhotoesGrid(_photos),
//
//                SizedBox(height: 20,),
//              ]
//            ),
//
//            DisignElements.setDivisionFieldOne(),

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


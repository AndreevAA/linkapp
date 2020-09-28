
import 'package:backdrop_modal_route/backdrop_modal_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/AdditionalFunctions/createdElements.dart';
import 'package:linkapp/AdditionalFunctions/textFormating.dart';
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
import 'package:timeago/timeago.dart' as timeago;

import 'Registration.dart';
import 'accountSettingsScreen.dart';
import 'cardView.dart';
import 'chatScreen.dart';
import 'createPost.dart';
import 'friendsScreen.dart';

class FriendsGrid extends StatefulWidget {
  static bool blocked = false;

  DocumentSnapshot document;
  FriendsGrid({@required this.document});

  static Future<void> exitUser(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    UserSettings.userDocument = null;
    UserSettings.UID = null;
    FirebaseAuth.instance.signOut();

    Navigator.push(context, MaterialPageRoute(builder: (context) => Regist()));
  }

  @override
  _FriendsGridState createState() => _FriendsGridState(document);
}

class _FriendsGridState extends State<FriendsGrid>
{
  _FriendsGridState(DocumentSnapshot document) {
    _name = (document['name'] ?? 'null').toString();
    _surname = (document['surname'] ?? 'null').toString();
    _gender = (document['gender'] ?? 'null').toString();
    _country = (document['country'] ?? 'null').toString();
    _birthday = (document['birthday'] ?? 'null').toString();
    _patent = (document['patent'] ?? 'null').toString();
    _status = (document['status'] ?? 'null').toString();
    _token = (document['token'] ?? 'null').toString();

    _friends = document['friends'] ?? new List();
    _followers = document['followers'] ?? new List();
    _publics = document['publics'] ?? new List();
    _dialogs = document['dialogs'] ?? new List();
    _posts = document['posts'] ?? new List();

    _ispublic = document['ispublic'] ?? false;

    _buttonMessageExistance = false;
    _isAuthorProfile = false;

    dateCtl = TextEditingController();

    _tempPositionCursor = -1;
  }

  String _name,
      _surname,
      _gender,
      _country,
      _birthday,
      _patent,
      _status,
      _token;

  bool _isAuthorProfile, _buttonMessageExistance, _isFriends = false, _ispublic;

  //bool _buttonMessageExistance, _isAuthorProfile;

  List<dynamic> _friends, _followers, _publics, _photos, _dialogs, _posts;

  TextEditingController dateCtl;

  static int _tempPositionCursor;

  Container setFriendsPicture(int _numberOfFriends, var _inputFriendList) {
    _tempPositionCursor++;

    //print(_tempPositionCursor);
    print(_numberOfFriends);

    String _tempName;

    if (_tempPositionCursor < _numberOfFriends) {
      _tempName = _inputFriendList[_tempPositionCursor].toString();

      return Container(
        child: FutureBuilder(
            future:
            FBManager.fbStore.collection('users').document(_tempName).get(),
            builder: (context, AsyncSnapshot getNameSnap) {
              if (!getNameSnap.hasData) {
                if (getNameSnap.data == null) {
                  return Container();
                }
              }
              return Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: IconSizes.avatarCircleSizeThree,
                    backgroundColor: IconColors.additionalColor,
                    child: TextSettings.titleZeroCenter(  getNameSnap.data['name'][0]),
                    foregroundColor: Colors.white,
                  ),

//                  Container(
//                    child: FutureBuilder(
//                        future: FBManager.fbStore
//                            .collection('users')
//                            .document(_tempName)
//                            .get(),
//                        builder: (context, AsyncSnapshot getNameSnap) {
//                          if (!getNameSnap.hasData) {
//                            if (getNameSnap.data == null) {
//                              return Text('...');
//                            }
//                          }
//                          return Container(
//
//                              child: TextSettings.descriptionTwoCenter(
//                                  getNameSnap.data['name']));
//                        }),
//                  ),
                ],
              );
            }),
      );
    } else {
      return Container();
    }
  }

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    var _numberOfFriends;
    var _inputFriendList = _friends;

    if (_inputFriendList != null) _numberOfFriends = _inputFriendList.length;

    return Scaffold(
        appBar: AppBar(
              title: Text(
              "Друзья",
              style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(0,
              0, 0, 0),
          height: 100,
          child: GridView.count(
              scrollDirection: Axis.horizontal,
              crossAxisCount: 1,
              children: <Widget>[
                setFriendsPicture(_numberOfFriends, _inputFriendList),
                setFriendsPicture(_numberOfFriends, _inputFriendList),
                setFriendsPicture(_numberOfFriends, _inputFriendList),
              ]),
        ),
    );
  }
}
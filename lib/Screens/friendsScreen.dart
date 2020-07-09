import 'package:backdrop_modal_route/backdrop_modal_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/Screens/profileScreen.dart';
import 'package:linkapp/Service/FBManager.dart';
import 'package:linkapp/Service/UserSettings.dart';
import 'package:linkapp/Settings/textStyleSettings.dart';

import 'accountSettingsScreen.dart';
import 'findFriends.dart';

class FriendsScreen extends StatefulWidget {

  static bool needsUpdate = false;

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  static List<DocumentSnapshot> friendsList;

  List<Map<String, dynamic>> fakeData = [
    {
      "name": "Мадина",
      "status": "Кулинарная мастерица",
      "seen": "2019-10-11T13:33:05.673",
      "origin": "Киргистан"
    },
    {
      "name": "Николай",
      "status": "Работа и бизнес💎",
      "seen": "2019-10-11T13:33:05.673",
      "origin": "Украина"
    },
    {
      "name": "Ахмед",
      "status": "😎😎кто не с нами тот не с нами",
      "seen": "2019-10-11T13:33:05.673",
      "origin": "Россия"
    },
    {
      "name": "Мухамед",
      "status": "Водитель вашей хуйни🚗",
      "seen": "2019-10-11T13:33:05.673",
      "origin": "Киргистан"
    },
  ];

  @override
  Widget build(BuildContext context) {
    print("building friendsScreen update " + FriendsScreen.needsUpdate.toString());
//    if (FriendsScreen.needsUpdate){
//      setState(() {
//        FriendsScreen.needsUpdate = false;
//      });
//    }

    if (_FriendsScreenState.friendsList == null || FriendsScreen.needsUpdate) {
      FriendsScreen.needsUpdate = false;
      if (UserSettings.userDocument['friends'].isNotEmpty)
        FBManager.getFriendsList(UserSettings.userDocument['friends'])
            .then((list) {
          setState(() {
            print("got " + (list ?? new List()).length.toString() + " friends");
            _FriendsScreenState.friendsList = list;
          });
        });
      else
        _FriendsScreenState.friendsList = new List();
    }

    return Scaffold(
        appBar: AppBar(
          title: Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: InkWell(
                // Вывод верхнего меню с количеством ваксий и кнопкой сортировки
                child: Text(
                  "Друзья",
                  style: TextStyle(color: Colors.black),
                ),
              )),
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FindFriends()));
            // showDialog(context);
//            //OrdersSearchManager.sortListByDate();
          },
          child: Icon(Icons.search),
          backgroundColor: TextColors.accentColor,
        ),
        body: Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: friendsList == null
              ? CircularProgressIndicator()
              : friendsList.isEmpty
                  ? Text(
                      "К сожалению, друзей нет...",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                    )
                  : ListView(
                      children: friendsList.map((DocumentSnapshot document) {
                        // Logs.addNode("OrdersSearchView", "build",
                        // "Document:\n" + document.document
                        return new CustomCard(document: document);
                      }).toList(),
                    ),
        )));
  }
}

class CustomCard extends StatefulWidget {
  // CustomCard({@required this.document, @required this.previousScreenContext, @required this.homePageScreen});

   final DocumentSnapshot document;

  CustomCard({@required this.document});

  @override
  _CustomCard createState() => _CustomCard(document: document);
}

class _CustomCard extends State<CustomCard> {
  _CustomCard({@required this.document});

  final DocumentSnapshot document;

  String formatOutput(String temp, int maxLength) {
    if (temp.length <= maxLength)
      return temp;
    else
      return temp.substring(0, maxLength).trim() + "...";
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: <Widget>[
          InkWell(
            onTap: () async {
              Navigator.push (
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen(document: document,)),
              );
            },
            child: Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(14, 0, 0, 10),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: TextColors.accentColor,
                    child: Text(
                      document['name'][0],
                      style:
                      (TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0)),
                    ),
                    foregroundColor: Colors.white,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 15),
                    Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 2.0),
                      child: Text(
                        document['name'] ?? "ER",
                        // HomePageExe.formatOutput(HomePageExe.replaceSymbols(HomePageExe.replaceSymbols(HomePageExe.deleteSmiles(runeSubstring(input: document['title'] ?? 'Ошибка описания', start: 0, end: (document['title'] ?? 'Ошибка описания').toString().length < 20 ? (document['title'] ?? 'Ошибка описаня').toString().length : 20)), "\n", " "), "  ", " "), 20).replaceAll("\n\n", "\n"),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    // Блок размера оплаты труда
//                Container(
//                  height: 30,
//                  padding: const EdgeInsets.fromLTRB(20, 1, 0, 0),
//                  child: Text(
//                    // concatMinMax(document['min_price'], document['max_price']) +
//                    // " / " + document['pay_type'] ?? "",
//                    formatOutput(document['status'] ?? "ERR", 35),
//                    style: TextStyle(
//                        fontSize: 14.0,
//                        color: TextColors.accentColor,
//                        fontWeight: FontWeight.bold),
//                  ),
//                ),

                    Container(
                      height: 30,
                      padding: const EdgeInsets.fromLTRB(20, 1, 0, 11),
                      child: Text(
                        // concatMinMax(document['min_price'], document['max_price']) +
                        // " / " + document['pay_type'] ?? "",
                        "Был(-а) в сети: " +
                            ((document['seen'] ?? Timestamp.now()) as Timestamp).toDate().toIso8601String().substring(0, 10),
                        style: TextStyle(
                            fontSize: 11.0,
                            color: TextColors.deactivatedColor,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),

//            Ink(
//              width: 45.0,
//              height: 45.0,
//              decoration: const ShapeDecoration(
//                //color: Colors.grey,
//                shape: CircleBorder(),
//
//              ),
//              child: IconButton(
//                icon: Icon(Icons.settings),
//                color: TextColors.accentColor,
//                iconSize: 30,
//                onPressed: () {
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => AccountSettings()));
//                },
//              ),
//            ),
              ],
            ),
          ),

          Ink(
            width: 45.0,
            height: 45.0,
            decoration: const ShapeDecoration(
              //color: Colors.grey,
              shape: CircleBorder(),

            ),
            child: IconButton(
              icon: Icon(Icons.more_vert),
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
                              SizedBox(height: 10,),
//                              Container(
//                                alignment: Alignment.center,
//                                padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
//                                child:
//                                Row(
//                                  children: <Widget>[
//                                    Text('Вывести по:', textAlign: TextAlign.left, style: TextStyle(
//                                      color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500,
//                                    ),),
//
//                                    FlatButton(
//                                      padding: const EdgeInsets.fromLTRB(130, 0, 0, 0),
//                                      onPressed: () => Navigator.pop(context),
//                                      child: Row(
//                                        children: <Widget>[
//                                          // Кнопка закрытия окна (Крестик)
//                                          IconButton(
//                                            icon: Icon(Icons.close),
//                                            color: TextColors.accentColor,
//                                            iconSize: 30,
//                                          )
//                                        ],
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                              ),
                              Row(

                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: <Widget>[

                                  SizedBox(width: 10,),

                                  Icon(Icons.message, color: Colors.black,),

                                  FlatButton(
                                    child: TextSettings.buttonNameTwoCenter("Написать"),
                                  ),

                                ],
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

    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:backdrop_modal_route/backdrop_modal_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/Screens/friendsScreen.dart';
import 'package:linkapp/Screens/profileScreen.dart';
import 'package:linkapp/Service/FBManager.dart';
import 'package:linkapp/Service/UserSettings.dart';
import 'package:linkapp/Settings/blockStyleSettings.dart';
import 'package:linkapp/Settings/textStyleSettings.dart';

import 'chatScreen.dart';

class DialogsScreen extends StatefulWidget {
  static int timer = 0;

  @override
  _DialogsScreenState createState() => _DialogsScreenState();
}

class _DialogsScreenState extends State<DialogsScreen> {
  List<DocumentSnapshot> dialogsList;

  DocumentSnapshot getFromFriends(String uid) {
    (FriendsScreen.friendsList ?? new List()).forEach((snap) {
      if (snap.documentID == uid) {
        print("returning " + snap.documentID + " | " + uid);
        return snap;
      }
    });

    return null;
  }

  Timer _timer;
  int _start = 0;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      if (_start < 1) {
        timer.cancel();
        setState(() {});
      } else {
        _start = _start - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("building friendsScreen update " +
        FriendsScreen.needsUpdate.toString());
//    if (FriendsScreen.needsUpdate){
//      setState(() {
//        FriendsScreen.needsUpdate = false;
//      });
//    }

//    if (_FriendsScreenState.friendsList == null || FriendsScreen.needsUpdate) {
//      FriendsScreen.needsUpdate = false;
//      if (UserSettings.userDocument['friends'].isNotEmpty)
//        FBManager.getFriendsList(UserSettings.userDocument['friends'])
//            .then((list) {
//          setState(() {
//            print("got " + (list ?? new List()).toString() + " friends");
//            _FriendsScreenState.friendsList = list;
//          });
//        });
//      else
//        _FriendsScreenState.friendsList = new List();
//    }
    if (dialogsList == null)
      FBManager.getChatsList().then((List chatlist) {
        setState(() {
//          startTimer();
          //        sleep(Duration(seconds: DialogsScreen.timer));
          //        DialogsScreen.timer += 2;

          dialogsList = chatlist;
        });
      });

    return Scaffold(
        appBar: AppBar(
          title: Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: InkWell(
                // Вывод верхнего меню с количеством ваксий и кнопкой сортировки
                child: Text(
                  "Диалоги",
                  style: TextStyle(color: Colors.black,fontSize: 24),
                ),
              )),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FriendsScreen()));
            // showDialog(context);
//            //OrdersSearchManager.sortListByDate();
          },
          child: Icon(Icons.add),
          backgroundColor: TextColors.accentColor,
        ),
        body: Center(
            child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: dialogsList == null
              ? CircularProgressIndicator()
              : dialogsList.isEmpty
                  ? Text(
                      "К сожалению, диалогов нет...",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                    )
                  : ListView(
                      children: dialogsList.map((DocumentSnapshot document) {
                        // Logs.addNode("OrdersSearchView", "build",
                        // "Document:\n" + document.document
                        return new CustomCard(
                          document: document,
                          //        friendDocument: getFromFriends(document['users'][0] == UserSettings.UID ? document['users'][1] : document['users'][0]
                        );
                      }).toList(),
                    ),
        )));
  }
}

class CustomCard extends StatefulWidget {
  // CustomCard({@required this.document, @required this.previousScreenContext, @required this.homePageScreen});

  final DocumentSnapshot document;
//  final DocumentSnapshot friendDocument;

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
    print("type: " + document.data.toString());

    if (document['names'] != null){

    }
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: () async {
            print("pressed");
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderChatView(
                        chatUid: document.documentID,
                        listOfUids:
                            (document['users'] as List).cast<String>().toList(),
                      )),
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
                    ((document)['names'] ?? ['err'])[0] ==
                            UserSettings.userDocument['name']
                        ? document['names'][1][0]
                        : document['names'][0][0],
                    style: (TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 22.0)),
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
                    padding: const EdgeInsets.fromLTRB(
                        BlockPaddings.globalBorderPadding,
                        2,
                        0,
                        2),
                    child: Text(
                      document['names'][0] == UserSettings.userDocument['name']
                          ? document['names'][1]
                          : document['names'][0],
                      // HomePageExe.formatOutput(HomePageExe.replaceSymbols(HomePageExe.replaceSymbols(HomePageExe.deleteSmiles(runeSubstring(input: document['title'] ?? 'Ошибка описания', start: 0, end: (document['title'] ?? 'Ошибка описания').toString().length < 20 ? (document['title'] ?? 'Ошибка описаня').toString().length : 20)), "\n", " "), "  ", " "), 20).replaceAll("\n\n", "\n"),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Container(
                    height: 30,
                    padding: const EdgeInsets.fromLTRB(20, 1, 0, 11),
                    child: Text(
                      // concatMinMax(document['min_price'], document['max_price']) +
                      // " / " + document['pay_type'] ?? "",

                      (((document['messages'] ?? [null])[0] ??
                                      {
                                        "text": "Напишите сообщение!"
                                      })['text'] ??
                                  "er")
                              .toString()
                              .substring(
                                  0,
                                  (((document['messages'] ?? [null])[0] ??
                                                      {
                                                        "text":
                                                            "Напишите сообщение!"
                                                      })['text'] ??
                                                  "er")
                                              .length >
                                          16
                                      ? 16
                                      : (((document['messages'] ?? [null])[0] ??
                                                  {
                                                    "text":
                                                        "Напишите сообщение!"
                                                  })['text'] ??
                                              "er")
                                          .length) +
                          "...",
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
            onPressed: () async {
              await Navigator.push(
                context,
                BackdropModalRoute<void>(
                  topPadding: 550.0,
                  overlayContentBuilder: (context) {
                    return SingleChildScrollView(
                      child: Column(children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.message,
                              color: Colors.black,
                            ),
                            FlatButton(
                              child: Text(
                                "Написать сообщение",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            FlatButton(
                              child: Text(
                                "Удалить из друзей",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ]),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    ));
  }
}

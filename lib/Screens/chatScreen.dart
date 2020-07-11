import 'dart:io';

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:call_with_whatsapp/call_with_whatsapp.dart';
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/Service/FBManager.dart';
import 'package:linkapp/Service/NotifManager.dart';
import 'package:linkapp/Service/UserSettings.dart';
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:timeago/timeago.dart' as timeago;
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67

import 'LogsView.dart';

class OrderChatView extends StatefulWidget {
  final String chatUid;
  final List<String> listOfUids;
  OrderChatView({@required this.chatUid, @required this.listOfUids});

  @override
  _OrderChatView createState() => _OrderChatView(chatUid: chatUid);
}

class _OrderChatView extends State<OrderChatView> {
  final String chatUid;
  bool requestingUsersList = true;
  String _messageText;
  Stream messageStream;
  final List<String> listOfUids;
  List<DocumentSnapshot> listOfUsers;
  TextEditingController _textEditingController;
  _OrderChatView({@required this.chatUid, @required this.listOfUids});

  void sendMessage(context) {
    if (_messageText != null &&
        _messageText.trim() != ' ' &&
        _messageText.trim() != '')
      try {
        FBManager.sendMessage(chatUid, _messageText.trim());
        Logs.addNode(
            "OrderChatView",
            "sendMessage",
            listOfUsers
                .map((DocumentSnapshot snap) {
                  return snap['device_token'];
                })
                .toList()
                .toString());
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD

=======
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
//        NotifManager.NotifyUsersOfMessage(
//            listOfUsers
//                .map((DocumentSnapshot snap) {
//                  return (snap['device_token'] ?? "err").toString();
//                })
//                .toList()
//                .cast<String>(),
//            order.documentID,
//            UserSettings.userDocument['name'],
//            _messageText,
//            order['title']);
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67

        _textEditingController.clear();
        _messageText = '';
      } catch (e) {
        Logs.addNode("OrderChatView", "sendMessage", e.toString());
      }
//    listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
//    TODO это похоже на штуку которая скролит вниз при обновлении
  }

  @override
  void initState() {
    Logs.addNode(
        "OrderChatView", "initState", "UserToken: " + UserSettings.UID);
    messageStream = FBManager.getChatStream(chatUid);
    _textEditingController = new TextEditingController(text: _messageText);
//    listOfUsers = List<DocumentSnapshot>(0);
  }

  DocumentSnapshot getDocument(String uid) {
    for (DocumentSnapshot snap in listOfUsers)
      if (snap.documentID == uid) {
        print('returning ' + snap.documentID + " - " + uid);
        return snap;
      }
    print("returning null");
    return null;
  }
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  String titleName = ' ';
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67

  @override
  Widget build(BuildContext context) {
    print("chatScreen building");
    if (listOfUsers == null) {
      FBManager.getUsersList(listOfUids).then((list) {
        setState(() {
          print("got list: " + list.length.toString());
          listOfUsers = list;
          requestingUsersList = false;
        });
      });
    }
//    FBManager.getUsersList(((order['query'] as List) +
//                (order['applied'] as List) +
//                List<String>.of([order['token']]))
//            .toList()
//            .cast<String>())
//        .then((List list) {
//      listOfUsers = list;
//    });


<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD

=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text(
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
          "захаркодино",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.call),
              color: Colors.green,
              iconSize: 30,
              onPressed: () {
                CallWithWhatsapp.requestPermissions().then((x){
                  print("success");
                }).catchError((e){
                  print(e);
                });
                CallWithWhatsapp.initiateCall("89267105770").then((x){
                  print("success");
                }).catchError((e){
                  print(e);
                });
              }),
        ],
=======
          'Обсуждение вакансии',
          style: TextStyle(color: Colors.black),
        ),
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
          'Обсуждение вакансии',
          style: TextStyle(color: Colors.black),
        ),
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
          'Обсуждение вакансии',
          style: TextStyle(color: Colors.black),
        ),
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
          'Обсуждение вакансии',
          style: TextStyle(color: Colors.black),
        ),
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
          'Обсуждение вакансии',
          style: TextStyle(color: Colors.black),
        ),
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
      ),
      body: Container(
        child: Column(children: <Widget>[
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: messageStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (requestingUsersList)
                  return CircularProgressIndicator();
                if (snapshot.data == null) {
                  return Center(
                    child: Text("Пусто"),
                  );
                }
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text("Загрузка");
                  default:
                    return ListView(
                      reverse: true,
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD

                        print("authro ; " + (getDocument(document['author']) == null).toString());
=======
                            print("authro ; " + (getDocument(document['author']) == null).toString());
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
                            print("authro ; " + (getDocument(document['author']) == null).toString());
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
                            print("authro ; " + (getDocument(document['author']) == null).toString());
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
                            print("authro ; " + (getDocument(document['author']) == null).toString());
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
                            print("authro ; " + (getDocument(document['author']) == null).toString());
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
                        return new ChatMessage(
                            message: document, author: getDocument(document['author']));
                      }).toList(),
                    );
                }
              },
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: IconTheme(
              data: IconThemeData(color: Theme.of(context).accentColor),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: _textEditingController,
                      autofocus: false,
                      onChanged: (String text) {
                        _messageText = text;
                      },
                      decoration:
                          InputDecoration.collapsed(hintText: "Сообщение"),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          sendMessage(context);
                        },
                      )),
                ]),
              ),
            ),
          )
        ]), // Sticker
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  var _posotion = CrossAxisAlignment.start;
  var _colorMessage = Colors.grey[600];
  var _status = "";
  final DocumentSnapshot message;
  final DocumentSnapshot author;

  ChatMessage({this.message, this.author});



  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    Timestamp timestamp = message['sent'];

    if (author['token'] == UserSettings.UID) {
      _posotion = CrossAxisAlignment.end;
      _colorMessage = Colors.blue[600];
    } else  {
      _posotion = CrossAxisAlignment.start;
      _colorMessage = Colors.green[600];
      _status = "(Менеджер)";
    }
=======
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
//    if (document['user'] == UserSettings.UID) {
//      _posotion = CrossAxisAlignment.end;
//      _colorMessage = Colors.blue[600];
//    } else if (emplToken == document['user']) {
//      _posotion = CrossAxisAlignment.start;
//      _colorMessage = Colors.green[600];
//      _status = "(Менеджер)";
//    }
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
  print("author: " + (author == null).toString());
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: _posotion,
        children: <Widget>[
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
//          Container(
//            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
//            child: InkWell(
//                child: Text(author['name'] + " " + author['surname'],
//                    style: TextStyle(
//                        fontWeight: FontWeight.w500,
//                        fontSize: 16.0,
//                        color: Colors.black)),
//                onTap: () async {
//                  if (_colorMessage == Colors.blue[600] ||
//                      _colorMessage == Colors.grey[600]) {
////
//                  }
//                }),
//          ),
=======
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: InkWell(
                child: Text(author['name'] + " " + author['surname'],
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Colors.black)),
                onTap: () async {
                  if (_colorMessage == Colors.blue[600] ||
                      _colorMessage == Colors.grey[600]) {
//                    return showDialog(
//                        context: context,
//                        builder: (BuildContext context) {
//                          return FutureBuilder(
//                              builder: (context, AsyncSnapshot projectSnap) {
////                                if (!projectSnap.hasData) {
////                                  if (projectSnap.data == null) {
////                                    return Text('');
////                                  }
////                                }
//                                return AlertDialog(
//                                    shape: RoundedRectangleBorder(
//                                        borderRadius:
//                                            BorderRadius.circular(30)),
//                                    title: Row(
//                                      children: <Widget>[
//                                        Container(
//                                            padding: const EdgeInsets.fromLTRB(
//                                                14, 0, 0, 10),
//                                            child: CircleAvatar(
//                                              radius: 20,
//                                              backgroundColor: Colors.blue,
//                                              child: Text(
//                                                projectSnap.data['name'][0] ??
//                                                    "error 404" +
//                                                        projectSnap
//                                                                .data['surname']
//                                                            [0] ??
//                                                    "error 404",
//                                                style: (TextStyle(
//                                                    fontWeight: FontWeight.bold,
//                                                    fontSize: 14.0)),
//                                              ),
//                                              foregroundColor: Colors.white,
//                                            )),
//                                        SizedBox(width: 10),
//                                        Text(
//                                            '${projectSnap.data['name'] ?? "err"}  ${projectSnap.data['surname'] ?? "error 404"}',
//                                            style: TextStyle(
//                                                fontWeight: FontWeight.bold,
//                                                fontSize: 14.0)),
//                                      ],
//                                    ),
//                                    content: Column(
//                                        crossAxisAlignment:
//                                            CrossAxisAlignment.start,
//                                        mainAxisSize: MainAxisSize.min,
//                                        children: <Widget>[
//                                          Container(
//                                            child: ListTile(
//                                                leading: const Icon(
//                                                  Icons.calendar_today,
//                                                  color: Colors.grey,
//                                                ),
//                                                title: Text("Год рождения"),
//                                                subtitle: Text(projectSnap
//                                                        .data['birthday'] ??
//                                                    "error 404")),
//                                          ),
//                                          Container(
//                                            child: ListTile(
//                                                leading: const Icon(
//                                                  Icons.flag,
//                                                  color: Colors.grey,
//                                                ),
//                                                title: Text("Страна"),
//                                                subtitle: Text(projectSnap
//                                                        .data['country'] ??
//                                                    "error 404")),
//                                          ),
//                                          Container(
//                                            child: ListTile(
//                                                leading: const Icon(
//                                                  Icons.description,
//                                                  color: Colors.grey,
//                                                ),
//                                                title: Text("Патент"),
//                                                subtitle: Text(projectSnap
//                                                        .data['patent'] ??
//                                                    "error 404")),
//                                          ),
//                                        ]));
//                              },
//                              future: FBManager.getUser(document['user']));
//                        });
//                  } else {
//                    return showDialog(
//                        context: context,
//                        builder: (BuildContext context) {
//                          return FutureBuilder(
//                              builder: (context, projectSnap) {
//                                if (!projectSnap.hasData) {
//                                  if (projectSnap.data == null) {
//                                    return Text('');
//                                  }
//                                }
//                                return AlertDialog(
//                                  shape: RoundedRectangleBorder(
//                                      borderRadius: BorderRadius.circular(30)),
//                                  title: Row(
//                                    children: <Widget>[
//                                      Container(
//                                          padding: const EdgeInsets.fromLTRB(
//                                              14, 0, 0, 10),
//                                          child: CircleAvatar(
//                                            radius: 20,
//                                            backgroundColor: Colors.green,
//                                            child: Text(
//                                              projectSnap.data['name'][0] ??
//                                                  "error 404" +
//                                                      projectSnap
//                                                          .data['surname'][0] ??
//                                                  "error 404",
//                                              style: (TextStyle(
//                                                  fontWeight: FontWeight.bold,
//                                                  fontSize: 14.0)),
//                                            ),
//                                            foregroundColor: Colors.white,
//                                          )),
//                                      SizedBox(width: 10),
//                                      Text(
//                                          '${projectSnap.data['name']}  ${projectSnap.data['surname'] ?? "error 404"}',
//                                          style: TextStyle(
//                                              fontWeight: FontWeight.bold,
//                                              fontSize: 14.0)),
//                                    ],
//                                  ),
//                                );
//                              },
//                              future: FBManager.getUser(document['user']));
//                        });
                  }
                }),
          ),
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
          SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: _colorMessage, width: 1.5),
                borderRadius: BorderRadius.all(Radius.circular(14.0))),
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10.0),
                  child: Text(
                    message['text'],
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 7),
          Container(
            child: Text(
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                "   ${timeago.format(timestamp.toDate(), locale: 'ru')}",
                style: TextStyle(
=======
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
                (message['sent'] as Timestamp).toDate().day.toString() +
                    "." +
                    (message['sent']  as Timestamp)
                        .toDate()
                        .month
                        .toString() +
                    " " +
                    (message['sent']  as Timestamp)
                        .toDate()
                        .hour
                        .toString() +
                    ":" +
                    (message['sent']  as Timestamp)
                        .toDate()
                        .minute
                        .toString(),
                style: TextStyle(
                    fontStyle: FontStyle.italic,
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
=======
>>>>>>> 3778d67a607eb763642093408e097ff09ee10f67
                    fontSize: 9.0,
                    color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:call_with_whatsapp/call_with_whatsapp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/Service/FBManager.dart';
import 'package:linkapp/Service/NotifManager.dart';
import 'package:linkapp/Service/UserSettings.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'LogsView.dart';

class OrderChatView extends StatefulWidget {
  final String chatUid;
  final List<String> listOfUids;
  OrderChatView({@required this.chatUid, @required this.listOfUids});

  @override
  _OrderChatView createState() => _OrderChatView(chatUid: chatUid, listOfUids: listOfUids);
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
  String titleName = ' ';

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



    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          listOfUsers == null ? "Загрузка" : (getDocument(listOfUids.elementAt(listOfUids.indexOf(UserSettings.UID) == 0 ? 1 : 0))['name'] ?? "err").toString(),
          style: TextStyle(color: Colors.black),
        ),
        actions: [
//          IconButton(
//              icon: Icon(Icons.call),
//              color: Colors.green,
//              iconSize: 30,
//              onPressed: () {
//                CallWithWhatsapp.requestPermissions().then((x){
//                  print("success");
//                }).catchError((e){
//                  print(e);
//                });
//                CallWithWhatsapp.initiateCall(listOfUsers == null ? "89267105770" : (getDocument(listOfUids.elementAt(listOfUids.indexOf(UserSettings.UID) == 0 ? 1 : 0))['phone'] ?? "89267105770").toString()).then((x){
//                  print("success");
//                }).catchError((e){
//                  print(e);
//                });
//              }),
        ],
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

                        print("authro ; " + (getDocument(document['author']) == null).toString());
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
    Timestamp timestamp = message['sent'];

    if (author['token'] == UserSettings.UID) {
      _posotion = CrossAxisAlignment.end;
      _colorMessage = Colors.blue[600];
    } else  {
      _posotion = CrossAxisAlignment.start;
      _colorMessage = Colors.green[600];
      _status = "(Менеджер)";
    }
  print("author: " + (author == null).toString());
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: _posotion,
        children: <Widget>[
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
                "   ${timeago.format(timestamp.toDate(), locale: 'ru')}",
                style: TextStyle(
                    fontSize: 9.0,
                    color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

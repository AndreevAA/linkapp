
import 'package:backdrop_modal_route/backdrop_modal_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/Screens/myLikes.dart';
import 'package:linkapp/Service/FBManager.dart';
import 'package:linkapp/Service/UserSettings.dart';
import 'package:linkapp/Settings/textStyleSettings.dart';

import 'cardView.dart';
import 'createPost.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreen createState() => _NewsScreen();
}

class _NewsScreen extends State<NewsScreen> {
  List<Map<String, dynamic>> fakeData = [
    {
      "title": "Сниму квартиру",
      "body": "В лосином осторве однокомнатную",
      "author": "Шингыз",
      "added": "2019-10-11T13:33:05.673",
      "hearts": 12,
      "type": "homesearch"
    },
    {
      "title": "Ищу работников на стройку",
      "body":
      "Проживание и питание включено! Оплата раз в неделю с авансом. Звоните: +71231231234",
      "author": "Сергей",
      "added": "2020-20-11T13:33:05.673",
      "hearts": 54,
      "type": "worksearch"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: InkWell(

                // Вывод верхнего меню с количеством ваксий и кнопкой сортировки
                child: Text(
                  "Лента новостей",
                  style: TextStyle(color: Colors.black),
                ),
              )),
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
                        icon: Icon(Icons.sort),
                        color: TextColors.accentColor,
                        iconSize: 30,
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            BackdropModalRoute<void>(
                              topPadding: 290.0,
                              overlayContentBuilder: (context) {
                                return SingleChildScrollView(
                                  child: Column(children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.fromLTRB(
                                          25, 20, 25, 0),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'Вывести по:',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          FlatButton(
                                            padding: const EdgeInsets.fromLTRB(
                                                130, 0, 0, 0),
                                            onPressed: () =>
                                                Navigator.pop(context),
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
                                        }),
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
                                      title:
                                      const Text('Увеличению требований'),
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
                                        title:
                                        const Text('Уменьшению требований'),
                                        value: 'Уменьшению требований',
                                        // groupValue: HomePageExe.sortStatus,
                                        onChanged: (String selected) {
                                          // setState((){HomePageExe.sortStatus = selected;
                                          // Сортировка по убыванию даты (Сначала новые)
                                          // OrdersSearchManager.sortListByParam(HomePageExe.sortStatus);
                                          Navigator.pop(context);
                                        }),
                                  ]),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite),
                      color: Colors.red,
                      iconSize: 30,
                      onPressed: () => Navigator.push(
                          context, MaterialPageRoute(builder: (context) => MyLikes())),
                    ),
                    Ink(
                      width: 45.0,
                      height: 45.0,
                      decoration: const ShapeDecoration(
                        //color: Colors.grey,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.search),
                        color: TextColors.accentColor,
                        iconSize: 30,
                        onPressed: () {},
                      ),
                    ),
                  ],
                )),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CreatePost()));
          },
          child: Icon(Icons.add),
          backgroundColor: TextColors.accentColor,
        ),
        body: Center(
            child: Container(
                padding: const EdgeInsets.all(10.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('posts').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return new CircularProgressIndicator();
                      default:
                        return new ListView(
                          children: snapshot.data.documents
                              .map((DocumentSnapshot document) {
                            return new CustomCard(
                              document: document,
                            );
                          }).toList(),
                        );
                    }
                  },
                ))));
  }
}

class CustomCard extends StatefulWidget {
  final DocumentSnapshot document;
  CustomCard({@required this.document});

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  //Color heartColor = TextColors.accentColor;
  String formatOutput(String temp, int maxLength) {
    if (temp.length <= maxLength)
      return temp;
    else
      return temp.substring(0, maxLength).trim() + "...";
  }

  String switchType(String type) {
    switch (type) {
      case "worksearch":
        return "Работа";
      case "homesearch":
        return "Жилье";
      default:
        return " ";
    }
  }
  Future<void> like() async {
    List<String> list = new List();
    list.add(UserSettings.UID);
    await FBManager.fbStore
        .collection('posts')
        .document(widget.document.documentID)
        .updateData({'likes': list});
  }

  Future<void> unlike() async {

  }
  Color cardColor = Colors.white;
  Color likeButton = Colors.grey;


  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = widget.document['publicDate'];
    List<dynamic> likes = widget.document['likes'];
    if (likes.contains(UserSettings.UID))
      likeButton = Colors.red;


    switch(widget.document['authorRole']) {
      case 'Work': {
        cardColor = Colors.green[200];
      }
      break;

      case "Housing": {
        cardColor = Colors.orange[200];
      }
      break;

      case "Friends": {
        cardColor = Colors.blue[200];
      }
      break;

      case "Stocks": {
        cardColor = Colors.red[200];
      }
      break;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Card(
          shape: Border(left: BorderSide(color: cardColor, width: 10)),
          child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CardView(document: widget.document))),
              child: Column(

                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[


                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child:CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.green,
                              child: Text(widget.document['name'][0] + widget.document['surname'][0], style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),) ,
                              foregroundColor: Colors.white,
                            )
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                                child: RichText(
                                                  text: TextSpan(children: [
                                                    TextSpan(
                                                      text: widget.document['name'],
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 18.0,
                                                          color: Colors.deepPurple),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                      "   ${timeago.format(timestamp.toDate(), locale: 'ru')}",
                                                      style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors.grey),
                                                    ),
                                                  ]),
                                                  overflow: TextOverflow.ellipsis,
                                                )),
                                            flex: 10,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 4.0),
                                              child: Icon(
                                                Icons.expand_more,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        alignment:
                                        AlignmentDirectional.centerStart,
                                        child: Text(
                                          widget.document['authorRole'],
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold, color:cardColor),
                                        ),
                                      ),
                                      SizedBox(height: 2),

                                      Container(
                                        alignment:
                                        AlignmentDirectional.centerStart,
                                        child: Text(
                                          widget.document['postTitle'],
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  )),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  widget.document['postText'],
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: AlignmentDirectional.centerStart,
                                child: Image.network(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTNrA6zRRhXYWUsF5qAn2ThtMeT8GeXtAjxXA&usqp=CAU' ?? ' ',
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  like();
                                },
                                child:   Container(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        Text(likes.length.toString() ?? '0', style: TextStyle(color: Colors.grey, fontSize: 16),),
                                        SizedBox(width: 5),
                                        Icon(Icons.favorite, color: likeButton, size: 16,),

                                      ],)
                                ),
                              )

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ))),);
  }
}

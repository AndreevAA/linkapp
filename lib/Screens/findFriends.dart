import 'package:backdrop_modal_route/backdrop_modal_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/Screens/profileScreen.dart';
import 'package:linkapp/Service/FBManager.dart';
import 'package:linkapp/Service/UserSettings.dart';
import 'package:linkapp/Settings/blockStyleSettings.dart';
import 'package:linkapp/Settings/textStyleSettings.dart';

class FindFriends extends StatefulWidget {
  @override
  _FindFriendsState createState() => _FindFriendsState();
}

class _FindFriendsState extends State<FindFriends> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<DocumentSnapshot> listOfOffers = new List();

  String field = "name";
  Icon actionIcon = new Icon(Icons.search, color: Colors.white,);
  final TextEditingController _searchQuery = new TextEditingController();
  Widget appBarTitle = new Text("Поиск друзей и сообществ", style: new TextStyle(color: Colors.white),);
  String _searchText;
  bool loading = false;


  _FindFriendsState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      }
      else {
        setState(() {
          _searchText = _searchQuery.text;
        });
      }
    });
  }
  // Получение массива token людей по имя + фамилия по параметру поиска
  // В случае отсутствия людей функция вернет строку "Пользователи не найдены"


  @override
  Widget build(BuildContext context) {

    print("build");

    return Scaffold(
        key: _scaffoldKey,
      appBar: new AppBar(
        backgroundColor: TextColors.accentColor,
          centerTitle: true,
          title: appBarTitle,
          actions: <Widget>[
            new IconButton(icon: actionIcon,onPressed:(){
              setState(() {
                if (this.actionIcon.icon == Icons.search){
                  this.actionIcon = new Icon(Icons.close);
                  this.appBarTitle = new TextField(
                    controller: _searchQuery,
                    style: new TextStyle(
                      color: Colors.white,

                    ),
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search,color: Colors.white),
                        hintText: "Введите имя или фамилию...",
                        hintStyle: new TextStyle(color: Colors.white)
                    ),
                  );
                }
                else {
                  this.actionIcon = new Icon(Icons.search);
                  this.appBarTitle = new Text("Поиск друзей и сообществ");
                }


              });
            } ,),]
      ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              loading = true;
            });
            _searchText = _searchQuery.text;
            if (_searchText != null && _searchText.trim() != '' && _searchText.trim() != ' ')
              FBManager.fbStore.collection('users').where('name', isEqualTo: _searchText).getDocuments().then((QuerySnapshot snap){
                setState(() {
                  listOfOffers = snap.documents;
                  loading = false;
                });
              });
            else
              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Введите верные поля"), backgroundColor: Colors.red,) );
          },
          child: Icon(Icons.check),
          backgroundColor: TextColors.accentColor,
        ),
        body: Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: listOfOffers == null ? Text(
                "Поиск по имени",
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
              ) : loading
                  ? CircularProgressIndicator()
                  : listOfOffers.isEmpty
                  ? Text(
                "К сожалению, друзей не найдено...",
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
              )
                  : ListView(
                children: listOfOffers.map((DocumentSnapshot document) {
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
                      backgroundColor: document['ispublic'] == true ? TextColors.activeColor : TextColors.enjoyColor,//TextColors.accentColor,
                      child: Text(
                        document['ispublic'] == true ? document['name'][0] : document['name'][0] + document['surname'][0],
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
                        padding: const EdgeInsets.fromLTRB(
                            BlockPaddings.globalBorderPadding,
                            2,
                            0,
                            2),
                        child: Text(
                          document['ispublic'] == true ? document['name'] : document['name']  + " " + document['surname'],
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
                          "Был(-а) в сети: " +
                              ((document['seen'] ?? Timestamp.now()) as Timestamp).toDate().toIso8601String().substring(0, 10),
                          style: TextStyle(
                              fontSize: 11.0,
                              color: TextColors.deactivatedColor,
                              fontWeight: FontWeight.normal),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
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
                      topPadding: 550.0,
                      overlayContentBuilder: (context) {

                        return SingleChildScrollView(
                          child: Column(
                              children: <Widget>[
                                SizedBox(height: 10,),

                                Row(

                                  mainAxisAlignment: MainAxisAlignment.start,

                                  children: <Widget>[

                                    SizedBox(width: 20,),

                                    Icon(Icons.message, color: Colors.black,),

                                    FlatButton(
                                      child: Text("Написать сообщение", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),),
                                    ),

                                  ],
                                ),

                                (document['ispublic'] == false ? Row(

                                  mainAxisAlignment: MainAxisAlignment.start,

                                  children: <Widget>[

                                    SizedBox(width: 20,),

                                    Icon(Icons.delete, color: Colors.red,),

                                    FlatButton(
                                      child: Text("Удалить из друзей", style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500),),
                                    ),

                                  ],
                                ) : Row(

                                  mainAxisAlignment: MainAxisAlignment.start,

                                  children: <Widget>[

                                    SizedBox(width: 20,),

                                    Icon(Icons.delete, color: Colors.red,),

                                    FlatButton(
                                      child: Text("Отписаться", style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500),),
                                    ),

                                  ],
                                )
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

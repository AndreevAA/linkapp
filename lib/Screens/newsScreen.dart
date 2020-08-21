import 'dart:math';

import 'package:backdrop_modal_route/backdrop_modal_route.dart';
import 'package:call_with_whatsapp/call_with_whatsapp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/Screens/myLikes.dart';
import 'package:linkapp/Service/FBManager.dart';
import 'package:linkapp/Service/UserSettings.dart';
import 'package:linkapp/Settings/textStyleSettings.dart';
import 'package:location/location.dart';

import 'cardView.dart';
import 'createPost.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreen createState() => _NewsScreen();
}


class _NewsScreen extends State<NewsScreen> {

<<<<<<< HEAD
  var stream = Firestore.instance
      .collection('posts')
      .orderBy("publicDate", descending: true)
      .getDocuments();

  String streamType = 'all';

  getDocumentNearBy(latitude, longitude, distance) {
    double deltaLat =
        distance / (cos(pi / 180 * _locationData.latitude) * 111.321377778);
    double deltaLon = distance / 111;
    GeoPoint laton1 = GeoPoint(latitude - deltaLat, longitude - deltaLon);
    GeoPoint laton2 = GeoPoint(latitude + deltaLat, longitude + deltaLon);

    print("laton1: ${laton1.longitude} "
        "laton2: ${laton2.longitude} ");
    streamType = 'near';
     stream = Firestore.instance.collection('posts').where('location', isGreaterThan: laton1, isLessThan: laton2).getDocuments();
  }

 _refresh(streamUpdateType) async {
    switch (streamUpdateType){

      case 'all' :{
        stream = Firestore.instance
            .collection('posts')
            .orderBy("publicDate", descending: true)
            .getDocuments();
      }
      break;

      case 'friends' :{
        stream = Firestore.instance
            .collection('posts')
            .where('type', isEqualTo: 'friends')
            .orderBy("publicDate", descending: true)
            .getDocuments();
      }
      break;

      case 'work' :{
        stream = Firestore.instance
            .collection('posts')
            .where('type', isEqualTo: 'work')
            .orderBy("publicDate", descending: true)
            .getDocuments();
      }
      break;

      case 'ads' :{
        stream = Firestore.instance
            .collection('posts')
            .where('type', isEqualTo: 'ads')
            .orderBy("publicDate", descending: true)
            .getDocuments();
      }
      break;

    }
    setState(() {

    });
  }

=======
  Stream<QuerySnapshot> stream = Firestore.instance.collection('posts').orderBy("publicDate", descending: true)
      .snapshots();
  bool near = false;


  getDocumentNearBy(latitude,  longitude,  distance ) {
//
//    double lat = _locationData.latitude;
//    double lon = _locationData.longitude;
//
//    double distance = 2.0;
//
//    double lowerLat = latitude - (lat * distance);
//    double lowerLon = longitude - (lon * distance);
//
//    double greaterLat = latitude + (lat * distance);
//    double greaterLon = longitude + (lon * distance);
//
//    GeoPoint lesserGeopoint = GeoPoint(lowerLat, lowerLon);
//    GeoPoint greaterGeopoint = GeoPoint( greaterLat, greaterLon);
//

//    print(near.toString());
//
//    stream = Firestore.instance.collection('posts').where('location', isGreaterThan: lesserGeopoint, isLessThan: greaterGeopoint).snapshots();

      double deltaLat = distance / (cos(pi / 180 * _locationData.latitude) * 111.321377778);
      double deltaLon =  distance  / 111;
      GeoPoint laton1 =  GeoPoint(latitude - deltaLat, longitude - deltaLon);
      GeoPoint laton2 =  GeoPoint(latitude + deltaLat, longitude + deltaLon);

      print("laton1: ${laton1.longitude} "
          "laton2: ${laton2.longitude} ");



      stream = Firestore.instance.collection('posts').where('location', isGreaterThan: laton1, isLessThan: laton2).snapshots();


  }



>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
  Location location = new Location();
  LocationData _locationData;

  getLocation() async {
    _locationData = await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    getLocation();
    return Scaffold(
      backgroundColor: Colors.purple[700],
        appBar: AppBar(
<<<<<<< HEAD
=======
          title: Container(
            //padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(
              "Лента новостей",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
          ),
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          bottom: PreferredSize(
            child: Container(
              height: 40.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: FlatButton(
                      color: Colors.red[400],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      onPressed: () {
                        setState(() {
<<<<<<< HEAD
                          streamType = 'all';
                          stream = Firestore.instance
                              .collection('posts')
                              .orderBy("publicDate", descending: true)
                              .getDocuments();
=======
                          near = false;
                          stream = Firestore.instance.collection('posts').orderBy("publicDate", descending: true).snapshots();
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
                        });
                      },
                      child: Text(
                        'Все',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: FlatButton(
                      color: Colors.purple[400],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      onPressed: () {
<<<<<<< HEAD
                        setState(() {
                          streamType = 'near';
=======

                        setState(() {
                         near = true;
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
                        });
                      },
                      child: Text(
                        'Рядом',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: FlatButton(
                      color: Colors.blue[400],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      onPressed: () {
                        setState(() {
<<<<<<< HEAD
                          streamType = 'friends';
                          stream = Firestore.instance
                              .collection('posts')
                              .where('type', isEqualTo: 'friends')
                              .orderBy("publicDate", descending: true)
                              .getDocuments();
=======
                          near = false;
                          stream = Firestore.instance.collection('posts').where('type', isEqualTo: 'friends').orderBy("publicDate", descending: true).snapshots();
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
                        });
                      },
                      child: Text(
                        'Развлечения',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: FlatButton(
                      color: Colors.green[400],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      onPressed: () {
                        setState(() {
<<<<<<< HEAD
                          streamType = 'work';
                          stream = Firestore.instance
                              .collection('posts')
                              .where('type', isEqualTo: 'work')
                              .orderBy("publicDate", descending: true)
                              .getDocuments();
=======
                          near = false;
                          stream = Firestore.instance.collection('posts').where('type', isEqualTo: 'work').orderBy("publicDate", descending: true).snapshots();
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
                        });
                      },
                      child: Text(
                        'Работа',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    //   height: ,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: FlatButton(
                      color: Colors.orange[400],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      onPressed: () {
                        setState(() {
<<<<<<< HEAD
                          streamType = 'ads';
                          stream = Firestore.instance
                              .collection('posts')
                              .where('type', isEqualTo: 'ads')
                              .orderBy("publicDate", descending: true)
                              .getDocuments();
=======
                          near = false;
                          stream = Firestore.instance.collection('posts').where('type', isEqualTo: 'ads').orderBy("publicDate", descending: true).snapshots();
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
                        });
                      },
                      child: Text(
                        'Объявления',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
<<<<<<< HEAD
//          actions: <Widget>[
//            Container(
//                padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
//                child: Row(
//                  children: <Widget>[
//                    Ink(
//                      width: 45.0,
//                      height: 45.0,
//                      decoration: const ShapeDecoration(
//                        //color: Colors.grey,
//                        shape: CircleBorder(),
//                      ),
//                      child: IconButton(
//                        icon: Icon(Icons.sort),
//                        color: TextColors.accentColor,
//                        iconSize: 30,
//                        onPressed: () async {
//                          await Navigator.push(
//                            context,
//                            BackdropModalRoute<void>(
//                              topPadding: 290.0,
//                              overlayContentBuilder: (context) {
//                                return SingleChildScrollView(
//                                  child: Column(children: <Widget>[
//                                    Container(
//                                      alignment: Alignment.center,
//                                      padding: const EdgeInsets.fromLTRB(
//                                          25, 20, 25, 0),
//                                      child: Row(
//                                        children: <Widget>[
//                                          Text(
//                                            'Вывести по:',
//                                            textAlign: TextAlign.left,
//                                            style: TextStyle(
//                                              color: Colors.black,
//                                              fontSize: 18,
//                                              fontWeight: FontWeight.w500,
//                                            ),
//                                          ),
//                                          FlatButton(
//                                            padding: const EdgeInsets.fromLTRB(
//                                                130, 0, 0, 0),
//                                            onPressed: () =>
//                                                Navigator.pop(context),
//                                            child: Row(
//                                              children: <Widget>[
//                                                // Кнопка закрытия окна (Крестик)
//                                                IconButton(
//                                                  icon: Icon(Icons.close),
//                                                  color: TextColors.accentColor,
//                                                  iconSize: 30,
//                                                )
//                                              ],
//                                            ),
//                                          ),
//                                        ],
//                                      ),
//                                    ),
//                                    RadioListTile(
//                                      activeColor: TextColors.accentColor,
//                                      title: const Text('Дате'),
//                                      value: 'Дате',
//                                      // groupValue: HomePageExe.sortStatus,
//                                      onChanged: (String selected) {
//                                        // setState((){HomePageExe.sortStatus = selected;
//                                        // // Сортировка по убыванию даты (Сначала новые)
//                                        // OrdersSearchManager.sortListByParam(HomePageExe.sortStatus);
//                                        Navigator.pop(context);
//                                      },
//                                    ),
//                                    RadioListTile(
//                                        activeColor: TextColors.accentColor,
//                                        title: const Text('Популярности'),
//                                        value: 'Популярности',
//                                        // groupValue: HomePageExe.sortStatus,
//                                        onChanged: (String selected) {
//                                          // setState((){HomePageExe.sortStatus = selected;
//                                          // Сортировка по убыванию даты (Сначала новые)
//                                          // OrdersSearchManager.sortListByParam(HomePageExe.sortStatus);
//                                          Navigator.pop(context);
//                                        }),
//                                    RadioListTile(
//                                      activeColor: TextColors.accentColor,
//                                      title: const Text('Увеличению оклада'),
//                                      value: 'Увеличению оклада',
//                                      // groupValue: HomePageExe.sortStatus,
//                                      onChanged: (String selected) {
//                                        // setState((){HomePageExe.sortStatus = selected;
//                                        // // Сортировка по убыванию даты (Сначала новые)
//                                        // OrdersSearchManager.sortListByParam(HomePageExe.sortStatus);
//                                        Navigator.pop(context);
//                                      },
//                                    ),
//                                    RadioListTile(
//                                      activeColor: TextColors.accentColor,
//                                      title: const Text('Уменьшению оклада'),
//                                      value: 'Уменьшению оклада',
//                                      // groupValue: HomePageExe.sortStatus,
//                                      onChanged: (String selected) {
//                                        // setState((){HomePageExe.sortStatus = selected;
//                                        // Сортировка по убыванию даты (Сначала новые)
//                                        // OrdersSearchManager.sortListByParam(HomePageExe.sortStatus);
//                                        Navigator.pop(context);
//                                      },
//                                    ),
//                                    RadioListTile(
//                                      activeColor: TextColors.accentColor,
//                                      title:
//                                          const Text('Увеличению требований'),
//                                      value: 'Увеличению требований',
//                                      // groupValue: HomePageExe.sortStatus,
//                                      onChanged: (String selected) {
//                                        // setState((){HomePageExe.sortStatus = selected;
//                                        // Сортировка по убыванию даты (Сначала новые)
//                                        // OrdersSearchManager.sortListByParam(HomePageExe.sortStatus);
//                                        Navigator.pop(context);
//                                      },
//                                    ),
//                                    RadioListTile(
//                                        activeColor: TextColors.accentColor,
//                                        title:
//                                            const Text('Уменьшению требований'),
//                                        value: 'Уменьшению требований',
//                                        // groupValue: HomePageExe.sortStatus,
//                                        onChanged: (String selected) {
//                                          // setState((){HomePageExe.sortStatus = selected;
//                                          // Сортировка по убыванию даты (Сначала новые)
//                                          // OrdersSearchManager.sortListByParam(HomePageExe.sortStatus);
//                                          Navigator.pop(context);
//                                        }),
//                                  ]),
//                                );
//                              },
//                            ),
//                          );
//                        },
//                      ),
//                    ),
//                    IconButton(
//                      icon: Icon(Icons.favorite),
//                      color: Colors.red[300],
//                      iconSize: 30,
//                      onPressed: () => Navigator.push(context,
//                          MaterialPageRoute(builder: (context) => MyLikes())),
//                    ),
//                  ],
//                )),
//          ],
=======
          actions: <Widget>[
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
                      color: Colors.red[300],
                      iconSize: 30,
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyLikes())),
                    ),


                  ],
                )),
          ],
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
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
                child: FutureBuilder(
                  future: stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return new CircularProgressIndicator();
                      default:
<<<<<<< HEAD
                        return new RefreshIndicator(

                            onRefresh: () => _refresh(streamType),
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: snapshot.data.documents
                                  .map((DocumentSnapshot document) {
                                if (streamType == 'near') {
                                  getDocumentNearBy(
                                      document['lat'], document['lon'], 0.01);

                                  print(
                                      document['lon'].toString() + 'awdawddw');
                                }

                                return new CustomCard(
                                  document: document,
                                );
                              }).toList(),
                            ));
=======

                        return new ListView(
                          children: snapshot.data.documents
                              .map((DocumentSnapshot document) {

                            if(near==true){
                            getDocumentNearBy(document['lat'], document['lon'], 0.01);

                            print(document['lon'].toString() + 'awdawddw');
                            }

                            return new CustomCard(
                              document: document,
                            );
                          }).toList(),
                        );
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
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
<<<<<<< HEAD
  //Color heartColor = TextColors.accentColor;
=======

  //Color heartColor = TextColors.accentColor;


  Future<void> like() async {
    List<String> list = new List();
    list.add(UserSettings.UID);
    await FBManager.fbStore
        .collection('posts')
        .document(widget.document.documentID)
        .updateData({'likes': list});
  }

  Future<void> unlike() async {}
  Color cardColor = Colors.white;
  Color likeButton = Colors.grey;

  @override
  Widget build(BuildContext context) {
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304



<<<<<<< HEAD
  @override
  Widget build(BuildContext context) {
=======
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
    Timestamp timestamp = widget.document['publicDate'];
    List<dynamic> likes = widget.document['likes'];
    if (likes.contains(UserSettings.UID)) likeButton = Colors.red;

    switch (widget.document['type']) {
      case 'work':
        {
          cardColor = Colors.green[200];
        }
        break;

      case "housing":
        {
          cardColor = Colors.orange[200];
        }
        break;

      case "friends":
        {
          cardColor = Colors.blue[200];
        }
        break;

      case "ads":
        {
          cardColor = Colors.orange[200];
        }
        break;
    }

<<<<<<< HEAD

=======
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
    return ClipRRect(

      borderRadius: BorderRadius.circular(16.0),
      child: Card(
          shape: Border(left: BorderSide(color: cardColor, width: 10)),
          child: InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CardView(document: widget.document))),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.green,
                              child: Text(

                                widget.document['name'][0] +
                                    widget.document['surname'][0],
                                style: (TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0)),
                              ),
                              foregroundColor: Colors.white,
                            )),
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
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                          widget.document['type'] ?? 'null',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                              color: cardColor),
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
                              Container(
<<<<<<< HEAD
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Text(
                                      widget.document['postText'],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  )),
=======
                                  alignment:
                                  AlignmentDirectional.centerStart,
                              child :Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  widget.document['postText'],
                                  overflow: TextOverflow.ellipsis,

                                  style: TextStyle(fontSize: 18.0),),
                              )),
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
                              SizedBox(
                                height: 10,
                              ),

                              Container(
                                alignment: AlignmentDirectional.centerStart,
                                child: widget.document['attachment'] == 'none'
                                    ? Text(' ')
                                    : Image.network(
                                        widget.document['attachment'],
                                        headers: {'accept': 'image/*'},
                                        width: 200,
                                        height: 200,
                                      ),
                              ),
                              InkWell(
                                onTap: () {
                                  like();
                                },
                                child: Container(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          likes.length.toString() ?? '0',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 16),
                                        ),
                                        SizedBox(width: 5),
                                        Icon(
                                          Icons.favorite,
                                          color: likeButton,
                                          size: 16,
                                        ),
                                      ],
                                    )),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }
}

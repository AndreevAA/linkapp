import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/Screens/createVacanies.dart';
import 'package:linkapp/Service/FBManager.dart';
import 'package:linkapp/Service/UserSettings.dart';
import 'package:timeago/timeago.dart' as timeago;

class ResumeScreens extends StatefulWidget {
  @override
  _ResumeScreensState createState() => _ResumeScreensState();
}

class _ResumeScreensState extends State<ResumeScreens> {
  _refresh(streamUpdateType) async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: ()=> Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CreateVacancies())),
          label: Text('Новая вакансия'),
          icon: Icon(Icons.create),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            bottom: PreferredSize(
              child: Container(
                height: 30,
                child: Text(
                  "Подходящие для вас резюме", textAlign: TextAlign.start, style: TextStyle(
                  color: Colors.black, fontSize: 16,
                ),
                ),
              ),
            )),
        body: Center(
            child: Container(
                padding: const EdgeInsets.all(10.0),
                child: FutureBuilder(
                  future: Firestore.instance
                      .collection('posts')
                      .orderBy("publicDate", descending: true)
                      .getDocuments(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return new CircularProgressIndicator();
                      default:
                        return new RefreshIndicator(
                            onRefresh: () => _refresh(''),
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: snapshot.data.documents
                                  .map((DocumentSnapshot document) {
                                return new CustomCard(
                                  document: document,
                                );
                              }).toList(),
                            ));
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
    Timestamp timestamp = widget.document['publicDate'];
    List<dynamic> likes = widget.document['likes'];

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Card(
          shape: Border(left: BorderSide(color: cardColor, width: 10)),
          child: InkWell(
//              onTap: () => Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) =>
//                          CardView(document: widget.document))),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                //padding: const EdgeInsets.only(top: 2.0),
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
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        alignment: AlignmentDirectional.centerStart,
                                        child: Text(
                                          'МНЕ НУЖЕН ЯГОР ЗА 60к',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        alignment: AlignmentDirectional.centerStart,
                                        child: Text(
                                          'Москва',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 14.0, color: Colors.grey),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                          alignment: AlignmentDirectional.centerStart,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              'Чтоб он нормально так код фигачил за печеньки и пиво там, да...',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 6,
                                              style: TextStyle(fontSize: 18.0),
                                            ),
                                          )),
                                    ],
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                  onTap: () {
                                    like();
                                  },
                                  child: Container(
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Icon(
                                          Icons.star,
                                          color: likeButton,
                                          size: 20,
                                        ),
                                      )))
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

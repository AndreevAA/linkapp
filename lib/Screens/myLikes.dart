import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/Screens/cardView.dart';
import 'package:linkapp/Service/FBManager.dart';
import 'package:linkapp/Service/UserSettings.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyLikes extends StatefulWidget {
  @override
  _MyLikes createState() => _MyLikes();
}
class _MyLikes extends State<MyLikes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Мои лайки',
            style: TextStyle(color: Colors.black),
          ),
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Center(
            child: Container(
                padding: const EdgeInsets.all(10.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('posts').where('likes', arrayContains: UserSettings.UID).snapshots(),
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

  Future<void> unlike() async {}
  Color cardColor = Colors.white;
  Color likeButton = Colors.grey;

  @override
  Widget build(BuildContext context) {
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
                                child: widget.document['attachment'] == 'none' ? Text(' ') :
                                Image.network(
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
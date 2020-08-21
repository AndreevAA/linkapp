import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/Screens/profileScreen.dart';
import 'package:linkapp/Service/FBManager.dart';
import 'package:linkapp/Service/UserSettings.dart';

class CardView extends StatefulWidget {
  final DocumentSnapshot document;

  const CardView({Key key, this.document}) : super(key: key);

  @override
  _CardView createState() => _CardView();
}

bool appliedWorker = false;

class _CardView extends State<CardView> {
  Color likeButton = Colors.grey;

  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = widget.document['publicDate'];

    List<dynamic> likes = widget.document['likes'];

    if (likes.contains(UserSettings.UID)) likeButton = Colors.red;

    List<dynamic> workersList = widget.document['workers'] ?? [];

    if (workersList.contains(UserSettings.UID)) {
      appliedWorker = true;
    }

    print(UserSettings.UID);

    print(appliedWorker.toString() + '  APPEID');
    print(workersList.toString() + '  LIST');

    return Scaffold(
<<<<<<< HEAD
      backgroundColor: Colors.purple,
        appBar: AppBar(
          leading: BackButton(color: Colors.white),
=======
        appBar: AppBar(
          leading: BackButton(color: Colors.black),
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            widget.document['postTitle'],
<<<<<<< HEAD
            style: TextStyle(color: Colors.white),
=======
            style: TextStyle(color: Colors.black),
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green,
                          child: Text(
                            widget.document['name'][0] +
                                widget.document['surname'][0],
                            style: (TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0)),
                          ),
                          foregroundColor: Colors.white,
                        )),
                    Container(
                        child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: widget.document['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
<<<<<<< HEAD
                              color: Colors.white),
=======
                              color: Colors.deepPurple),
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
                        ),
                        TextSpan(text: '\n'),
                        TextSpan(
                          text: widget.document['type'],
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
<<<<<<< HEAD
                              color: Colors.white),
=======
                              color: Colors.deepPurpleAccent),
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
                        ),
                        TextSpan(text: '\n'),
                        TextSpan(
                          text:
                              'Опубликовано: ${timestamp.toDate().hour}:${timestamp.toDate().minute} ${timestamp.toDate().day}.${timestamp.toDate().month}.${timestamp.toDate().year}',
<<<<<<< HEAD
                          style: TextStyle(fontSize: 14.0, color: Colors.white),
=======
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
                        ),
                      ]),
                      overflow: TextOverflow.ellipsis,
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  widget.document['postText'],
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: AlignmentDirectional.center,
                child: widget.document['attachment'] == 'none'
                    ? Text(' ')
                    : Image.network(
                        widget.document['attachment'],
                        headers: {'accept': 'image/*'},
                        fit: BoxFit.fill,
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        likes.length.toString() ?? '0',
<<<<<<< HEAD
                        style: TextStyle(color: Colors.white, fontSize: 19),
=======
                        style: TextStyle(color: Colors.grey, fontSize: 19),
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.favorite,
                        color: likeButton,
                        size: 18,
                      ),
                    ],
                  )),
              Container(
                alignment: AlignmentDirectional.center,
<<<<<<< HEAD



=======
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
                child: widget.document['type'] != 'work'
                    ? Text(' ')
                    : Container(
                        child: UserSettings.UID == widget.document['user_id']
                            ? Container(
                                child: widget.document['workers'] == null
                                    ? Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Text(
                                          'Еще никто не откликнулся',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
<<<<<<< HEAD
                                            fontSize: 18
=======
                                            fontSize: 18,
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : Column(children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 0),
                                          child: Text(
                                            'Отклинушейся работники',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
<<<<<<< HEAD
                                                 color: Colors.white
=======
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        FutureBuilder(
                                            future: FBManager.fbStore
                                                .collection('users').document(widget.document['workers'][0]).get(),
                                            builder: (context,
                                                AsyncSnapshot getNameSnap) {
                                              if (!getNameSnap.hasData) {
                                                if (getNameSnap.data == null) {
                                                  return CircularProgressIndicator();
                                                }
                                              }
                                              return InkWell(
                                                onTap: (){
                                                  Navigator.push (
                                                    context,
                                                    MaterialPageRoute(builder: (context) => ProfileScreen(document: getNameSnap.data,)),
                                                  );
                                                },
                                                child:
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 0, 0, 10),
                                                    child: CircleAvatar(
                                                      radius: 25,
                                                      backgroundColor: Colors
                                                          .purple,
                                                      child: Text(
                                                        getNameSnap.data['name'][0],
                                                        style: (TextStyle(
                                                            fontSize: 16.0)),
                                                      ),
                                                      foregroundColor: Colors
                                                          .white,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize
                                                        .min,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 30,
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 20.0,
                                                            vertical: 2.0),
                                                        child: Text(
                                                          getNameSnap.data['name'] ??
                                                              "ER",
                                                          style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 14.0,
                                                            color: Colors
                                                                .black,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),);
                                            }  )
                                      ]),
                              )
                            : RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                color:
                                    appliedWorker ? Colors.grey : Colors.green,
                                child: appliedWorker
                                    ? Text('Вы уже откикнулись на предложение',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16))
                                    : Text('Откикнутся на предложение',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                onPressed: () async {
                                  if (!appliedWorker) {
                                    await FBManager.fbStore
                                        .collection("posts")
                                        .document(widget.document.documentID)
                                        .updateData({
                                      'workers': [UserSettings.UID],
                                    });
                                    setState(() {
                                      appliedWorker = true;
                                    });
                                    print(appliedWorker.toString() +
                                        " 129841294198429024");
                                  }
                                },
                              ),
                      ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }
}

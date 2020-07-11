
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/Service/UserSettings.dart';


class CardView extends StatefulWidget {
  final DocumentSnapshot document;

  const CardView({Key key, this.document}) : super(key: key);

  @override
  _CardView createState() => _CardView();
}

class _CardView extends State<CardView>{
  Color likeButton = Colors.grey;

  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = widget.document['publicDate'];
    List<dynamic> likes = widget.document['likes'];

    if (likes.contains(UserSettings.UID))
      likeButton = Colors.red;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title:  Text(widget.document['postTitle'], style: TextStyle(color: Colors.black),),
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
                          child: Text(widget.document['name'][0] + widget.document['surname'][0], style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),) ,
                          foregroundColor: Colors.white,
                        )
                    ),
                    Container(
                        child: RichText(
                          text: TextSpan(
                              children: [
                            TextSpan(
                              text: widget.document['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0,
                                  color: Colors.deepPurple),
                            ),
                                TextSpan(
                                  text: '\n'),
                            TextSpan(
                              text: widget.document['type'],
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent),
                            ),
                                TextSpan(
                                    text: '\n'),
                                TextSpan(
                                  text: 'Опубликовано: ${timestamp.toDate().hour}:${timestamp.toDate().minute} ${timestamp.toDate().day}.${timestamp.toDate().month}.${timestamp.toDate().year}',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey),
                                ),

                          ]),
                          overflow: TextOverflow.ellipsis,
                        )),




                  ],
                ),

              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  widget.document['postText'],
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                alignment: AlignmentDirectional.centerStart,
                child: widget.document['attachment'] == 'none' ? Text(' ') :
                Image.network(
                  widget.document['attachment'],
                  headers: {'accept': 'image/*'},
                fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 10,),

              Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.end,
                    children: [
                      Text(likes.length.toString() ?? '0', style: TextStyle(color: Colors.grey, fontSize: 19),),
                      SizedBox(width: 5),
                      Icon(Icons.favorite, color: likeButton, size: 18,),

                    ],)
              ),
              Container(
                alignment: AlignmentDirectional.center,
                child: widget.document['type'] != 'work' ? Text(' ') :
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                  ),
                  color: Colors.green,
                  child: Text('Откикнутся на предложение', style: TextStyle(color: Colors.white, fontSize: 16),),
                  onPressed: (){
                    print('иду на работу епт');
                  },
                ),

              ),
              SizedBox(height: 10,),
            ],
          ),

      )
    );
  }
}
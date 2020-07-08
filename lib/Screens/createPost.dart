import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkapp/Service/DataBaseNamings.dart';
import 'package:linkapp/Service/FBManager.dart';
import 'package:linkapp/Service/UserSettings.dart';
import 'package:linkapp/Settings/textStyleSettings.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

// Окно создания поста
class _CreatePostState extends State<CreatePost> {
  String _postText, _authorRole, _authorToken, _postTitle, _pathImage;
  _CreatePostState() {
    _authorRole = UserSettings.userDocument['role'].toString();
    _authorToken = UserSettings.userDocument['token'].toString();
  }
  File _image;
  final picker = ImagePicker();
  TextEditingController dateCtl;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Новый пост',
            style: TextStyle(color: Colors.black),
          ),
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Опубликовать пост'),
          icon: Icon(Icons.check),
          backgroundColor: Colors.deepPurpleAccent,
          onPressed: () async {
            await FBManager.fbStore.collection("posts").add({
              'user_id': UserSettings.UID,
              'postTitle': _postTitle,
              'postText': _postText,
              'authorToken': _authorToken,
              'authorRole': _authorRole,
              'likes': 0,
              'publicDate': Timestamp.now()
            });

            // Обновление данных document из FB
            UserSettings.userDocument =
                await FBManager.getUserStats(UserSettings.UID);

            // Закрытие окна и возврат в профиль
            Navigator.pop(context, true);
          },
        ),
        body: Container(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  cursorColor: Colors.deepPurpleAccent,
                  maxLines: null,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Название поста'),
                  onChanged: (title) {
                    _postTitle = title;
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  cursorColor: Colors.deepPurpleAccent,
                  maxLines: null,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Текст'),
                  onChanged: (body) {
                    _postText = body;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: RaisedButton.icon(
                  color: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    onPressed: () => getImage(),
                    icon: Icon(Icons.image, color: Colors.white,),
                    label: Text('Добавить изображение', style: TextStyle(color: Colors.white),)),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                child: _image == null
                    ? Text('')
                    : Image.file(
                        _image,
                        height: 300,
                        width: 300,
                      ),
              )
            ],
          ),
        )));
  }
}

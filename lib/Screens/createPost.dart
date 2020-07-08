import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/Service/DataBaseNamings.dart';
import 'package:linkapp/Service/FBManager.dart';
import 'package:linkapp/Service/UserSettings.dart';
import 'package:linkapp/Settings/textStyleSettings.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

// Окно создания поста
class _CreatePostState extends State<CreatePost>{

  String _postText, _authorRole, _authorToken;

  _CreatePostState(){
    _authorRole = UserSettings.userDocument['role'].toString();
    _authorToken = UserSettings.userDocument['token'].toString();
  }

  TextEditingController dateCtl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
          //_loading = true;
        });

        await FBManager.fbStore
            .collection("posts")
            .document("1").setData({
          'postText': _postText,
          'authorToken' : _authorToken,
          'authorRole' : _authorRole,
          'publicDate' : Timestamp.now()
        });

        // Обновление данных document из FB
        UserSettings.userDocument = await FBManager.getUserStats(UserSettings.UID);

        // Закрытие окна и возврат в профиль
        Navigator.pop(context, true);

        },
        child: Icon(Icons.add),
        backgroundColor: TextColors.accentColor,
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: TextField(
              maxLines: null,
              autofocus: false,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Описание вакансии'
              ),
              onChanged: (inputPostText) {
                _postText = inputPostText;
              },
            ),
          ),
        ],
      ),
    );
  }
}
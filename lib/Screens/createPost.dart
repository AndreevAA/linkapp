import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giphy_client/giphy_client.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkapp/Service/DataBaseNamings.dart';
import 'package:linkapp/Service/FBManager.dart';
import 'package:linkapp/Service/UserSettings.dart';
import 'package:linkapp/Settings/textStyleSettings.dart';
import 'package:location/location.dart';

//https://pub.dev/packages/image_picker#-readme-tab- ДОБАВИТЬ ВЕБ ПОДДЕРЖКУ
class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

// Окно создания поста
class _CreatePostState extends State<CreatePost> {
  String _postText, _authorRole, _authorToken, _postTitle, _pathImage;
  GiphyGif _gif;

  String _postType = 'Выберете тип поста';

  _CreatePostState() {
    _authorRole = UserSettings.userDocument['role'].toString();
    _authorToken = UserSettings.userDocument['token'].toString();
  }

  File _image;
  final picker = ImagePicker();
  TextEditingController dateCtl;
  var storage = FirebaseStorage.instance;

  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
      _gif = null;
    });
  }
  getPermision() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    return _locationData;

  }

  getLocation() async {
    _locationData = await location.getLocation();
  }

  Future getGif() async {
    final gif = await GiphyPicker.pickGif(
        context: context,
        apiKey: 'OeOSsdJuzJTh9lPPFpQoUuQ70uZpAynr');

    if (gif != null) {
      setState(() => _gif = gif);
      _image = null;
    }
    print(_gif.images.original.url);

  }

  Future createImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile.path);
      _gif = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    getLocation();
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

            if(  _postType == 'Выберете тип поста')
              _postType = 'friends';


            if(_image != null){

              var imgPath = _image.toString().split('/cache/');
              StorageTaskSnapshot snapshot = await storage
                  .ref()
                  .child("attachments/${imgPath[1]}")
                  .putFile(_image)
                  .onComplete;

              final String downloadUrl = await snapshot.ref.getDownloadURL();
              await FBManager.fbStore.collection("posts").add({
                'user_id': UserSettings.UID,
                'postTitle': _postTitle ?? ' ',
                'postText': _postText  ?? ' ',
                'authorToken': _authorToken,
                'authorRole': _authorRole,
                'type': _postType,
                'likes': [],
                'name': UserSettings.userDocument['name'],
                'surname': UserSettings.userDocument['surname'],
                'attachment':downloadUrl,
                'publicDate': Timestamp.now(),
                'location': GeoPoint(_locationData.latitude, _locationData.longitude),
                'lat': _locationData.latitude,
                'lon':  _locationData.longitude,

              });

            } else if (_gif != null){
              await FBManager.fbStore.collection("posts").add({
                'user_id': UserSettings.UID,
                'postTitle': _postTitle,
                'postText': _postText,
                'authorToken': _authorToken,
                'authorRole': _authorRole,
                'type': _postType,
                'likes': [],
                'name': UserSettings.userDocument['name'],
                'surname': UserSettings.userDocument['surname'],
                'attachment':_gif.images.original.url,
                'publicDate': Timestamp.now(),
                'location': GeoPoint(_locationData.latitude, _locationData.longitude),
                'lat': _locationData.latitude,
                'lon':  _locationData.longitude,

              });
            }
            else{
              await FBManager.fbStore.collection("posts").add({
                'user_id': UserSettings.UID,
                'postTitle': _postTitle,
                'postText': _postText,
                'authorToken': _authorToken,
                'authorRole': _authorRole,
                'type': _postType,
                'likes': [],
                'name': UserSettings.userDocument['name'],
                'surname': UserSettings.userDocument['surname'],
                'attachment':'none',
                'publicDate': Timestamp.now(),
                'location': GeoPoint(_locationData.latitude, _locationData.longitude),
                'lat': _locationData.latitude,
                'lon':  _locationData.longitude,

              });
            }



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
                    height: 20,
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
                    height: 20,
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
                  SafeArea(
                    minimum: EdgeInsets.zero,
                    child: _gif == null
                        ? Text(' ')
                        : GiphyImage.original(gif: _gif),
                  ),

                  SafeArea(
                    minimum: EdgeInsets.zero,
                    child: _image == null
                        ? Text(' ')
                        : Image.file(
                      _image,
                      height: 200,
                      width: 200,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (String value) {
                      setState(() {
                        _postType = value;
                      });
                    },
                    child:  FlatButton.icon(
                     disabledColor: Colors.purple,
                      icon: Icon(Icons.arrow_drop_down,color: Colors.white,),
                      color: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),),
                      label: Text(
                        _postType ,
                        style: TextStyle(color: Colors.white),
                      )),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'work',
                        child: Text('Работа'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'housing',
                        child: Text('Обьявления'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'friends',
                        child: Text('Развлечения'),
                      ),
                    ],
                  ),
                  Container(
                    child: RaisedButton.icon(
                        color: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        onPressed: () => getImage(),
                        icon: Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Добавить изображение',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  Container(
                    child: RaisedButton.icon(
                        color: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        onPressed: () => createImage(),
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Сделать снимок',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  Container(
                    child: RaisedButton.icon(
                        color: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        onPressed: () => getGif(),
                        icon: Icon(
                          Icons.gif,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Добавить gif',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            )));
  }
}

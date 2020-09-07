import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class CompanyProfile extends StatefulWidget {
  final DocumentSnapshot document;
  final String title;

  CompanyProfile({@required this.document, this.title});

  @override
  _CompanyProfileState createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.document['name'],
          style: TextStyle(color: Colors.black),
        ),
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          children: [
            Image.network(
              widget.document['logo'],
              headers: {'accept': 'image/*'},
              width: 200,
              height: 200,
            ),
           //  FlareActor("assets/logo_lizard.flr", alignment:Alignment.bottomCenter, fit:BoxFit.none, animation:"Untitled")



          ],
        ),
      ),
    );
  }
}

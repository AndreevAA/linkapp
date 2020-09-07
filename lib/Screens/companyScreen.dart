import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stories/flutter_stories.dart';
import 'package:linkapp/Screens/companyDetaliScreen.dart';
import 'package:linkapp/Service/UserSettings.dart';

class CompanyScreen extends StatefulWidget {
  @override
  _CompanyScreenState createState() => _CompanyScreenState();
}

getCompanyData(){
  var data = Firestore.instance.collection('company').getDocuments();
}

class _CompanyScreenState extends State<CompanyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        appBar: AppBar(
//            backgroundColor: Colors.transparent,
//            elevation: 0,
//            bottom: PreferredSize(
//              child: Container(
//                height: 30,
//                child: Text(
//                  "", textAlign: TextAlign.start, style: TextStyle(
//                  color: Colors.black, fontSize: 16,
//                ),
//                ),
//              ),
//            )),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
          SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
                          child: Text(
                            'IT',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        // flex: 20,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
                          child: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CompanyAllPage(title: 'IT', document:   UserSettings.companyList ,))),
                            child: Text(
                              'См. дальше',
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      height: 110,
                      child:  FutureBuilder(
                        future: Firestore.instance.collection('company').getDocuments(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError)
                            return new Text('Error: ${snapshot.error}');
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return new Container();
                            default:
                              return ListView(
                                scrollDirection: Axis.horizontal,

                                physics: const AlwaysScrollableScrollPhysics(),
                                children: snapshot.data.documents
                                    .map((DocumentSnapshot document) {
                                  return new CompanyCard(
                                    document: document,
                                  );
                                }).toList(),
                              );
                          }
                        },
                      )
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
                          child: Text(
                            'Тип компании 2',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        // flex: 20,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
                          child: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CompanyAllPage(title: 'Тип компании 2', document:   UserSettings.companyList ,))),
                            child: Text(
                              'См. дальше',
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      height: 110,
                      child:  FutureBuilder(
                        future: Firestore.instance.collection('company').getDocuments(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError)
                            return new Text('Error: ${snapshot.error}');
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return new Container();
                            default:
                              return ListView(
                                scrollDirection: Axis.horizontal,

                                physics: const AlwaysScrollableScrollPhysics(),
                                children: snapshot.data.documents
                                    .map((DocumentSnapshot document) {
                                  return new CompanyCard(
                                    document: document,
                                  );
                                }).toList(),
                              );
                          }
                        },
                      )
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
                          child: Text(
                            'Тип компании 3',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        // flex: 20,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
                          child: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CompanyAllPage(title: 'Тип компании 3', document: UserSettings.companyList ,))),
                            child: Text(
                              'См. дальше',
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      height: 110,
                      child:  FutureBuilder(
                        future: Firestore.instance.collection('company').getDocuments(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError)
                            return new Text('Error: ${snapshot.error}');
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return new Container();
                            default:
                              UserSettings.companyList = snapshot.data;
                              print('dw' + UserSettings.companyList.documents.length.toString());
                              return ListView(
                                scrollDirection: Axis.horizontal,

                                physics: const AlwaysScrollableScrollPhysics(),
                                children: snapshot.data.documents
                                    .map((DocumentSnapshot document) {

                                  return new CompanyCard(
                                    document: document,
                                  );
                                }).toList(),
                              );
                          }
                        },
                      )
                  )

        ])));
  }
}

class CompanyCard extends StatefulWidget {
final DocumentSnapshot document;
CompanyCard({@required this.document});

  @override
  _CompanyCardState createState() => _CompanyCardState();
}

class _CompanyCardState extends State<CompanyCard> {
  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => CompanyProfile(title: 'Тип компании 3', document: widget.document )));
      },
      child: Container(
        width: 130,
        height: 90,

        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1 ,
                blurRadius: 4,
                offset: Offset(0, 5), // changes position of shadow
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        margin: EdgeInsets.all(10),

        child: Center(
          child: Image.network(
            widget.document['logo'],
            headers: {'accept': 'image/*'},
            width: 70,
            height: 70,
          ),
        ),
      ),
    );
  }
}

class CompanyAllPage extends StatefulWidget {
  final QuerySnapshot document;
  final String title;

  CompanyAllPage({@required this.document, this.title});

  @override
  _CompanyAllPageState createState() => _CompanyAllPageState();
}

class _CompanyAllPageState extends State<CompanyAllPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
        leading: BackButton(color: Colors.black, onPressed: ()=> Navigator.pop(context),),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(child: GridView.count(
        crossAxisCount: 3,

        //childAspectRatio: 16/9,
        children:
        List.generate(widget.document.documents.length, (index) {
          return CompanyCard(document: widget.document.documents[index]);
        }),
      ),),
    );
  }
}


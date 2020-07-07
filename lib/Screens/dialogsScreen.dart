import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/Settings/textStyleSettings.dart';

class DialogsScreen extends StatefulWidget {
  @override
  _DialogsScreenState createState() => _DialogsScreenState();
}

class _DialogsScreenState extends State<DialogsScreen> {
  List<Map<String, dynamic>> fakeData = [
    {
      "name": "Мадина",
      "messages": [
        "Жумуш дорогой! Я пироги испекла, жду тебя к обеду",
        "пирог сгорел иди нахй"
      ],
      "posted": "2019-10-11T13:33:05.673",
      "status": false
    },
    {
      "name": "Ахмед",
      "messages": ["Брат, есть работка тут. непыльная, платят хорошо"],
      "posted": "2020-07-11T13:33:05.673",
      "status": false
    }
  ];

  // List<Map<String, dynamic>> sortListByDate(List<Map<String, dynamic>>) {
  //   int location;
  //   DocumentSnapshot newElement;

  //   for (int i = 1; i < listOfDocumentSnapshots.length; i++) {
  //     newElement = listOfDocumentSnapshots[i];
  //     location = i - 1;

  //     while (location >= 0 && comparatorCompare(_sortStatus, location, newElement) == true) {
  //       listOfDocumentSnapshots[location + 1] = listOfDocumentSnapshots[location];
  //       location = location - 1;
  //     }

  //     listOfDocumentSnapshots[location + 1] = newElement;
  //   }

  // }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: InkWell(
                // Вывод верхнего меню с количеством ваксий и кнопкой сортировки
                child: Text(
                  "Сообщения",
                  style: TextStyle(color: Colors.black),
                ),
              )),
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // showDialog(context);
//            //OrdersSearchManager.sortListByDate();
          },
          child: Icon(Icons.add),
          backgroundColor: TextColors.accentColor,
        ),
        body: Center(
            child: Container(
          child: fakeData == null
              ? CircularProgressIndicator()
              : fakeData.isEmpty
                  ? Text(
                      "К сожалению, по выбранным параметрам вакансий пока нету...",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                    )
                  : ListView(
                      children: fakeData.map((Map<String, dynamic> document) {
                        // Logs.addNode("OrdersSearchView", "build",
                        // "Document:\n" + document.documentID);
                        try {
                          return new CustomCard(map: document);
                        } catch (e) {
                          print(e);
                        }
                      }).toList(),
                    ),
        )));
  }
}

class CustomCard extends StatefulWidget {
  // CustomCard({@required this.document, @required this.previousScreenContext, @required this.homePageScreen});

  // final DocumentSnapshot document;
  Map map;

  CustomCard({@required this.map});

  @override
  _CustomCard createState() => _CustomCard(map: map);
}

class _CustomCard extends State<CustomCard> {
  _CustomCard({@required this.map});

  final Map map;
  Color readColor = TextColors.accentColor;

  String formatOutput(String temp, int maxLength) {
    if (temp.length <= maxLength)
      return temp;
    else
      return temp.substring(0, maxLength).trim() + "...";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
//        color: setOrdersColor(document['level'] ?? 0),
      child: InkWell(
        onTap: () async {
          setState(() {
            if (readColor == TextColors.accentColor)
              readColor = TextColors.deactivatedColor;
          });
        },
        // bool rebuildNeeded = await Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => TaskPage(
        //           document: document), settings: RouteSettings(name: 'UserTaskPage'), ));
        // if (rebuildNeeded ?? false)
        //   homePageScreen.rebuild();

        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(14, 0, 0, 10),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: readColor,
                child: Text(
                  map['name'][0],
                  style:
                      (TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0)),
                ),
                foregroundColor: Colors.white,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 2.0),
                  child: Text(
                    map['name'] ?? "ER",
                    // HomePageExe.formatOutput(HomePageExe.replaceSymbols(HomePageExe.replaceSymbols(HomePageExe.deleteSmiles(runeSubstring(input: document['title'] ?? 'Ошибка описания', start: 0, end: (document['title'] ?? 'Ошибка описания').toString().length < 20 ? (document['title'] ?? 'Ошибка описаня').toString().length : 20)), "\n", " "), "  ", " "), 20).replaceAll("\n\n", "\n"),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                      color: Colors.black,
                    ),
                  ),
                ),

                // Блок размера оплаты труда
                Container(
                  height: 30,
                  padding: const EdgeInsets.fromLTRB(20, 1, 0, 11),
                  child: Text(
                    // concatMinMax(document['min_price'], document['max_price']) +
                    // " / " + document['pay_type'] ?? "",
                    formatOutput(map['messages'][0] ?? "ERR", 35) ?? "er",
                    style: TextStyle(
                        fontSize: 14.0,
                        color: readColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                Container(
                  height: 20,
                  padding: const EdgeInsets.fromLTRB(20, 1, 0, 0),
                  child: Text(
                    // concatMinMax(document['min_price'], document['max_price']) +
                    // " / " + document['pay_type'] ?? "",
                    map['posted'] ?? "ERR",
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

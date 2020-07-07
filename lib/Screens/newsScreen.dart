import 'package:backdrop_modal_route/backdrop_modal_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/Settings/textStyleSettings.dart';

class NewsScreen extends StatefulWidget{

  @override
  _NewsScreen createState() => _NewsScreen();

}

class _NewsScreen extends State<NewsScreen> {

  List<Map<String, dynamic>> fakeData = [{"title" : "Сниму квартиру", "body" : "В лосином осторве однокомнатную", "author" : "Шингыз", "added" : "2019-10-11T13:33:05.673", "hearts" : 12, "type" : "homesearch"}, 
  {"title" : "Ищу работников на стройку", "body" : "Проживание и питание включено! Оплата раз в неделю с авансом. Звоните: +71231231234", "author" : "Сергей", "added" : "2020-20-11T13:33:05.673", "hearts" : 54, "type" : "worksearch"} ];

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: InkWell(

              // Вывод верхнего меню с количеством ваксий и кнопкой сортировки
              child: Text("Лента новостей", style: TextStyle(color: Colors.black),),
            )
        ),

        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          // Кнопка редактирвоания данных профиля
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: Row(
              children: <Widget>[
                Ink(
                  width: 45.0,
                  height: 45.0,
                  decoration: const ShapeDecoration(
                    //color: Colors.grey,
                    shape: CircleBorder(),

                  ),
                  child: IconButton(
                    icon: Icon(Icons.sort),
                    color: TextColors.accentColor,
                    iconSize: 30,
                    onPressed: ()async {
                      await Navigator.push(
                        context,
                        BackdropModalRoute<void>(
                          topPadding: 290.0,
                          overlayContentBuilder: (context) {

                            return SingleChildScrollView(
                              child: Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                                      child:
                                      Row(
                                        children: <Widget>[
                                          Text('Вывести по:', textAlign: TextAlign.left, style: TextStyle(
                                            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500,
                                          ),),

                                          FlatButton(
                                            padding: const EdgeInsets.fromLTRB(130, 0, 0, 0),
                                            onPressed: () => Navigator.pop(context),
                                            child: Row(
                                              children: <Widget>[
                                                // Кнопка закрытия окна (Крестик)
                                                IconButton(
                                                  icon: Icon(Icons.close),
                                                  color: TextColors.accentColor,
                                                  iconSize: 30,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    RadioListTile(
                                      activeColor: TextColors.accentColor,
                                      title: const Text('Дате'),
                                      value: 'Дате',
                                      // groupValue: HomePageExe.sortStatus,
                                      onChanged: (String selected) {
                                        // setState((){HomePageExe.sortStatus = selected;
                                        // // Сортировка по убыванию даты (Сначала новые)
                                        // OrdersSearchManager.sortListByParam(HomePageExe.sortStatus);
                                        Navigator.pop(context);

                                      },
                                    ),

                                    RadioListTile(
                                      activeColor: TextColors.accentColor,
                                      title: const Text('Популярности'),
                                      value: 'Популярности',
                                      // groupValue: HomePageExe.sortStatus,
                                      onChanged: (String selected) {
                                        // setState((){HomePageExe.sortStatus = selected;
                                        // Сортировка по убыванию даты (Сначала новые)
                                        // OrdersSearchManager.sortListByParam(HomePageExe.sortStatus);
                                        Navigator.pop(context);
                                        }
                                      ),

                                    RadioListTile(
                                      activeColor: TextColors.accentColor,
                                      title: const Text('Увеличению оклада'),
                                      value: 'Увеличению оклада',
                                      // groupValue: HomePageExe.sortStatus,
                                      onChanged: (String selected) {
                                        // setState((){HomePageExe.sortStatus = selected;
                                        // // Сортировка по убыванию даты (Сначала новые)
                                        // OrdersSearchManager.sortListByParam(HomePageExe.sortStatus);
                                        Navigator.pop(context);
                                      },
                                    ),

                                    RadioListTile(
                                      activeColor: TextColors.accentColor,
                                      title: const Text('Уменьшению оклада'),
                                      value: 'Уменьшению оклада',
                                      // groupValue: HomePageExe.sortStatus,
                                      onChanged: (String selected) {
                                        // setState((){HomePageExe.sortStatus = selected;
                                        // Сортировка по убыванию даты (Сначала новые)
                                        // OrdersSearchManager.sortListByParam(HomePageExe.sortStatus);
                                        Navigator.pop(context);
                                      },
                                    ),

                                    RadioListTile(
                                      activeColor: TextColors.accentColor,
                                      title: const Text('Увеличению требований'),
                                      value: 'Увеличению требований',
                                      // groupValue: HomePageExe.sortStatus,
                                      onChanged: (String selected) {
                                        // setState((){HomePageExe.sortStatus = selected;
                                        // Сортировка по убыванию даты (Сначала новые)
                                        // OrdersSearchManager.sortListByParam(HomePageExe.sortStatus);
                                        Navigator.pop(context);
                                      },
                                    ),

                                    RadioListTile(
                                      activeColor: TextColors.accentColor,
                                      title: const Text('Уменьшению требований'),
                                      value: 'Уменьшению требований',
                                      // groupValue: HomePageExe.sortStatus,
                                      onChanged: (String selected) {
                                        // setState((){HomePageExe.sortStatus = selected;
                                        // Сортировка по убыванию даты (Сначала новые)
                                        // OrdersSearchManager.sortListByParam(HomePageExe.sortStatus);
                                        Navigator.pop(context);
                                      }
                                    ),

                                  ]



                              ),
                            );

                          },
                        ),
                      );
                    },
                  ),
                ),


                Ink(
                  width: 45.0,
                  height: 45.0,
                  decoration: const ShapeDecoration(
                    //color: Colors.grey,
                    shape: CircleBorder(),

                  ),
                  child: IconButton(
                    icon: Icon(Icons.search),
                    color: TextColors.accentColor,
                    iconSize: 30,
                    onPressed: (){

                    },
                  ),
                ),
              ],
            )

          ),
        ],
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
                child:
                        fakeData == null ?
                        CircularProgressIndicator() : fakeData.isEmpty ?
                        Text("К сожалению, по выбранным параметрам вакансий пока нету...", textAlign: TextAlign.center, textDirection: TextDirection.ltr,) :
                        ListView(
                          children: fakeData
                              .map((Map<String, dynamic> document) {
                            // Logs.addNode("OrdersSearchView", "build",
                                // "Document:\n" + document.documentID);
                            try
                            {
                              return new CustomCard(map: document);
                            }
                            catch (e){
                              print(e);
                            }

                          }).toList(),
                        ),
                      )
                    )
                  );
  }
}

  class CustomCard extends StatelessWidget {
  // CustomCard({@required this.document, @required this.previousScreenContext, @required this.homePageScreen});

  // final DocumentSnapshot document;

  CustomCard({@required this.map});

  final Map map;

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

  @override
  Widget build(BuildContext context) {
//    Logs.log += "\n\ntype: " + document['min_price'].runtimeType.toString() + "\n\n";
    return Card(
//        color: setOrdersColor(document['level'] ?? 0),
        child: InkWell(
            onTap: () async {
              // bool rebuildNeeded = await Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => TaskPage(
              //           document: document), settings: RouteSettings(name: 'UserTaskPage'), ));
              // if (rebuildNeeded ?? false)
              //   homePageScreen.rebuild();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 2.0),
                  child: Text(map['title'],
                    // HomePageExe.formatOutput(HomePageExe.replaceSymbols(HomePageExe.replaceSymbols(HomePageExe.deleteSmiles(runeSubstring(input: document['title'] ?? 'Ошибка описания', start: 0, end: (document['title'] ?? 'Ошибка описания').toString().length < 20 ? (document['title'] ?? 'Ошибка описаня').toString().length : 20)), "\n", " "), "  ", " "), 20).replaceAll("\n\n", "\n"),
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0,
                      color: Colors.black,),
                  ),
                ),

                // Блок размера оплаты труда
                Container(
                  height: 30,
                  padding: const EdgeInsets.fromLTRB(20, 1, 0, 11),
                  child: Text(
                    // concatMinMax(document['min_price'], document['max_price']) +
                        // " / " + document['pay_type'] ?? "",
                        switchType(map['type'] ?? "ERR") + " | " + map['author'] ?? 'err',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: TextColors.accentColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                // Блок описания вакансии
                Container(
                  //height: 60,
                  //padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                  child: Text(map['body'],
                      // HomePageExe.formatOutput(HomePageExe.replaceSymbols(HomePageExe.replaceSymbols(HomePageExe.deleteSmiles(runeSubstring(input: document['body'] ?? 'Ошибка описания', start: 0, end: (document['body'] ?? 'Ошибка описаня').toString().length < 120 ? (document['body'] ?? 'Ошибка описаня').toString().length : 120)), "\n", " "), "  ", " "), 120)
                          // .replaceAll("\n\n", "\n"),
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                          color: Colors.black87)),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  height: 1,
                  color: Colors.black12,
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                ),

                // Значание после разделительной линии
                Row(
                  children: <Widget>[
                    // Количество просмотров
                    Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),

                          child: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: IconButton(
                                    iconSize: 2,
                                    icon: Icon(Icons.favorite, size: 20, color: TextColors.accentColor,),
                                    onPressed: (){print("onpressed");},

                                    )
                                ),
                              ],
                            ),
                          ),
                    ),

                    // Блок адреса
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text((map['hearts'] ?? "").toString() + "         Размещено: " + map['added'] ?? 'Ошибка описания',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                              color: Colors.black26)),
                    ),
                  ],
                ),

                SizedBox(height: 15),
              ],
            )));
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stories/flutter_stories.dart';

class HelpBlockScreen extends StatefulWidget {
  @override
  _HelpBlockScreenState createState() => _HelpBlockScreenState();
}

class _HelpBlockScreenState extends State<HelpBlockScreen> {
  final _momentCount = 5;
  final _momentDuration = const Duration(seconds: 5);
  @override
  Widget build(BuildContext context) {
    final images = List.generate(
        _momentCount, (idx) => Image.asset('assets/${idx + 1}.jpg'));

    final images1 = List.generate(
        _momentCount, (idx) => Image.asset('assets/test${idx + 1}.png'));

    return Scaffold(
        appBar: AppBar(
          title: Container(
            // Вывод верхнего меню с количеством ваксий и кнопкой сортировки
            child: Text(
              "Полезная информация",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
                child: Text(
                  'Документы',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                height: 150.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoPageScaffold(
                              child: Story(
                                fullscreen: true,

                                onFlashForward: Navigator.of(context).pop,
                                onFlashBack: Navigator.of(context).pop,
                                momentCount: 3,
                                momentDurationGetter: (idx) => _momentDuration,
                                momentBuilder: (context, idx) => images1[idx],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius:
                            BorderRadius.all(Radius.circular(16.0))),
                        margin: EdgeInsets.all(10),
                        width: 160.0,
                        child: Center(
                          child: Text(
                            'Обязательные документы',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoPageScaffold(
                              child: Story(
                                onFlashForward: Navigator.of(context).pop,
                                onFlashBack: Navigator.of(context).pop,
                                momentCount: 3,
                                momentDurationGetter: (idx) => _momentDuration,
                                momentBuilder: (context, idx) => images[idx],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            borderRadius:
                            BorderRadius.all(Radius.circular(16.0))),
                        margin: EdgeInsets.all(10),
                        width: 160.0,
                        child: Center(
                          child: Text(
                            'Получение патента',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoPageScaffold(
                              child: Story(
                                onFlashForward: Navigator.of(context).pop,
                                onFlashBack: Navigator.of(context).pop,
                                momentCount: 3,
                                momentDurationGetter: (idx) => _momentDuration,
                                momentBuilder: (context, idx) => images[idx],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                            BorderRadius.all(Radius.circular(16.0))),
                        margin: EdgeInsets.all(10),
                        width: 160.0,
                        child: Center(
                          child: Text(
                            'Продление патента',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
                child: Text(
                  'Структуры и органы',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                height: 150.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoPageScaffold(
                              child: Story(
                                onFlashForward: Navigator.of(context).pop,
                                onFlashBack: Navigator.of(context).pop,
                                momentCount: 4,
                                momentDurationGetter: (idx) => _momentDuration,
                                momentBuilder: (context, idx) => images1[idx],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                            BorderRadius.all(Radius.circular(16.0))),
                        margin: EdgeInsets.all(10),
                        width: 160.0,
                        child: Center(
                          child: Text(
                            'ФМС',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoPageScaffold(
                              child: Story(
                                onFlashForward: Navigator.of(context).pop,
                                onFlashBack: Navigator.of(context).pop,
                                momentCount: 4,
                                momentDurationGetter: (idx) => _momentDuration,
                                momentBuilder: (context, idx) => images[idx],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.pink,
                            borderRadius:
                            BorderRadius.all(Radius.circular(16.0))),
                        margin: EdgeInsets.all(10),
                        width: 160.0,
                        child: Center(
                          child: Text(
                            'МВД',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoPageScaffold(
                              child: Story(
                                fullscreen: true,
                                onFlashForward: Navigator.of(context).pop,
                                onFlashBack: Navigator.of(context).pop,
                                momentCount: 4,
                                momentDurationGetter: (idx) => _momentDuration,
                                momentBuilder: (context, idx) => images[idx],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius:
                            BorderRadius.all(Radius.circular(16.0))),
                        margin: EdgeInsets.all(10),
                        width: 160.0,
                        child: Center(
                          child: Text(
                            'Таможня',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
                child: Text(
                  'Рекомендации',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                height: 150.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoPageScaffold(
                              child: Story(
                                onFlashForward: Navigator.of(context).pop,
                                onFlashBack: Navigator.of(context).pop,
                                momentCount: 4,
                                momentDurationGetter: (idx) => _momentDuration,
                                momentBuilder: (context, idx) => images1[idx],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                            BorderRadius.all(Radius.circular(16.0))),
                        margin: EdgeInsets.all(10),
                        width: 160.0,
                        child: Center(
                          child: Text(
                            'Устройство на работу',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoPageScaffold(
                              child: Story(
                                onFlashForward: Navigator.of(context).pop,
                                onFlashBack: Navigator.of(context).pop,
                                momentCount: 4,
                                momentDurationGetter: (idx) => _momentDuration,
                                momentBuilder: (context, idx) => images[idx],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius:
                            BorderRadius.all(Radius.circular(16.0))),
                        margin: EdgeInsets.all(10),
                        width: 160.0,
                        child: Center(
                          child: Text(
                            'Решение конфликтов',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoPageScaffold(
                              child: Story(
                                onFlashForward: Navigator.of(context).pop,
                                onFlashBack: Navigator.of(context).pop,
                                momentCount: 4,
                                momentDurationGetter: (idx) => _momentDuration,
                                momentBuilder: (context, idx) => images[idx],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                            BorderRadius.all(Radius.circular(16.0))),
                        margin: EdgeInsets.all(10),
                        width: 160.0,
                        child: Center(
                          child: Text(
                            'Сообщества',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),

        ));
  }
}

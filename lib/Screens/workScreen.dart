import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkapp/Screens/resumeScreen.dart';
import 'package:linkapp/Screens/vacanciesScreen.dart';

import 'helpBlockScreen.dart';

class WorkTabBarScreen extends StatelessWidget {
  final List<Tab> myTabs = <Tab>[
    Tab(text: '1'),
    Tab(text: '2'),
    Tab(text: '3'),

  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.purple,
            elevation: 0,
            bottom: PreferredSize(
              child: Container(
                height: 40.0,
                child: TabBar(
                    labelColor: Colors.purple,
                    unselectedLabelColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Colors.white),
                    tabs: [
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Вакансии"),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Резюме"),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Компании"),
                        ),
                      ),
                    ]
    ) ) ),
              ),
          body: TabBarView(children: [
            MyVacancies(),
            ResumeScreens(),
            Icon(Icons.games),
          ]),
        )
    );
  }
  }

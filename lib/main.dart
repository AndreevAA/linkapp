import 'package:flutter/material.dart';

import 'Screens/dialogsScreen.dart';
import 'Screens/friendsScreen.dart';
import 'Screens/helpBlockScreen.dart';
import 'Screens/newsScreen.dart';
import 'Screens/profileScreen.dart';
import 'Settings/textStyleSettings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

@override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static List<Widget> _widgetOptions = <Widget>[
    NewsScreen(),
    DialogsScreen(),
    FriensScreen(),
    ProfileScreen(),
    HelpBlockScreen(),
  ];

  static int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {

      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: (_widgetOptions.elementAt(_selectedIndex)),
      ),

      bottomNavigationBar: BottomNavigationBar(
      backgroundColor: BlockColors.mainColor,

        // Выключение подписек к кнопкам меню
        showSelectedLabels: false,
        showUnselectedLabels: false,

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Лента'),
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('Сообщения'),
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text(''),
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text(''),
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            title: Text(''),
          ),

        ],

        currentIndex: _selectedIndex,
        selectedItemColor: TextColors.accentColor,
        onTap: _onItemTapped,

      ),
    );
  }

}

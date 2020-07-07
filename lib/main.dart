import 'package:flutter/material.dart';

import 'Screens/dialogsScreen.dart';
import 'Screens/friendsScreen.dart';
import 'Screens/helpBlockScreen.dart';
import 'Screens/newsScreen.dart';
import 'Screens/profileScreen.dart';
import 'Settings/blockStyleSettings.dart';
import 'Settings/iconStyleSettings.dart';
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'linkapp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

// Блок нижнего основного меню приложения
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
            title: Text(''),
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text(''),
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

        selectedItemColor: IconColors.accentColor,
        unselectedItemColor: IconColors.additionalColor,

        onTap: _onItemTapped,

      ),
    );
  }
}

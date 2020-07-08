import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/Registration.dart';
import 'Screens/dialogsScreen.dart';
import 'Screens/friendsScreen.dart';
import 'Screens/helpBlockScreen.dart';
import 'Screens/newsScreen.dart';
import 'Screens/profileScreen.dart';
import 'Service/UserSettings.dart';
import 'Settings/blockStyleSettings.dart';
import 'Settings/iconStyleSettings.dart';
import 'Settings/textStyleSettings.dart';

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((SharedPreferences prefs) {
    UserSettings.UID = prefs.getString('uid');
    if (UserSettings.UID != null) {
      runApp(new MyApp());
    } else {
      runApp(new Regist());
    }
  });
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        //visualDensity: VisualDensity.adaptivePlatformDensity,
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
    FriendsScreen(),
    ProfileScreen(),
    HelpBlockScreen(),
  ];

  static int _selectedIndex = 3;

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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linkapp/Service/FBManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/Registration.dart';
import 'Screens/dialogsScreen.dart';
import 'Screens/friendsScreen.dart';
import 'Screens/helpBlockScreen.dart';
import 'Screens/newsScreen.dart';
import 'Screens/profileScreen.dart';
import 'Screens/workScreen.dart';
import 'Service/UserSettings.dart';
import 'Settings/blockStyleSettings.dart';
import 'Settings/iconStyleSettings.dart';
import 'Settings/textStyleSettings.dart';

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
  FBManager.init();
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.purple,
      statusBarColor: Colors.transparent, // status bar color
// navigation bar color
    ));
    return MaterialApp(
<<<<<<< HEAD

=======
>>>>>>> 387a59e3dbf7d7f6cf5d5a1374d2755a960ec304
      debugShowCheckedModeBanner: false,
      title: 'linkapp',
      theme: ThemeData(
        //backgroundColor: Colors.white,
        primarySwatch: Colors.deepPurple,
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

  static List<Widget> _widgetOptions = <Widget>[
    NewsScreen(),
    DialogsScreen(),
    //sFriendsScreen(),
    WorkTabBarScreen(),
    ProfileScreen(document: UserSettings.userDocument,),
    //HelpBlockScreen(),
  ];

  static int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {

      _selectedIndex = index;
    });
  }

// Блок нижнего основного меню приложения
  @override
  Widget build(BuildContext context) {

    if (UserSettings.userDocument == null) {
      FBManager.getUser(UserSettings.UID).then((DocumentSnapshot snapshot) {
        setState(() {
          UserSettings.userDocument = snapshot;
          print("got " + UserSettings.userDocument.data.toString() + " user");

        });
      });
      return Scaffold(
        backgroundColor: Colors.purple,
        body: Center(
          child: Text("linkapp", style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold),),
        ),
      );
    }

    return Scaffold(

      body: Center(
        child: (_widgetOptions.elementAt(_selectedIndex)),
      ),

      bottomNavigationBar: BottomNavigationBar(

        backgroundColor: Colors.purple,
        //selectedIconTheme: ,
        type: BottomNavigationBarType.fixed,
        // Выключение подписек к кнопкам меню
        showSelectedLabels: true,
        showUnselectedLabels: false,

        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],


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
            icon: Icon(Icons.work),
            title: Text('Работа'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Профиль'),
          ),


//          BottomNavigationBarItem(
//            icon: Icon(Icons.help),
//            title: Text(''),
//          ),

        ],

        currentIndex: _selectedIndex,

        onTap: _onItemTapped,

      ),
    );
  }
}

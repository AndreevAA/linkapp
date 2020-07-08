import 'package:flutter/material.dart';


class Logs extends StatelessWidget {

  static String log = "--- / logs started \ ---\n";

  static addNode(String className, String methodName, String info){
    log += "\n- < - " + className + " - > -\n" + "-  < " + methodName + " >  -\n" + info + "\n- - -    //    - - -\n";
    print("< " + className + " - " + methodName + " > : " + info);
  }

  static bool needToShowDialog = false;
  static String orderId;
  static String messageClass;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back_ios),
        label: Text("Назад"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Center (
          child: Text(log, textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, color: Colors.black54),),),
      ),
    );
  }
}

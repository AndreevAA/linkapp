
import 'package:cloud_firestore/cloud_firestore.dart';
class UserSettings{
  static String UID;
  static String phone;
  static DocumentSnapshot userDocument;
  static String appVersion = 'beta_0_1';

  static void clearAll(){
    UID = null;
    userDocument = null;
  }

  static String getUserPatent(){
    if(userDocument != null)
      switch(userDocument['patent'].toString()) {
        case "null":
          return "Любые";
        case "residence":
          return "Регистрация";
        default:
          return "Патент";
      }
  }
}
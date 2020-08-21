import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkapp/Screens/LogsView.dart';

import '../main.dart';
import 'DataBaseNamings.dart';
import 'UserSettings.dart';

class FBManager {
  static Firestore fbStore;
  //static Geoflutterfire geo;

  static void init() {
    fbStore = Firestore.instance;
    print("FBManager inited");
   //geo = Geoflutterfire();
  }

  static List<GeoPoint> getSquareLimits(double lat, double lon,
      double distance) {
    double deltaLat = distance / (cos(pi / 180 * lat) * 111.321377778);
    double deltaLon = distance / 111;
    Logs.addNode("FBManager", "getSquareLimits",
        "deltaLat: " + deltaLat.toString() + " deltaLon: " +
            deltaLon.toString() +
            "\nlat: " + lat.toString() + " lon: " + lon.toString() +
            "\nlat between: " + (lat - deltaLat).toString() + " - " +
            (lat + deltaLat).toString() +
            "\nlon between: " + (lon - deltaLon).toString() + " - " +
            (lon + deltaLon).toString());
    return [
      GeoPoint(lat - deltaLat, lon - deltaLon),
      GeoPoint(lat + deltaLat, lon + deltaLon)
    ];
  }

  static checkUserIdIfSet() async {
    if (UserSettings.UID == null)
      UserSettings.UID = (await FirebaseAuth.instance.currentUser()).uid;
  }

  static Future<void> addOrder(Map<String, dynamic> map,
      DocumentSnapshot _documentSnapshot) async {
      map.addAll({"list_views" : 0,
      "link_views" : 0});
    /// бля лучше вот эту херню не трогать
    try {
      fbStore
          .collection(ORDERS_COLLECTION)
          .add(map);
      fbStore.collection(DYNAMIC_CONSTANTS).document('prices').get().then((document) => 
       fbStore
          .collection(USERS_COLLECTION)
          .document(UserSettings.UID)
          .updateData({'balance': _documentSnapshot.data['balance'] - document.data['order']}));
     
      //CleanerApp.hasChanges = true;
    }
    catch (e) {
      Logs.addNode("FBManager", "AddOrder", e.toString());
    }
  }

  static Future<DocumentSnapshot> getUser(String _uid) async {
    /// ПРОВЕРКА ПОЛЬЗОВАТЕЛЯ НА НАЛИЧИЕ В БАЗЕ ДАННЫХ
    try {
      DocumentSnapshot _documentSnapshot = await fbStore
          .collection('users')
          .document(_uid)
          .get();
      return _documentSnapshot;
    } catch (e) {
      Logs.addNode("FBManager", "GetUser", e.toString());
    }
  }

  static Future<void> addNewUser(Map<String, dynamic> map) async {
    try {
      await checkUserIdIfSet();
      await fbStore
          .collection(USERS_COLLECTION)
          .document(UserSettings.UID)
          .setData(map);
    } catch (e) {
      Logs.addNode("FBManager", "AddNewUser", e.toString());
    }
  }

  static Future<List<DocumentSnapshot>> getChatsList() async {
    try {
      return (await fbStore
          .collection('privatechat')
          .where('users', arrayContains: UserSettings.UID)
          .getDocuments()).documents;
    } catch (e) {
      Logs.addNode("FBManager", "getChatsList", e.toString());

    }
  }

  static Future<void> editUser(Map<String, String> map) async {
    try {
      await checkUserIdIfSet();
      await fbStore
          .collection(USERS_COLLECTION)
          .document(UserSettings.UID)
          .updateData(map);
    } catch (e) {
      Logs.addNode("FBManager", "EditUser", e.toString());
    }
  }

  static Future<void> applyToOrder(String orderToken) async {
    /// ВОРКЕР ПРИНИМЕТ ЗАКАЗ
    try {
      List<String> list = new List();
      list.add(UserSettings.UID);
      var doc = await fbStore
          .collection(ORDERS_COLLECTION)
          .document(orderToken)
          .get();
      for (String node in doc.data['workers'])
        list.add(node);
      await fbStore
          .collection(ORDERS_COLLECTION)
          .document(orderToken)
          .updateData({'workers': list});
    } catch (e) {
      Logs.addNode("FBManager", "ApplyToOrder", e.toString());
    }
  }

  static Future<DocumentSnapshot> getOrderStats(String orderToken) async {
    /// ДАЕТ ДОСТУП КО ВСЕМ ДАННЫМ ПО ЗАКАЗУ
    /// ДАЛЕЕ ВО ФРОНТЕ НАДО СДЕЛТЬ ФИЛЬТР ПО ТОМУ, КОМУ ЗАКАЗ ПОКАЗЫВАЕТСЯ
    try {
      return await fbStore
          .collection(ORDERS_COLLECTION)
          .document(orderToken)
          .get();
    } catch (e) {
      Logs.addNode("FBManager", "GetOrderStats", e.toString());
    }
    return null;

    /// ПОСМОТРИ В registration.dart МЕТОД CheckUser, ТАМ ПРИМЕР ЧТО ЭТА ХРЕНЬ ВОЗВРАЩАЕТ
    /// ТОЛЬКО ТУТ ЕЩЕ ТАБЛИЦА ВОРКЕРОВ, КОТОРЫЕ СОГЛАСИЛИСЬ НА РАБОТУ
  }

  static Future<void> addPrivateChat(String partnerUid, String partnerName) async {
    try {
      //await checkUserIdIfSet();
      await fbStore
          .collection("privatechat")
          .document(UserSettings.UID.toString().substring(0, 14) + partnerUid.substring(14))
          .setData({
        "users" : [partnerUid, UserSettings.UID],
        "names" : [partnerName, UserSettings.userDocument['name']]
          });
    } catch (e) {
      Logs.addNode("FBManager", "addPrivateChat", e.toString());
    }
  }

  static Future<void> cancelOrder(String orderToken, String _uid) async {
    /// ОТКАЗ ОТ ЗАКАЗА РАБОТНИКОМ
    try {
      List<String> list = new List();
      var doc = await fbStore
          .collection(ORDERS_COLLECTION)
          .document(orderToken)
          .get();
      for (String node in doc.data['workers'])
        list.add(node);
      list.remove(_uid);
      await fbStore
          .collection(ORDERS_COLLECTION)
          .document(orderToken)
          .updateData({'workers': list});
    } catch (e) {
      Logs.addNode("FBManager", "CancelOrder", e.toString());
    }
  }

  static Future<QuerySnapshot> getOrdersList(Map<String, dynamic> searchParameters) async {
    try {
      Logs.addNode("FBManager", "getOrdersList",
          "radiusType: " + searchParameters['radius'].runtimeType.toString());
      Logs.addNode(
          "FBManager", "getOrdersList", "params: " + searchParameters.toString());


      Query query = fbStore
          .collection(ORDERS_COLLECTION);
          // .orderBy('added_time');
          
      if (searchParameters.containsKey("geolocation")) {
          List<GeoPoint> geoPoints = getSquareLimits(searchParameters['geolocation']['lat'], searchParameters['geolocation']['lon'], searchParameters['geolocation']['radius']);
          query = query.where('geopoint', isGreaterThan: geoPoints[0], isLessThan: geoPoints[1]);
//        .where("start_time", isGreaterThan: Timestamp.now());
      }

      searchParameters.forEach((String key, dynamic value) {
        // Logs.addNode("FBManager", "getOrdersList", key.toString());
        switch (key) {
          case "order_age":
            Logs.addNode("FBManager", "getOrdersList", Timestamp.fromMillisecondsSinceEpoch(
                Timestamp.now().millisecondsSinceEpoch - value).toDate().toIso8601String());
            query = query.where("added_time",
                isGreaterThanOrEqualTo: Timestamp.fromMillisecondsSinceEpoch(
                    Timestamp.now().millisecondsSinceEpoch - value));
            break;

          case "workType":
            Logs.addNode(
                "FBManager", "getOrdersList", "work_type: " + value.toString());
            query = query.where("work_type", isEqualTo: value);
            break;
            
          case "payType":
            Logs.addNode(
                "FBManager", "getOrdersList", "pay_type: " + value.toString());
            query = query.where("pay_type", isEqualTo: value);
            break;

          case "tags":
            Logs.addNode(
                "FBManager", "getOrdersList", "tags: " + value.toString());
            query = query.where("tags", arrayContainsAny: value);
            break;

          case "showContacts":
            Logs.addNode(
                "FBManager", "getOrdersList", "show_contacts: " + value.toString());
            query = query.where(
                "show_contacts", isEqualTo: value);
            break;

          case "payMin":
            Logs.addNode(
                "FBManager", "getOrdersList", "minPrice: " + value.toString());
            query = query.where("min_price",
                isGreaterThanOrEqualTo: value);
            break;

          case "startTime":
            Logs.addNode(
                "FBManager", "getOrdersList", "start_time: " + (value as Timestamp).toDate().toIso8601String());
            query = query.where("start_time",
                isGreaterThanOrEqualTo: value);
            break;

          case "endTime":
            Logs.addNode(
                "FBManager", "getOrdersList", "end_time: " + (value as Timestamp).toDate().toIso8601String());
            query = query.where("end_time",
                isLessThanOrEqualTo: value);
            break;
        }
      });

      Logs.addNode(
          "FBManager", "getOrdersList", "Final: " + query.buildArguments().toString());
      return await query.getDocuments();
    } catch (e) {
      Logs.addNode("FBManager", "getOrdersList", e.toString());
    }
  }

  // static dynamic getAppliedOrders(String _uid) {
  //   /// ПОЛУЧЕНИЕ ЗАКАЗОВ, ЗА КОТОРЫЕ ВЗЯЛСЯ ПОЛЬЗОВАТЕЛЬ
  //   try {
  //     return fbStore
  //         .collection(ORDERS_COLLECTION)
  //         .where('workers', arrayContains: _uid)
  //         .snapshots();
  //   } catch (e) {
  //     Logs.addNode("FBManager", "GetAppliedOrders", e.toString());
  //   }
  // }

static Future<QuerySnapshot> getAppliedOrders() async {
    /// ПОЛУЧЕНИЕ ЗАКАЗОВ, ЗА КОТОРЫЕ ВЗЯЛСЯ ПОЛЬЗОВАТЕЛЬ
    try {
      return await fbStore
          .collection(ORDERS_COLLECTION)
          .where('workers', arrayContains: UserSettings.UID)
          .getDocuments();
    } catch (e) {
      Logs.addNode("FBManager", "GetAppliedOrders", e.toString());
    }
  }

  static Future<List<DocumentSnapshot>> getUsersList(List<String> userIds) async {
    try {
      return (await fbStore
          .collection(USERS_COLLECTION)
          .where('token', whereIn: userIds)
          .getDocuments())
          .documents;
    } catch (e) {
      Logs.addNode("FBManager", "GetUserStatsList", e.toString());
    }
  }

  static removeFromOrder(List workersId, DocumentSnapshot _documentSnapshot) {
    try {
      List _tempListWorkers = List.from(_documentSnapshot.data['workers']);
      List _tempListQuery = List.from(_documentSnapshot.data['query']);
      List _tempListApplied = List.from(_documentSnapshot.data['applied']);
      _tempListWorkers.removeWhere((elem) {
        return workersId.contains(elem);
      });
      _tempListQuery.removeWhere((elem) {
        return workersId.contains(elem);
      });
      _tempListApplied.removeWhere((elem) {
        return workersId.contains(elem);
      });
      fbStore
          .collection(ORDERS_COLLECTION)
          .document(_documentSnapshot.documentID)
          .updateData({
        "workers": _tempListWorkers,
        "query": _tempListQuery,
        "applied": _tempListApplied});
    } catch (e) {
      Logs.addNode("FBManager", "RemoveFormOrder", e.toString());
    }
  }

  static setPatentStatus(DocumentSnapshot document, String status) {
    try {
      fbStore
          .collection(USERS_COLLECTION)
          .document(document.documentID)
          .updateData({"status": status,
        "last_confirmation": Timestamp.now()});
    } catch (e) {
      Logs.addNode("FBManager", "SetPatentStatus", e.toString());
    }
  }

  static Future<void> updateNotificationSettings(bool notificationsOfAcceptance,
      bool notificationsOfResponding) async {
    try {
      await checkUserIdIfSet();
      await fbStore
          .collection(USERS_COLLECTION)
          .document(UserSettings.UID)
          .updateData({'notifications_of_acceptance': notificationsOfAcceptance,
        'notifications_of_responding': notificationsOfResponding});
    } catch (e) {
      Logs.addNode("FBManager", "UpdateNotifications", e.toString());
    }
  }

  static Future<String> checkUser(String uid) async {
    /// ПРОВЕРКА ПОЛЬЗОВАТЕЛЯ НА НАЛИЧИЕ В БАЗЕ ДАННЫХ
    var query = await fbStore.collection('users').document(uid).get();

    if (query.data != null && query.data.isNotEmpty)
      return query.data['role'];
    else
      return null;
  }

  static Future<DocumentSnapshot> GetOrderStats(String orderToken) async {
    /// ДАЕТ ДОСТУП КО ВСЕМ ДАННЫМ ПО ЗАКАЗУ
    /// ДАЛЕЕ ВО ФРОНТЕ НАДО СДЕЛТЬ ФИЛЬТР ПО ТОМУ, КОМУ ЗАКАЗ ПОКАЗЫВАЕТСЯ
    return await fbStore.collection("orders").document(orderToken).get();

    /// ПОСМОТРИ В registration.dart МЕТОД CheckUser, ТАМ ПРИМЕР ЧТО ЭТА ХРЕНЬ ВОЗВРАЩАЕТ
    /// ТОЛЬКО ТУТ ЕЩЕ ТАБЛИЦА ВОРКЕРОВ, КОТОРЫЕ СОГЛАСИЛИСЬ НА РАБОТУ
  }

  static Future<void> CancelOrder(String orderToken, String uid) async {
    /// ОТКАЗ ОТ ЗАКАЗА РАБОТНИКОМ
    List<String> listOfWorkers = new List();
    List<String> listOfQuerys = new List();
    List<String> listOfApplied = new List();
    var doc = await fbStore
        .collection("orders")
        .document(orderToken)
        .get();
    for (String node in doc.data['workers'])
      listOfWorkers.add(node);
    listOfWorkers.remove(uid);
    for (String node in doc.data['query'])
      listOfQuerys.add(node);
    listOfQuerys.remove(uid);
    for (String node in doc.data['applied'])
      listOfApplied.add(node);
    listOfApplied.remove(uid);
    await fbStore
        .collection(ORDERS_COLLECTION)
        .document(orderToken)
        .updateData({
      "workers": listOfWorkers,
      "query": listOfQuerys,
      "applied": listOfApplied});
  }

  static String getUserUid() {
    /// ЗИС ШИТ ДАЗ НОТ САППОРТ ВОРКИНГ
    FirebaseAuth.instance.currentUser().then((val) {
      print("FBManager: " + val.uid);
      return val.uid;
    });
  }

  static Future<DocumentSnapshot> getUserStats(String uid) async {
    /// ПОЛУЧЕНИЕ ДОКУМЕНТА ПО UID
    return await fbStore
        .collection(USERS_COLLECTION)
        .document(uid)
        .get();
  }

  static pushToApplied(String workerId, DocumentSnapshot order) {
    List listQuery = List.from(order.data['query']);
    listQuery.remove(workerId);
    List listApplied = List.from(order.data['applied']);
    listApplied.add(workerId);
    fbStore
        .collection(ORDERS_COLLECTION)
        .document(order.documentID)
        .updateData({"query": listQuery, "applied": listApplied});
  }

  static Future<void> sendMessage(String chatUid, String text) async {
    try {
      await fbStore
          .collection('privatechat')
          .document(chatUid)
          .collection('messages')
          .add({
        "author" : UserSettings.UID,
        "text" : text,
        "sent" : Timestamp.now(),
        "read" : false,
        //"name" : UserSettings.userDocument['name']
          });
    } catch (e) {
      Logs.addNode("FBManager", "sendMessage", e.toString());
    }
  }

  static Stream<QuerySnapshot> getChatStream(String chatUid) {
    try {
      return fbStore
          .collection('privatechat')
          .document(chatUid)
          .collection('messages')
          .orderBy("sent", descending: true)
          .snapshots();
    } catch (e) {
      Logs.addNode("FBManager", "getChatStream", e.toString());
    }
  }

//  static Future<void> pushToDeactivatedUsers() async {
//    try {
//      if (UserSettings.userDocument == null)
//        UserSettings.userDocument = await getUser(UserSettings.UID ?? (await FirebaseAuth.instance.currentUser()).uid);
//
//      await fbStore
//          .collection(USERS_COLLECTION)
//          .document(UserSettings.UID ?? (await FirebaseAuth.instance.currentUser()).uid)
//          .delete();
//
//      return await fbStore
//          .collection(DEACTIVATED_USERS_COLLECTION)
//          .document(UserSettings.UID ?? (await FirebaseAuth.instance.currentUser()).uid)
//          .setData(UserSettings.userDocument.data);
//
//    } catch (e) {
//      Logs.addNode("FBManager", "pushToDeactivatedUsers", e);
//    }
//  }

  static Future<void> pushToActiveUsers() async {
    try {
      if (UserSettings.userDocument == null)
        UserSettings.userDocument = await getFromDeactivatedUser(UserSettings.UID ?? (await FirebaseAuth.instance.currentUser()).uid);

      await fbStore
          .collection(DEACTIVATED_USERS_COLLECTION)
          .document(UserSettings.UID ?? (await FirebaseAuth.instance.currentUser()).uid)
          .delete();

      return await fbStore
          .collection(USERS_COLLECTION)
          .document(UserSettings.UID ?? (await FirebaseAuth.instance.currentUser()).uid)
          .setData(UserSettings.userDocument.data);

    } catch (e) {
      Logs.addNode("FBManager", "pushToDeactivatedUsers", e);
    }
  }

  static Future<DocumentSnapshot> getFromDeactivatedUser(String uid) async {
    try {
      return await fbStore
          .collection(DEACTIVATED_USERS_COLLECTION)
          .document(uid)
          .get();
    } catch (e) {
      Logs.addNode("FBManager", "pushToDeactivatedUsers", e);
//      throw new Exception(e.toString());
    }
  }

  static Future<void> incrementListViews(DocumentSnapshot document) async {
    try { 
      return await fbStore
          .collection(ORDERS_COLLECTION) 
          .document(document.documentID)
          .updateData({"list_views" : (document['list_views'] ?? 0) + 1});
    } catch (e) {
      Logs.addNode("FBManager", "incrementListViews", e);
    }
  }

  static Future<void> incrementLinkViews(DocumentSnapshot document) async {
    try { 
      return await fbStore
          .collection(ORDERS_COLLECTION) 
          .document(document.documentID)
          .updateData({"link_views" : (document['link_views'] ?? 0) + 1});
    } catch (e) {
      Logs.addNode("FBManager", "incrementLinkViews", e);
    }
  }
  
  static Future<List<DocumentSnapshot>> getFriendsList (List<dynamic> uids) async {
    try {
      return (await fbStore
          .collection('users')
          .where('token', whereIn: uids)
          .getDocuments()).documents;
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<List<DocumentSnapshot>> getPostsList (List<dynamic> uids) async {
    try {
      return (await fbStore
          .collection('posts')
          .where('token', whereIn: uids)
          .getDocuments()).documents;
    } catch (e) {
      print(e.toString());
    }
  }

}

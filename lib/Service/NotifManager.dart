import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import 'UserSettings.dart';

class NotifManager {
  static const String SERVER_TOKEN =
      'AAAAh-rTwhM:APA91bG_lmvJM2g9Ie4TDhdkhM5UUYY4WALi1Q_6PMAhXf6c6JqiGuKP9457gwQWQF7iiKaJp_zIDP1Ab31s4KQ1q0JUy2_L6cR_XQvBcutHrrv1NNa-nph8IWumwz0Hm53xe_IL3cec';

  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  static final Completer<Map<String, dynamic>> completer =
      Completer<Map<String, dynamic>>();

  static init() {
    firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: false),
    );
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("NotifManager: " + "onMessage: " + message.toString());
        completer.complete(message);
      },
      //onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("NotifManager: " + "onLaunch: $message");
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("NotifManager: " + "onResume: $message");
        //_navigateToItemDetail(message);
      },
    );
  }

  static GetDeviceToken() async {
    return await firebaseMessaging.getToken();
  }

  static GetResponseWordByGender(String gender){
    if(gender == "Муж")
      return "откликнулся";
    return "откликнулась";
  }

  static GetAcceptanceWordByGender(String gender){
    if(gender == "Муж")
      return "подтвердил";
    return "подтвердила";
  }

  static NotifyWorkersOfConfirmation(
      List devicesTokens, String orderId, String name, String orderName) async {
    devicesTokens.forEach((token) async {
      print(token);
      //await Future.delayed(const Duration(seconds: 2), () {});
      await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$SERVER_TOKEN',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': "Пойдете на работу $name?",
              'title': "Вас одобрили для заказа"
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'class': 'acceptToApplied',
              'orderId': orderId,
            },
            'to': token,
          },
        ),
      );
    });
  }

  static NotifyUsersOfMessage(
      List devicesTokens, String orderId, String name, String text, String orderName) async {
    devicesTokens.forEach((token) async {
      print(token);
      //await Future.delayed(const Duration(seconds: 2), () {});
      await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$SERVER_TOKEN',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': "$name: $text",
              'title': "Новое сообщение в обсуждениях $orderName"
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'class': 'newChatMessage',
              'orderId': orderId,
            },
            'to': token,
          },
        ),
      );
    });
  }

  static NotifyEmplOfResponding(
      String deviceToken, String orderId, String orderName) async {
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$SERVER_TOKEN',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': UserSettings.userDocument['name'] + " " + GetResponseWordByGender(UserSettings.userDocument['gender']) + " на Вашу вакансию " + orderName,
            'title': "Работник откликнулся!",
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'class': 'notifyEmplOfResponding',
            'orderId': orderId,
          },
          'to': deviceToken,
        },
      ),
    );
  }

  static NotifyEmplOfAcceptance(
      String deviceToken, String orderId, String orderName) async {
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$SERVER_TOKEN',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': UserSettings.userDocument['name'] + " " + GetAcceptanceWordByGender(UserSettings.userDocument['gender']) + " что придет к Вам на работу " + orderName,
            'title': "Работник подтвердил что придет!"
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'class': 'notifyEmplOfResponding',
            'orderId': orderId,
          },
          'to': deviceToken,
        },
      ),
    );
  }

  static Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: false),
    );

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$SERVER_TOKEN',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'this is a body',
            'title': 'this is a title'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to':
              'eUXgNCBthAE:APA91bFMF26PoKkBRevu6GhhyHOUWLW1u77z6yGp72FccselrKwqzoEdmWsz7bcIG6ZWliG8a1k41owm0FCrzCQOm9MI7mtU8v_p4mw7e1CtQbSsmZ47xhS9xt5lxSEz4Ut7s_LC5vkd',
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }
}

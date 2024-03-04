import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../Utils/share_preference.dart';


class NotificationsPushServices {

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String token = "";
  static StreamController<dynamic> streamController =  StreamController.broadcast();
  //static Stream<String> get messagesStream => streamController.stream;
  static Stream<dynamic> get dataNotification => streamController.stream;


  static Future _openHandler(RemoteMessage message) async{

    try{
      Map dataNotification = message.data;

      /* print("llega data ${dataNotification}" );
      var module = message.data['module'] ?? "";
      var moduleId = message.data['moduleId'] ?? "";
      dataNotification.putIfAbsent('module', () => module);
      dataNotification.putIfAbsent('moduleId', () => moduleId.toString());
      if(module == 'room'){
        var dataExtra = message.data['extra1'];
        Map<String, dynamic> decodeJson = json.decode(dataExtra);

        DataUserPushMessage dataUser = DataUserPushMessage.fromJson(decodeJson);
        dataNotification.putIfAbsent('dataUser', () => jsonEncode(dataUser));
      }*/
      dataNotification.putIfAbsent('isLocal', () => false);
      streamController.add(dataNotification);
    }catch(e){
      print("Error push notification....... $e");
    }

  }


  static Future _openHandler2(RemoteMessage message) async{

    try{

      Map dataNotification = message.data;
      /*print("llega data ${dataNotification}" );
      var module = message.data['module'] ?? "";
      var moduleId = message.data['moduleId'] ?? "";
      dataNotification.putIfAbsent('module', () => module);
      dataNotification.putIfAbsent('moduleId', () => moduleId.toString());
      if(module == 'room'){
        var dataExtra = message.data['extra1'];
        Map<String, dynamic> decodeJson = json.decode(dataExtra);

        DataUserPushMessage dataUser = DataUserPushMessage.fromJson(decodeJson);
        dataNotification.putIfAbsent('dataUser', () => jsonEncode(dataUser));
      }*/
      dataNotification.putIfAbsent('isLocal', () => true);
      dataNotification.putIfAbsent('title', () => message.notification?.title ?? "");
      dataNotification.putIfAbsent('description', () => message.notification?.body ?? "");


      streamController.add(dataNotification);
    }catch(e){
      print("Error push notification....... $e");
    }

  }

  static Future _openHandler3(RemoteMessage message) async {

    try{
      Map dataNotification = message.data;
      /* print("llega data ${dataNotification}" );
      var module = message.data['module'] ?? "";
      var moduleId = message.data['moduleId'] ?? "";
      dataNotification.putIfAbsent('module', () => module);
      dataNotification.putIfAbsent('moduleId', () => moduleId.toString());

      if(module == 'room'){
        var dataExtra = message.data['extra1'];
        Map<String, dynamic> decodeJson = json.decode(dataExtra);

        DataUserPushMessage dataUser = DataUserPushMessage.fromJson(decodeJson);
        dataNotification.putIfAbsent('dataUser', () => jsonEncode(dataUser));
      }
*/
      dataNotification.putIfAbsent('isLocal', () => false);
      dataNotification.putIfAbsent('title', () => message.notification?.title ?? "");
      dataNotification.putIfAbsent('description', () => message.notification?.body ?? "");

      streamController.add(dataNotification);
    }catch(e){
      print("Error push notification....... $e");
    }


  }


  static Future initializeApp() async{
    //Push notifications
    await Firebase.initializeApp();

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    token = (await FirebaseMessaging.instance.getToken())!;
    print( "TokenPush: ${token} ==");
    final _preferences = SharePreference();
    _preferences.pushToken = token;
    //handler app en debuga

    FirebaseMessaging.onBackgroundMessage(_openHandler);
    //Handler para la app abierta y en segundo plano
    FirebaseMessaging.onMessage.listen(_openHandler2);
    FirebaseMessaging.onMessageOpenedApp.listen(_openHandler3);

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message){

      if(message != null) {
        Future.delayed(Duration(milliseconds: 5500)).then((value) {
          Map dataNotification = message.data;
          // var type = message.data['type'] ?? "";
          dataNotification.putIfAbsent('isLocal', () => false);
          //dataNotification.putIfAbsent('type', () => type);
          dataNotification.putIfAbsent('title', () => message.notification?.title ?? "");
          dataNotification.putIfAbsent('description', () => message.notification?.body ?? "");

          streamController.add(dataNotification);
        });
      }

    });

  }
  static closeStreams (){
    streamController.close();
  }
}


import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wawamko/src/Utils/share_preference.dart';

class  PushNotificationService {

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static late final String? token;
  static StreamController<dynamic> _messageStream = new StreamController.broadcast();
  static Stream<dynamic> get dataNotification => _messageStream.stream;

  static Future initNotifications() async{
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print("Este es el token $token");
    final prefsUser = SharePreference();
    prefsUser.pushToken = token??'';

    FirebaseMessaging.onMessage.listen(onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(onLaunch);
    FirebaseMessaging.onBackgroundMessage(onResume);
  }

   static Future<dynamic> onMessage(RemoteMessage message) async {
    print("========ON Message ==========");
    Map dataNotification = message.data;
    dataNotification.addAll({'isLocal':true});
    _messageStream.add(dataNotification);
  }

  static Future<dynamic> onLaunch(RemoteMessage message) async {
    print("========ON Launch ==========");

    Map dataNotification = message.data;
    dataNotification.addAll({'isLocal':false});
    _messageStream.add(dataNotification);
  }

  static Future<dynamic> onResume(RemoteMessage message) async {
    print("========ON Resume ==========");
    Map dataNotification = message.data;
    dataNotification.addAll({'isLocal':false});
    _messageStream.add(dataNotification);
  }

  static closeStream(){
    _messageStream.close();
  }

}

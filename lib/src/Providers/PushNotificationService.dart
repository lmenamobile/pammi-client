
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wawamko/src/Utils/share_preference.dart';

class  PushNotificationService {
  final prefsUser = SharePreference();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _messageNotificationStreamController = StreamController.broadcast();
  Stream<dynamic> get dataNotification => _messageNotificationStreamController.stream;

  static Future<dynamic> onBackgroundMessage(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }
  }

  initNotifications() async{

    await _firebaseMessaging.requestNotificationPermissions();
    final tokenPush = await _firebaseMessaging.getToken();
    prefsUser.pushToken = tokenPush;
    print("========FCM Token ==========");
    print('TOKEN:$tokenPush');
    _firebaseMessaging.configure(
      onMessage:onMessage,
      onBackgroundMessage: onBackgroundMessage,
      onLaunch: onLaunch,
      onResume: onResume,
    );
  }

  Future<dynamic> onMessage(Map<String, dynamic> message) async {
    print("========ON Message ==========");
    Map dataNotification = message['data'];
    dataNotification.addAll({'isLocal':true});
    _messageNotificationStreamController.sink.add(dataNotification);
  }

  Future<dynamic> onLaunch(Map<String, dynamic> message) async {
    print("========ON Launch ==========");

    Map dataNotification = message['data'];
    dataNotification.addAll({'isLocal':false});
    _messageNotificationStreamController.sink.add(dataNotification);
  }

  Future<dynamic> onResume(Map<String, dynamic> message) async {
    print("========ON Resume ==========");
    Map dataNotification = message['data'];
    dataNotification.addAll({'isLocal':false});
    _messageNotificationStreamController.sink.add(dataNotification);
  }

  dispose(){
    _messageNotificationStreamController?.close();
  }
}

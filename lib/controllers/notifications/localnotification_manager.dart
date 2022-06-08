import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:rxdart/rxdart.dart';

class LocalNotificationManager{
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initSetting;
  BehaviorSubject<ReceiveNotification> get didReceiveLocalNotificationSubject => BehaviorSubject<ReceiveNotification>();

  LocalNotificationManager.init(){
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if(Platform.isIOS){
      requestIOSPermission();
    }
    initializePlatform();
  }

  requestIOSPermission(){
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true
    );
  }

  initializePlatform(){
    var initSettingAndroid = const AndroidInitializationSettings("taxinet_cab");
    var initSettingIOS = IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: (id,title,body,payload)async{
          ReceiveNotification notification = ReceiveNotification(id: id, title: title, body: body, payload: payload);
          didReceiveLocalNotificationSubject.add(notification);

        }
    );
    initSetting = InitializationSettings(android: initSettingAndroid,iOS: initSettingIOS);
  }

  //ride reject alert
  setOnRejectedRideNotificationReceive(Function onNotificationReceive){
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }
  setOnRejectedRideNotificationClick(Function onNotificationClick)async{
    await flutterLocalNotificationsPlugin.initialize(initSetting,onSelectNotification: (String? payload)async{
      onNotificationClick(payload);
    });
  }
  Future<void> showRejectedRideNotification(String? title,String? body) async{
    var androidChannel = const AndroidNotificationDetails(
        "CHANNEL_ID",
        "CHANNEL_NAME",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound("horn")
    );
    var iosChannel = const IOSNotificationDetails();
    var platformChannel = NotificationDetails(android: androidChannel,iOS: iosChannel);
    await flutterLocalNotificationsPlugin.show(0,title,body,platformChannel,payload: "New Payload");
  }

//  ride accept alert
  setOnAcceptedRideNotificationReceive(Function onNotificationReceive){
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }
  setOnAcceptedRideNotificationClick(Function onNotificationClick)async{
    await flutterLocalNotificationsPlugin.initialize(initSetting,onSelectNotification: (String? payload)async{
      onNotificationClick(payload);
    });
  }
  Future<void> showAcceptedRideNotification(String? title,String? body) async{
    var androidChannel = const AndroidNotificationDetails(
        "CHANNEL_ID",
        "CHANNEL_NAME",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound("horn")
    );
    var iosChannel = const IOSNotificationDetails();
    var platformChannel = NotificationDetails(android: androidChannel,iOS: iosChannel);
    await flutterLocalNotificationsPlugin.show(0,title,body,platformChannel,payload: "New Payload");
  }

//  ride complete alert
  setOnCompletedRideNotificationReceive(Function onNotificationReceive){
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }
  setOnCompletedRideNotificationClick(Function onNotificationClick)async{
    await flutterLocalNotificationsPlugin.initialize(initSetting,onSelectNotification: (String? payload)async{
      onNotificationClick(payload);
    });
  }
  Future<void> showCompletedRideNotification(String? title,String? body) async{
    var androidChannel = const AndroidNotificationDetails(
        "CHANNEL_ID",
        "CHANNEL_NAME",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound("horn")
    );
    var iosChannel = const IOSNotificationDetails();
    var platformChannel = NotificationDetails(android: androidChannel,iOS: iosChannel);
    await flutterLocalNotificationsPlugin.show(0,title,body,platformChannel,payload: "New Payload");
  }

//  driver arrival alert
  setOnDriverArrivalNotificationReceive(Function onNotificationReceive){
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }
  setOnDriverArrivalNotificationClick(Function onNotificationClick)async{
    await flutterLocalNotificationsPlugin.initialize(initSetting,onSelectNotification: (String? payload)async{
      onNotificationClick(payload);
    });
  }
  Future<void> showDriverArrivalNotification(String? title,String? body) async{
    var androidChannel = const AndroidNotificationDetails(
        "CHANNEL_ID",
        "CHANNEL_NAME",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound("horn")
    );
    var iosChannel = const IOSNotificationDetails();
    var platformChannel = NotificationDetails(android: androidChannel,iOS: iosChannel);
    await flutterLocalNotificationsPlugin.show(0,title,body,platformChannel,payload: "New Payload");
  }

  //  bid complete alert
  setOnBidCompleteNotificationReceive(Function onNotificationReceive){
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }
  setOnBidCompleteNotificationClick(Function onNotificationClick)async{
    await flutterLocalNotificationsPlugin.initialize(initSetting,onSelectNotification: (String? payload)async{
      onNotificationClick(payload);
    });
  }
  Future<void> showBidCompleteNotification(String? title,String? body) async{
    var androidChannel = const AndroidNotificationDetails(
        "CHANNEL_ID",
        "CHANNEL_NAME",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound("horn")
    );
    var iosChannel = const IOSNotificationDetails();
    var platformChannel = NotificationDetails(android: androidChannel,iOS: iosChannel);
    await flutterLocalNotificationsPlugin.show(0,title,body,platformChannel,payload: "New Payload");
  }


}

LocalNotificationManager localNotificationManager = LocalNotificationManager.init();

class ReceiveNotification{
  final int? id;
  final String? title;
  final String? body;
  final String? payload;
  ReceiveNotification({required this.id,required this.title,required this.body,required this.payload});
}
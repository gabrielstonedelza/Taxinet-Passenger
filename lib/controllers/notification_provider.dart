import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class NotificationProvider extends ChangeNotifier {
  final String _uToken = GetStorage().read("userToken");
  List _triggeredNotifications = [];
  List _triggered = [];
  List _yourNotifications = [];
  List _notRead = [];
  List _allNotifications = [];
  List _allNots = [];

  String _driver = "";
  final storage = GetStorage();
  var username = "";
  String uToken = "";

//  getters
  List get triggeredNotifications => _triggeredNotifications;
  List get triggered => _triggered;
  List get yourNotifications => _yourNotifications;
  List get notRead => _notRead;
  List get allNotifications => _allNotifications;
  List get allNots => _allNots;
  String get driver => _driver;


//  setter

  void _setTriggeredNotifications(List triggeredNotifies){
    _triggeredNotifications = triggeredNotifies;
    notifyListeners();
  }

  void _setTriggered(List triggred){
    _triggered = triggred;
    notifyListeners();
  }

  void _setYourNotifications(List yNotifications){
    _yourNotifications = yNotifications;
    notifyListeners();
  }

  void _setNotReadNotifications(List notR){
    _notRead = notR;
    notifyListeners();
  }

  void _setAllNotifications(List allNots){
    _allNotifications = allNots;
    notifyListeners();
  }

  void _setAllNots(List nots){
    _allNots = nots;
    notifyListeners();
  }

  void setDriver(String d){
    _driver = d;
    notifyListeners();
  }


  Future<void> getAllTriggeredNotifications() async {
    const url = "https://taxinetghana.xyz/user_triggerd_notifications/";
    var myLink = Uri.parse(url);
    final response =
    await http.get(myLink, headers: {"Authorization": "Token $_uToken"});
    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      _setTriggeredNotifications(json.decode(jsonData));
      _setTriggered(_triggeredNotifications);
      notifyListeners();
    }
    else{
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getAllUnReadNotifications() async {
    const url = "https://taxinetghana.xyz/user_notifications/";
    var myLink = Uri.parse(url);
    final response =
    await http.get(myLink, headers: {"Authorization": "Token $_uToken"});
    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      _setYourNotifications(json.decode(jsonData));
      _setNotReadNotifications(_yourNotifications);
      notifyListeners();
    }
  }

  Future<void> getAllNotifications() async {
    const url = "https://taxinetghana.xyz/notifications/";
    var myLink = Uri.parse(url);
    final response =
    await http.get(myLink, headers: {"Authorization": "Token $_uToken"});
    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      _setAllNotifications(json.decode(jsonData));
      _setAllNots(_allNotifications);
      notifyListeners();
    }
    else{
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  unTriggerNotifications(int id) async {
    final requestUrl = "https://taxinetghana.xyz/user_read_notifications/$id/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $_uToken"
    }, body: {
      "notification_trigger": "Not Triggered",
    });
    if (response.statusCode == 200) {}
  }

  updateReadNotification(int id) async {
    final requestUrl = "https://taxinetghana.xyz/user_read_notifications/$id/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $_uToken"
    }, body: {
      "read": "Read",
    });
    if (response.statusCode == 200) {}
  }

}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class NotificationController extends GetxController {
  static NotificationController get to => Get.find<NotificationController>();
  late List allNotifications = [];
  bool isLoading = true;
  final storage = GetStorage();
  var username = "";
  late String uToken = "";

  late Timer _timer;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    getAllNotifications();
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      getAllNotifications();
      update();
    });
  }

  Future<void> getAllNotifications() async {
    const url = "https://taxinetghana.xyz/passengers_notifications/";
    var myLink = Uri.parse(url);
    final response =
        await http.get(myLink, headers: {"Authorization": "Token $uToken"});
    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      allNotifications = json.decode(jsonData);
      if (kDebugMode) {
        // print(response.body);
      }
    } else {
      if (kDebugMode) {
        // print(response.body);
      }
    }
  }
}

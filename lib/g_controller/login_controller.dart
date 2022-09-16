import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:taxinet/passenger/home/passenger_home.dart';

import '../constants/app_colors.dart';
import '../views/bottomnavigationbar.dart';

class MyLoginController extends GetxController{
  static MyLoginController get to => Get.find<MyLoginController>();
  final storage = GetStorage();
  var username = "";
  final password = "";
  String userVerified = "Not Verified";
  String loggedInUserId = "";
  String deToken = "";

  late List allPassengers = [];
  late List passengerUserNames = [];
  bool isLoading = true;
  bool hasErrors = false;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllPassengers();
  }

  Future<void> getAllPassengers() async {
    try {
      isLoading = true;
      const completedRides = "https://taxinetghana.xyz/all_passengers";
      var link = Uri.parse(completedRides);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allPassengers.assignAll(jsonData);
        for(var i in allPassengers){
          passengerUserNames.add(i['username']);
        }
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    finally{
      isLoading = false;
    }
  }

  loginUser(String uname, String uPassword) async {
    const loginUrl = "https://taxinetghana.xyz/auth/token/login/";
    final myLogin = Uri.parse(loginUrl);

    http.Response response = await http.post(myLogin,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"username": uname, "password": uPassword});

    if (response.statusCode == 200) {
      final resBody = response.body;
      var jsonData = jsonDecode(resBody);
      var userToken = jsonData['auth_token'];
      var userId = jsonData['id'];
      loggedInUserId = userId.toString();
      deToken = userToken;
      storage.write("username", uname);
      storage.write("userToken", userToken);
      storage.write("userType", "Passenger");
      storage.write("verified", userVerified);
      storage.write("userid", userId);
      username = uname;
      update();

      if (passengerUserNames.contains(uname)) {
        Timer(const Duration(seconds: 1), () =>
            Get.offAll(() => const MyBottomNavigationBar()));
      }
      else {

        Get.snackbar("Sorry 😢", response.body,
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: defaultTextColor1);
      }
    }
  }
}
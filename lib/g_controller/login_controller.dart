import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:taxinet/passenger/home/passenger_home.dart';

class MyLoginController extends GetxController{
  static MyLoginController get to => Get.find<MyLoginController>();
  final storage = GetStorage();
  var username = "";
  final password = "";

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
      Get.snackbar("Sorry",
          "something happened or please check your internet connection");
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
      storage.write("username", uname);
      storage.write("userToken", userToken);
      storage.write("userType", "Passenger");
      username = uname;
      update();

      hasErrors = false;
      if (passengerUserNames.contains(uname)) {
        Timer(const Duration(seconds: 5), () =>
            Get.offAll(() => const PassengerHome()));
      }
      else {
        hasErrors = true;
        Get.snackbar(
            "Error 😢", "You are not a passenger or invalid credentials provided",
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 8)
        );
      }
    }
  }
}
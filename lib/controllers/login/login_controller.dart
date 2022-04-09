import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../driver/home/driver_home.dart';
import '../../passenger/home/passenger_home.dart';


class LoginController extends ChangeNotifier{

  final client = http.Client();
  final storage = GetStorage();

  var username = "";
  late final password = "";
  var userType = "";
  late List userData = [];

  late List userProfile = [];
  var profilePic = "";
  var ghCard = "";
  var cardName = "";
  var cardNumber = "";
  var nextOfKin = "";
  var nextOfKinNum = "";
  var referral = "";
  var referralNum = "";
  late bool verified;

  String get uName => username;
  String get userProfilePic => profilePic;
  List get userInfoData => userProfile;
  String get uType => userType;

  loginUser(String uname,String uPassword) async{
    const loginUrl = "https://taxinetghana.xyz/auth/token/login/";
    final myLogin = Uri.parse(loginUrl);

    http.Response  response = await client.post(myLogin,headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "username": uname,
      "password": uPassword
    });

    if(response.statusCode == 200){
      final resBody = response.body;
      var jsonData = jsonDecode(resBody);
      var userToken = jsonData['auth_token'];
      storage.write("username", uname);
      storage.write("userToken", userToken);
      getUserInfo(userToken);
      getUserProfile(userToken);
      username = uname;
       userType == "Passenger" ? Get.offAll(()=> const PassengerHome()) : Get.offAll(() => const DriverHome());
      notifyListeners();
    }
    else{
      Get.snackbar(
        "Error", "Invalid login details",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red
      );
    }

  }

  Future<void> getUserInfo(String token)async{
    const userUrl = "https://taxinetghana.xyz/get_user/";
    final myUser = Uri.parse(userUrl);
    final response = await http.get(myUser, headers: {
      "Authorization": "Token $token"
    });
    if(response.statusCode ==200){
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      userData = json.decode(jsonData);
      for(var i in userData){
        userType = i['user_type'];
      }

      storage.write("user_type",userType);
    }
    else{
      Get.snackbar(
          "Error", "Couldn't find user data",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red
      );
    }
  }

  Future<void> getUserProfile(String token) async{
    const profileUrl = "https://taxinetghana.xyz/passenger-profile/";
    final myProfile = Uri.parse(profileUrl);
    final response = await http.get(myProfile, headers: {
      "Authorization": "Token $token"
    });

    if(response.statusCode ==200){
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      userProfile = json.decode(jsonData);
      for(var i in userProfile){
        profilePic = i['passenger_profile_pic'];
      }
      print(profilePic);
    }
    else{
      Get.snackbar(
          "Error", "Couldn't find user data",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red
      );
    }
  }
}


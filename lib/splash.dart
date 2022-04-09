import 'dart:async';
import 'package:get/get.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:taxinet/passenger/home/passenger_home.dart';
import 'package:taxinet/views/login/loginview.dart';

import 'constants/app_colors.dart';
import 'driver/home/driver_home.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = GetStorage();
  late String username = "";
  late String token = "";
  late String userType = "";
  bool hasToken = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(storage.read("username") != null && storage.read("userToken") != null){
      username = storage.read("username");
      setState(() {
        hasToken = true;
      });
    }

    if(hasToken && storage.read("user_type")=="Driver"){
      Timer(const Duration(seconds: 7),()=> Get.offAll(() => const DriverHome()));
    }
    if(hasToken && storage.read("user_type")=="Passenger"){
      Timer(const Duration(seconds: 7),()=> Get.offAll(() => const PassengerHome()));
    }
    if(storage.read("username") == null && storage.read("userToken") == null && storage.read("user_type") == null){
      Timer(const Duration(seconds: 7),()=> Get.offAll(() => const LoginView()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: TextLiquidFill(
              loadDuration: const Duration(seconds: 5),
              // waveDuration: const Duration(seconds: 4),
              text: 'Taxinet',
              waveColor: primaryColor,
              boxBackgroundColor: Colors.black,
              textStyle: const TextStyle(
                fontSize: 60.0,
                fontWeight: FontWeight.bold,
              ),
              // boxHeight: 300.0,
            ),
          ),

        ],
      ),
    );
  }
}
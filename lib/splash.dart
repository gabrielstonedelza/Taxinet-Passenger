import 'dart:async';
import 'package:get/get.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:taxinet/passenger/home/passenger_home.dart';
import 'package:taxinet/views/bottomnavigationbar.dart';
import 'package:taxinet/views/login/loginview.dart';
import 'package:taxinet/views/login/newlogin.dart';


import 'g_controller/login_controller.dart';

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
    super.initState();
    final loginController = MyLoginController.to;
    if (storage.read("username") != null && storage.read("userToken") != null) {
      username = storage.read("username");
      setState(() {
        hasToken = true;
      });
    }

    loginController.getAllPassengers();

    if (hasToken && storage.read("userType") == "Passenger") {
      Timer(const Duration(seconds: 7),
              () => Get.offAll(() => const MyBottomNavigationBar()));
    } else {
      Timer(const Duration(seconds: 7),
              () => Get.offAll(() => const NewLogin()));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: TextLiquidFill(
              loadDuration: const Duration(seconds: 5),
              // waveDuration: const Duration(seconds: 4),
              text: 'Taxinet',
              waveColor: Colors.black,
              boxBackgroundColor: Colors.amber,
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

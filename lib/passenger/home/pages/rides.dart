import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../g_controller/userController.dart';

class Rides extends StatefulWidget {
  const Rides({Key? key}) : super(key: key);

  @override
  State<Rides> createState() => _RidesState();
}

class _RidesState extends State<Rides> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Get.find<UserController>().referral != "" ? const Text("This is rides"): const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text("Sorry 😢,you need to verify your account in your profile by providing a valid referral from Taxinet."),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../g_controller/userController.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final uController = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: uController.referral != "" ? const Text("This is notifications"): const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text("Sorry 😢,you need to verify your account in your profile by providing a valid referral from Taxinet."),
          ),
        ),
      ),
    );
  }
}
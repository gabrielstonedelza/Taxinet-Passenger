import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../views/login/loginview.dart';
import '../constants/app_colors.dart';

class MyRegistrationController extends GetxController{
  static MyRegistrationController get to => Get.find<MyRegistrationController>();

  registerUser(String uname,String email,String fName,String phoneNumber,String uPassword, String uRePassword) async {
    const loginUrl = "https://taxinetghana.xyz/auth/users/";
    final myLogin = Uri.parse(loginUrl);

    http.Response response = await http.post(myLogin,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"username": uname,"email":email,"full_name":fName,"phone_number":phoneNumber, "password": uPassword,"re_password":uRePassword});

    if (response.statusCode == 201) {
      Get.defaultDialog(
          title: "",
          radius: 20,
          backgroundColor: Colors.black54,
          barrierDismissible: false,
          content: Row(
            children: const [
              Expanded(child: Center(child: CircularProgressIndicator.adaptive(
                strokeWidth: 5,
                backgroundColor: primaryColor,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ))),
              Expanded(child: Text("Processing",style: TextStyle(color: Colors.white),))
            ],
          )
      );
      Get.offAll(()=> const LoginView());
    }
      else {
        Get.snackbar(
            "Error 😢", response.body.toString(),
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5)
        );
        return;
      }
    }
  }

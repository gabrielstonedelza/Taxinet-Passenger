import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

import 'package:taxinet/constants/app_colors.dart';

import 'login_controller.dart';

class UserController extends GetxController {
  final myLoginController = MyLoginController.to;
  final storage = GetStorage();
  var username = "";
  String uToken = "";
  String passengerProfileId = "";
  String passengerUsername = "";
  String profileImage = "";
  String nameOnGhanaCard = "";
  String email = "";
  String phoneNumber = "";
  String fullName = "";
  String nextOfKin = "";
  String nextOfKinPhoneNumber = "";
  String frontGhanaCard = "";
  String backGhanaCard = "";
  String referral = "";
  String uniqueCode = "";
  String promoterName = "";
  String promoter = "";
  late bool verified;
  bool isVerified = false;
  late String updateUserName;
  late String updateEmail;
  late String updatePhone;
  bool isUpdating = true;
  var dio = Dio();
  bool hasUploadedFrontCard = false;
  bool hasUploadedBackCard = false;

  late List profileDetails = [];

  late List allUsers = [];
  late List phoneNumbers = [];
  late List driversUniqueCodes = [];
  late List allDrivers = [];
  late List driversNames = [];
  late List passengerNames = [];
  late List passengersUniqueCodes = [];
  late List allPassengers = [];
  late List allUsersUniqueCodes = [];


  bool isLoading = true;
  bool isOpened = false;
  bool isUploading = false;
  late Timer _timer;
  File? image;
  late List profileDetails1 = [];


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
  
  }

  File? profileImageUpload;
  File? frontCard;
  File? backCard;

  //front cards

  Future getFromGalleryForFrontCard() async{
    try {
      final myImage  = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(myImage == null) return;
      final imageTemporary = File(myImage.path);
      image = imageTemporary;
      update();
      if(image != null){
        _uploadAndUpdateFrontCard(image!);
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Error");
      }
    }

  }

  Future getFromCameraForFrontCard() async{
    try {
      final myImage  = await ImagePicker().pickImage(source: ImageSource.camera);
      if(myImage == null) return;
      final imageTemporary = File(myImage.path);
      image = imageTemporary;
      update();
      if(image != null){
        _uploadAndUpdateFrontCard(image!);
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Error");
      }
    }

  }

  //front card

  //back cards

  Future getFromGalleryForBackCard() async{
    try {
      final myImage  = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(myImage == null) return;
      final imageTemporary = File(myImage.path);
      image = imageTemporary;
      update();
      if(image != null){
        _uploadAndUpdateBackCard(image!);
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Error");
      }
    }

  }

  Future getFromCameraForBackCard() async{
    try {
      final myImage  = await ImagePicker().pickImage(source: ImageSource.camera);
      if(myImage == null) return;
      final imageTemporary = File(myImage.path);
      image = imageTemporary;
      update();
      if(image != null){
        _uploadAndUpdateBackCard(image!);
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Error");
      }
    }

  }

  //back card

  //profile cards

  Future getFromGalleryForProfilePic() async{
    try {
      final myImage  = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(myImage == null) return;
      final imageTemporary = File(myImage.path);
      image = imageTemporary;
      update();
      if(image != null){
        _uploadAndUpdateProfilePic(image!);
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Error");
      }
    }

  }

  Future getFromCameraForProfilePic() async{
    try {
      final myImage  = await ImagePicker().pickImage(source: ImageSource.camera);
      if(myImage == null) return;
      final imageTemporary = File(myImage.path);
      image = imageTemporary;
      update();
      if(image != null){
        _uploadAndUpdateProfilePic(image!);
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Error");
      }
    }

  }

  //profile card


  void _uploadAndUpdateProfilePic(File file) async {
    try {
      isUpdating = true;
      //updating user profile details
      String fileName = file.path.split('/').last;
      var formData1 = FormData.fromMap({
        'profile_pic':
            await MultipartFile.fromFile(file.path, filename: fileName),
      });
      var response = await dio.put(
        'https://taxinetghana.xyz/update_passenger_profile/',
        data: formData1,
        options: Options(headers: {
          "Authorization": "Token $uToken",
          "HttpHeaders.acceptHeader": "accept: application/json",
        }, contentType: Headers.formUrlEncodedContentType),
      );
      if (response.statusCode != 200) {
        Get.snackbar("Sorry", response.data.toString(),
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red);
      } else {
        Get.snackbar("Hurray 😀", "Your profile picture was updated",
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: primaryColor,
            duration: const Duration(seconds: 5));
      }
    } on DioError catch (e) {
      Get.snackbar("Sorry", e.toString(),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: snackColor);
    } finally {
      isUpdating = false;
    }
  }

  void _uploadAndUpdateFrontCard(File file) async {
    try {
      isUpdating = true;
      //updating user profile details
      String fileName = file.path.split('/').last;
      var formData1 = FormData.fromMap({
        'front_side_ghana_card':
            await MultipartFile.fromFile(file.path, filename: fileName),
      });
      var response = await dio.put(
        'https://taxinetghana.xyz/update_passenger_profile/',
        data: formData1,
        options: Options(headers: {
          "Authorization": "Token $uToken",
          "HttpHeaders.acceptHeader": "accept: application/json",
        }, contentType: Headers.formUrlEncodedContentType),
      );
      if (response.statusCode != 200) {
        Get.snackbar("Sorry", "Something happened. Please try again later",
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red);
      } else {
        Get.snackbar("Hurray 😀", "card uploaded successfully,you will be notified when verified.",
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: primaryColor,
            duration: const Duration(seconds: 5));
      }
    } on DioError catch (e) {
      Get.snackbar("Sorry", "Something happened. Please try again later",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red);
    }
    finally {
      isUpdating = false;
    }
  }

  void _uploadAndUpdateBackCard(File file) async {
    try {
      isUpdating = true;
      //updating user profile details
      String fileName = file.path.split('/').last;
      var formData1 = FormData.fromMap({
        'back_side_ghana_card':
            await MultipartFile.fromFile(file.path, filename: fileName),
      });
      var response = await dio.put(
        'https://taxinetghana.xyz/update_passenger_profile/',
        data: formData1,
        options: Options(headers: {
          "Authorization": "Token $uToken",
          "HttpHeaders.acceptHeader": "accept: application/json",
        }, contentType: Headers.formUrlEncodedContentType),
      );
      if (response.statusCode != 200) {
        Get.snackbar("Sorry", "something happened,please try again later",
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red);
      } else {
        Get.snackbar("Hurray 😀", "card uploaded successfully,you will be notified when verified.",
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: primaryColor,
            duration: const Duration(seconds: 5));
      }
    } on DioError catch (e) {
      Get.snackbar("Sorry", "something happened,please try again later",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red);
    }
    finally {
      isUpdating = false;
    }
  }

  Future<void> getUserProfile(String token) async {
    try {
      isLoading = true;
      update();
      const profileLink = "https://taxinetghana.xyz/passenger-profile";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $token"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        profileDetails = jsonData;
        for (var i in profileDetails) {
          profileImage = i['passenger_profile_pic'];
          nameOnGhanaCard = i['name_on_ghana_card'];
          email = i['get_passengers_email'];
          phoneNumber = i['get_passengers_phone_number'];
          promoterName = i['get_promoter_username'];
          promoter = i['promoter'].toString();
          fullName = i['get_passengers_full_name'];
          nextOfKin = i['next_of_kin'];
          nextOfKinPhoneNumber = i['next_of_kin_number'];
          frontGhanaCard = i['get_front_side_ghana_card'];
          backGhanaCard = i['get_back_side_ghana_card'];
          referral = i['referral'];
          verified = i['verified'];
          passengerProfileId = i['user'].toString();
          passengerUsername = i['username'].toString();
        }
        update();
        storage.write("verified", "Verified");
        storage.write("profile_id", passengerProfileId);
        storage.write("profile_name", fullName);
        storage.write("profile_pic", profileImage);
        storage.write("passenger_username", passengerUsername);
      }
      else{
        if (kDebugMode) {
          print(response.body);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
      update();
    }
  }


  Future<void> getAllUsers(String token) async {
    try {
      isLoading = true;
      const profileLink = "https://taxinetghana.xyz/users/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $token"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allUsers = jsonData;
        for (var i in allUsers) {
         if(!phoneNumbers.contains(i['phone_number'])){
           phoneNumbers.add(i['phone_number']);
         }
        }

        update();
      }
      else{
        if (kDebugMode) {
          print(response.body);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }
  Future<void> getMyAllUsers() async {
    try {
      isLoading = true;
      const profileLink = "https://taxinetghana.xyz/all_users/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allDrivers = jsonData;
        for (var i in allDrivers) {
          if(!allUsersUniqueCodes.contains(i['unique_code'])){
            allUsersUniqueCodes.add(i['unique_code']);
          }
        }
        update();

      }
      else{
        if (kDebugMode) {
          print("response.body");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> getUserDetails(String token) async {
    try {
      isLoading = true;
      const profileLink = "https://taxinetghana.xyz/get_user/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $token"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        profileDetails1 = jsonData;
        // print(profileDetails1);
        for (var i in profileDetails1) {
          uniqueCode = i['unique_code'];
        }
        update();
      }
      else{
        if (kDebugMode) {
          print(response.body);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }


  updateProfileDetails(String updateUserName, String updateEmail,String fullName, String updatePhone) async {
    const updateUrl = "https://taxinetghana.xyz/update_username/";
    final myUrl = Uri.parse(updateUrl);
    http.Response response = await http.put(
      myUrl,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $uToken"
      },
      body: {
        "username": updateUserName,
        "email": updateEmail,
        "full_name": fullName,
        "phone_number": updatePhone
      },
    );
    if (response.statusCode == 200) {
      Get.snackbar("Hurray 😀", "Your profile was updated",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          colorText: defaultTextColor1);
      update();
      isUpdating = false;
    } else {
      Get.snackbar("Sorry 😢", response.body,
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: defaultTextColor1);
    }
  }


}

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

import 'package:taxinet/constants/app_colors.dart';

class UserController extends GetxController{

  final storage = GetStorage();
  var username = "";
  String uToken = "";
  String profileImage = "";
  String nameOnGhanaCard = "";
  String email = "";
  String phoneNumber = "";
  String fullName = "";
  String frontGhanaCard = "";
  String backGhanaCard = "";
  String referral = "";
  String verified = "";
  bool isVerified = false;
  late String updateUserName;
  late String updateEmail;
  late String updatePhone;
  bool isUpdating = false;
  var dio = Dio();

  late List profileDetails = [];
  late List passengerUserNames = [];

  bool isLoading = true;


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
    getUserProfile();
  }

  File? profileImageUpload;
  File? frontCard;
  File? backCard;

  Future getFromGalleryForProfilePic()async{
    PickedFile? pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxHeight: 1080,
        maxWidth: 1080
    );
    _cropImageProfilePic(pickedFile!.path);
  }
  Future getFromGalleryForFrontCard()async{
    PickedFile? pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxHeight: 1080,
        maxWidth: 1080
    );
    _cropImageFrontCard(pickedFile!.path);
  }
  Future getFromGalleryForBackCard()async{
    PickedFile? pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxHeight: 1080,
        maxWidth: 1080
    );
    _cropImageForBackCard(pickedFile!.path);
  }

  Future getFromCameraForProfilePic()async{
    PickedFile? pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxHeight: 1080,
        maxWidth: 1080
    );
    _cropImageProfilePic(pickedFile!.path);
  }
  Future getFromCameraForFrontCard()async{
    PickedFile? pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxHeight: 1080,
        maxWidth: 1080
    );
    _cropImageFrontCard(pickedFile!.path);
  }
  Future getFromCameraForBackCard()async{
    PickedFile? pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxHeight: 1080,
        maxWidth: 1080
    );
    _cropImageForBackCard(pickedFile!.path);
  }

  Future _cropImageProfilePic(filePath)async{
    File? croppedImage = await ImageCropper().cropImage(
        sourcePath: filePath,maxHeight:1080,maxWidth:1080
    );
    if(croppedImage != null){
      profileImageUpload = croppedImage;
      _uploadAndUpdateProfilePic(profileImageUpload!);
      getUserProfile();
      update();
    }
  }
  Future _cropImageForBackCard(filePath)async{
    File? croppedImage = await ImageCropper().cropImage(
        sourcePath: filePath,maxHeight:1080,maxWidth:1080
    );
    if(croppedImage != null){
      backCard = croppedImage;
      _uploadAndUpdateBackCard(backCard!);
      update();
    }
  }
  Future _cropImageFrontCard(filePath)async{
    File? croppedImage = await ImageCropper().cropImage(
        sourcePath: filePath,maxHeight:1080,maxWidth:1080
    );
    if(croppedImage != null){
      frontCard = croppedImage;
      _uploadAndUpdateFrontCard(frontCard!);
      update();
    }
  }

  void _uploadAndUpdateProfilePic(File file) async {
    try {
      isUpdating = true;
      //updating user profile details
      String fileName = file.path.split('/').last;
      var formData1 = FormData.fromMap({
        'profile_pic': await MultipartFile.fromFile(file.path, filename: fileName),
      });
      var response = await dio.put('https://taxinetghana.xyz/update_passenger_profile/',
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
      }else{
        Get.snackbar("Hurray 😀","Your profile picture was updated",
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: primaryColor,
          duration: const Duration(seconds: 5)
        );
      }
    } on DioError catch (e) {
      Get.snackbar("Sorry", e.toString(),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: snackColor);
    }
    finally{
      isUpdating = false;
    }
  }
  void _uploadAndUpdateFrontCard(File file) async {
    try {
      //updating user profile details
      String fileName = file.path.split('/').last;
      var formData1 = FormData.fromMap({
        'front_side_ghana_card': await MultipartFile.fromFile(file.path, filename: fileName),
      });
      var response = await dio.put('https://taxinetghana.xyz/update_passenger_profile/',
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
      }
      else{
        Get.snackbar("Hurray 😀","card uploaded successfully",
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: primaryColor,
            duration: const Duration(seconds: 5)
        );
      }
    } on DioError catch (e) {
      Get.snackbar("Sorry", e.toString(),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: snackColor);
    }
  }
  void _uploadAndUpdateBackCard(File file) async {
    try {
      //updating user profile details
      String fileName = file.path.split('/').last;
      var formData1 = FormData.fromMap({
        'back_side_ghana_card': await MultipartFile.fromFile(file.path, filename: fileName),
      });
      var response = await dio.put('https://taxinetghana.xyz/update_passenger_profile/',
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

      }
      else{
        Get.snackbar("Hurray 😀","card uploaded successfully.",
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: primaryColor,
            duration: const Duration(seconds: 5)
        );
      }
    } on DioError catch (e) {
      Get.snackbar("Sorry", e.toString(),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: snackColor);
    }
  }

  Future<void> getUserProfile() async {
    try {
      isLoading = true;
      const profileLink = "https://taxinetghana.xyz/passenger-profile";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $uToken"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        profileDetails = jsonData;
        for(var i in profileDetails){
          profileImage = i['passenger_profile_pic'];
          nameOnGhanaCard = i['name_on_ghana_card'];
          email = i['get_passengers_email'];
          phoneNumber = i['get_passengers_phone_number'];
          fullName = i['get_passengers_full_name'];
          frontGhanaCard = i['get_front_side_ghana_card'];
          backGhanaCard = i['get_back_side_ghana_card'];
          referral = i['referral'];
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

  updateProfileDetails(String updateUserName,String updateEmail,String updatePhone)async{
    const updateUrl = "https://taxinetghana.xyz/update_username/";
    final myUrl = Uri.parse(updateUrl);
    http.Response response = await http.put(myUrl,
        headers: {
      "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "Token $uToken"
        },
        body: {"username": updateUserName,"email":updateEmail,"phone_number":updatePhone},

    );
    if(response.statusCode == 200){
      Get.snackbar("Hurray 😀", "Your profile was updated",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
        backgroundColor: primaryColor,
        colorText: defaultTextColor1
      );
      update();
      isUpdating = false;
    }
    else{
      print(response.body);
    }
  }
  updatePassengerProfile(String nameOnGCard,String nextOfKin,String nextOfKinNumber,String referral)async{
    const updateUrl = "https://taxinetghana.xyz/update_passenger_profile/";
    final myUrl = Uri.parse(updateUrl);
    http.Response response = await http.put(myUrl,
        headers: {
      "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "Token $uToken"
        },
        body: {
      "name_on_ghana_card": nameOnGCard,
          "next_of_kin":nextOfKin,
          "next_of_kin_number":nextOfKinNumber,
          "referral":referral
        },

    );
    if(response.statusCode == 200){
      Get.snackbar("Hurray 😀", "Your profile was updated",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
        backgroundColor: primaryColor,
        colorText: defaultTextColor1
      );
      update();
      isUpdating = false;
    }
    else{
      print(response.body);
    }
  }


}
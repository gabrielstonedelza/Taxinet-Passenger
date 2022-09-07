import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class RidesController extends GetxController{
  static RidesController get to => Get.find<RidesController>();
  late List allNotifications = [];
  late List passengersCompletedRides = [];
  bool isLoading = true;
  final storage = GetStorage();
  var username = "";
  String uToken = "";

  Future<void> getDriversRidesCompleted() async {
    // try {
    //   isLoading = true;
    //   const completedRides =
    //       "https://taxinetghana.xyz/passengers_requests_completed";
    //   var link = Uri.parse(completedRides);
    //   http.Response response = await http.get(link, headers: {
    //     "Content-Type": "application/x-www-form-urlencoded",
    //     "Authorization": "Token $uToken"
    //   });
    //   if (response.statusCode == 200) {
    //     var jsonData = jsonDecode(response.body);
    //     passengersCompletedRides.assignAll(jsonData);
    //
    //   } else {
    //     Get.snackbar("Sorry", "please check your internet connection");
    //   }
    // } catch (e) {
    //   Get.snackbar("Sorry",
    //       "something happened or please check your internet connection");
    // }
    // finally{
    //   isLoading = false;
    // }
  }
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
    getDriversRidesCompleted();
  }

}
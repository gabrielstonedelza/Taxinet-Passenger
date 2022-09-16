import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';

import 'login_controller.dart';

class ScheduleController extends GetxController{
  final myLoginController = MyLoginController.to;
  bool isLoading = true;
  final storage = GetStorage();
  var username = "";
  String uToken = "";
  List activeSchedules = [];
  List allSchedules = [];
  List detailScheduleItems = [];
  String assignedDriver = "";
  String assignedDriverSPic = "";
  String scheduleType = "";
  String schedulePriority = "";
  String rideType = "";
  String pickUpLocation = "";
  String dropOffLocation = "";
  String pickUpTime = "";
  String startDate = "";
  String status = "";
  String dateRequested = "";
  String timeRequested = "";
  String description = "";
  String price = "";
  String charge = "";
  late Timer _timer;


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
    // getActiveSchedules();
    // getAllSchedules();
    // _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
    //   getActiveSchedules();
    //   getAllSchedules();
    //   update();
    // });
  }
  Future<void> getDetailSchedule(String slug) async {
    try {
      isLoading = true;
      final walletUrl = "https://taxinetghana.xyz/ride_requests/$slug/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $uToken"
      });
      if (response.statusCode == 200) {
        final codeUnits = response.body;
        var jsonData = jsonDecode(codeUnits);
        assignedDriver = jsonData['get_assigned_driver_name'];
        assignedDriverSPic = jsonData['get_assigned_driver_profile_pic'];
        scheduleType = jsonData['schedule_type'];
        schedulePriority = jsonData['schedule_priority'];
        description = jsonData['schedule_description'];
        rideType = jsonData['ride_type'];
        pickUpLocation = jsonData['pickup_location'];
        dropOffLocation = jsonData['drop_off_location'];
        pickUpTime = jsonData['pick_up_time'];
        startDate = jsonData['start_date'];
        status = jsonData['status'];
        dateRequested = jsonData['date_scheduled'];
        timeRequested = jsonData['time_scheduled'];
        price = jsonData['price'];
        charge = jsonData['charge'];
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
//
  Future<void> getActiveSchedules(String token) async {
    try {
      isLoading = true;
      const walletUrl = "https://taxinetghana.xyz/get_my_active_schedules/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $token"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        activeSchedules.assignAll(jsonData);
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> getAllSchedules(String token) async {
    try {
      isLoading = true;
      const walletUrl = "https://taxinetghana.xyz/get_all_my_ride_requests/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $token"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allSchedules.assignAll(jsonData);
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }


}
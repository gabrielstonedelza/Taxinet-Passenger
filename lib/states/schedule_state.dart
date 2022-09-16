import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../passenger/home/passenger_home.dart';
import '../views/bottomnavigationbar.dart';

class ScheduleState extends ChangeNotifier{


  String _scheduleTitle = "";
  String _scheduleType = "";
  String _schedulePriority = "";
  String _rideType = "";
  String _pickupLocation = "";
  String _dropOffLocation = "";
  String _pickUpTime = "";
  String _pickUpDate = "";
  String _scheduleDescription = "";

//  getters

 String get scheduleTitle => _scheduleTitle;
 String get scheduleTypes => _scheduleType;
 String get schedulePriority => _schedulePriority;
 String get rideType => _rideType;
 String get pickUpLocation => _pickupLocation;
 String get dropOffLocation => _dropOffLocation;
 String get pickUpTime => _pickUpTime;
 String get pickUpDate => _pickUpDate;
 String get scheduleDescription => _scheduleDescription;

// setters

void setScheduleTitle(String title){
  _scheduleTitle = title;
  notifyListeners();
}

void setScheduleTypes(String types){
  _scheduleType = types;
  notifyListeners();
}

void setSchedulePriority(String priority){
  _schedulePriority = priority;
  notifyListeners();
}

void setRideType(String rideT){
  _rideType = rideT;
  notifyListeners();
}

void setPickUpLocation(String pickUp){
  _pickupLocation = pickUp;
  notifyListeners();
}

void setDropOffLocation(String dropOff){
  _dropOffLocation = dropOff;
  notifyListeners();
}

void setPickUpTime(String pTime){
  _pickUpTime = pTime;
  notifyListeners();
}

void setPickUpDate(String pDate){
  _pickUpDate = pDate;
  notifyListeners();
}

void setScheduleDescription(String description){
  _scheduleDescription = description;
  notifyListeners();
}

  scheduleRide(String token,String title,String sType,String sP,String description,String pLocation,String dLocation,String pTime,String sDate) async {
    const requestUrl = "https://taxinetghana.xyz/request_ride/new/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $token"
    }, body: {
      "schedule_title": title,
      "schedule_type": sType,
      "schedule_priority": sP,
      "schedule_description": description,
      "pickup_location": pLocation,
      "drop_off_location": dLocation,
      "pick_up_time": pTime,
      "start_date": sDate,
    });
    if (response.statusCode == 201) {

      Get.snackbar("Success 😀", "request sent.",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          colorText: defaultTextColor1);
    }
    else{
      if (kDebugMode) {
        print(response.body);
      }
      Get.snackbar("Sorry 😢", "something went wrong,please try again later.",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: defaultTextColor1);
    }
  }

}
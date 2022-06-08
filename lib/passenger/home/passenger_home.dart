import 'dart:async';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:taxinet/passenger/home/pages/notifications.dart';
import 'package:taxinet/passenger/home/pages/profile.dart';
import 'package:taxinet/passenger/home/pages/rides.dart';
import 'package:taxinet/passenger/home/ride/request_ride.dart';

import '../../controllers/notifications/localnotification_manager.dart';
import '../../states/app_state.dart';
import 'bidding_page.dart';
import 'driveronroute.dart';

class PassengerHome extends StatefulWidget {
  const PassengerHome({Key? key}) : super(key: key);

  @override
  State<PassengerHome> createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> with SingleTickerProviderStateMixin{
  TabController? _tabController;
  int selectedIndex = 0;

  onTabClicked(int index) {
    setState(() {
      selectedIndex = index;
      _tabController!.index = selectedIndex;
    });
  }
  final Completer<GoogleMapController> _mapController = Completer();
  late FocusNode destinationFocus;
  bool hasLocation = false;
  final storage = GetStorage();
  late String username = "";
  late String uToken = "";
  var items;
  late Timer _timer;
  final deMapController = DeMapController.to;
  late List triggeredNotifications = [];
  late List triggered = [];
  late List yourNotifications = [];
  late List notRead = [];
  late List allNotifications = [];
  late List allNots = [];
  bool isLoading = true;
  bool isRead = true;
  late String passengerPickUp = "";
  late String passengerPickUpPlaceId = "";

  String driver = "";

  Future<void> getAllTriggeredNotifications(String token) async {
    const url = "https://taxinetghana.xyz/user_triggerd_notifications/";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink, headers: {
      "Authorization": "Token $uToken"
    });
    if(response.statusCode == 200){
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      triggeredNotifications = json.decode(jsonData);
      triggered.assignAll(triggeredNotifications);
    }
  }

  Future<void> getAllUnReadNotifications(String token) async {
    const url = "https://taxinetghana.xyz/user_notifications/";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink, headers: {
      "Authorization": "Token $uToken"
    });
    if(response.statusCode == 200){

      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      yourNotifications = json.decode(jsonData);
      notRead.assignAll(yourNotifications);

    }
  }

  Future<void> getAllNotifications(String token) async {
    const url = "https://taxinetghana.xyz/notifications/";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink, headers: {
      "Authorization": "Token $uToken"
    });
    if(response.statusCode == 200){
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      allNotifications = json.decode(jsonData);
      allNots.assignAll(allNotifications);
    }
    setState(() {
      isLoading = false;
      allNotifications = allNotifications;
    });
  }

  unTriggerNotifications(int id)async{
    final requestUrl = "https://taxinetghana.xyz/user_read_notifications/$id/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    },body: {
      "notification_trigger": "Not Triggered",
    });
    if(response.statusCode == 200){

    }
  }
  updateReadNotification(int id)async{
    final requestUrl = "https://taxinetghana.xyz/user_read_notifications/$id/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    },body: {
      "read": "Read",
    });
    if(response.statusCode == 200){

    }
  }
  Future<void> fetchRideDetail(String rideId) async {
    final detailRideUrl = "https://taxinetghana.xyz/ride_requests/$rideId";
    final myLink = Uri.parse(detailRideUrl);
    http.Response response = await http.get(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    });
    if (response.statusCode == 200) {
      final codeUnits = response.body;
      var jsonData = jsonDecode(codeUnits);
      passengerPickUp = jsonData['pick_up'];
      passengerPickUpPlaceId = jsonData['passengers_pick_up_place_id'];

    } else {
      Get.snackbar("Sorry", "please check your internet connection");
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    destinationFocus = FocusNode();
    _tabController = TabController(length: 4, vsync: this);
    final appState = Provider.of<AppState>(context, listen: false);
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }

    appState.getPassengersSearchedDestinations(uToken);
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      appState.getPassengersSearchedDestinations(uToken);
    });

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      getAllTriggeredNotifications(uToken);
      getAllUnReadNotifications(uToken);
      for(var i in triggered){
        localNotificationManager.showAcceptedRideNotification(i['notification_title'],i['notification_message']);
        localNotificationManager.showRejectedRideNotification(i['notification_title'],i['notification_message']);
        localNotificationManager.showDriverArrivalNotification(i['notification_title'],i['notification_message']);
        localNotificationManager.showCompletedRideNotification(i['notification_title'],i['notification_message']);
        localNotificationManager.showBidCompleteNotification(i['notification_title'],i['notification_message']);
      }
      for(var i in notRead){
        if(i['notification_title'] == "Ride was accepted" && i['read'] == "Not Read"){
          Get.to(()=> BiddingPage(rideId:i['ride_id'],driver:i['notification_from'].toString()));
          updateReadNotification(i['id']);
          setState(() {
            driver = i['notification_from'].toString();
          });
          fetchRideDetail(i['ride_id']);
        }
        if(i['notification_title'] == "Bidding Accepted" && i['read'] == "Not Read"){
          Get.to(()=> DriverOnRoute(rideId:i['ride_id'],driver:i['notification_from'].toString(),pickUp:passengerPickUp,pickIpId:passengerPickUpPlaceId));
          updateReadNotification(i['id']);
        }
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      for(var e in triggered){
        unTriggerNotifications(e["id"]);
      }
    });
    localNotificationManager.setOnAcceptedRideNotificationReceive(onRideAcceptedNotification);
    localNotificationManager.setOnAcceptedRideNotificationClick(onRideAcceptedNotificationClick);
    localNotificationManager.setOnRejectedRideNotificationReceive(onRideRejectedNotification);
    localNotificationManager.setOnRejectedRideNotificationClick(onRideRejectedNotificationClick);
    localNotificationManager.setOnDriverArrivalNotificationReceive(onRideDriverArrivalNotification);
    localNotificationManager.setOnDriverArrivalNotificationClick(onRideDriverArrivalNotificationClick);
    localNotificationManager.setOnCompletedRideNotificationReceive(onRideCompletedNotification);
    localNotificationManager.setOnCompletedRideNotificationClick(onRideCompletedNotificationClick);
    localNotificationManager.setOnBidCompleteNotificationReceive(onBidCompletedNotification);
    localNotificationManager.setOnBidCompleteNotificationClick(onBidCompletedNotificationClick);
    super.initState();
  }
  onRideAcceptedNotification(ReceiveNotification notification){

  }

  onRideAcceptedNotificationClick(String payload){

  }

  onRideRejectedNotification(ReceiveNotification notification){

  }

  onRideRejectedNotificationClick(String payload){

  }

  onRideDriverArrivalNotification(ReceiveNotification notification){

  }

  onRideDriverArrivalNotificationClick(String payload){

  }

  onRideCompletedNotification(ReceiveNotification notification){

  }

  onRideCompletedNotificationClick(String payload){

  }

  onBidCompletedNotification(ReceiveNotification notification){

  }

  onBidCompletedNotificationClick(String payload){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          RequestRide(),
          Rides(),
          Notifications(),
          Profile()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time_sharp), label: "Rides"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showSelectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onTabClicked,
      ),
    );
  }
}

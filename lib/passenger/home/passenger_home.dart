import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:taxinet/passenger/home/passenger_map.dart';
import 'package:taxinet/passenger/home/ride/request_ride.dart';
import 'package:taxinet/views/mapview.dart';

import '../../constants/app_colors.dart';
import '../../controllers/login/login_controller.dart';
import '../../states/app_state.dart';
import '../../views/login/loginview.dart';
import 'package:http/http.dart' as http;

class PassengerHome extends StatefulWidget {
  const PassengerHome({Key? key}) : super(key: key);

  @override
  State<PassengerHome> createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  final storage = GetStorage();

  bool isFetching = false;
  bool hasInternet = false;
  late String uToken = "";
  late StreamSubscription internetSubscription;
  void _startFetching()async{
    setState(() {
      isFetching = true;
    });
    await Future.delayed(const Duration(seconds: 10));
    setState(() {
      isFetching = false;
    });
  }



  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _startFetching();
    internetSubscription = InternetConnectionChecker().onStatusChange.listen((status) {
      setState(() {
        hasInternet = status == InternetConnectionStatus.connected;
      });
    });
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    internetSubscription.cancel();
  }
  logoutUser() async {
    storage.remove("username");
    Get.offAll(() => const LoginView());
    const logoutUrl = "https://taxinetghana.xyz/auth/token/logout";
    final myLink = Uri.parse(logoutUrl);
    http.Response response = await http.post(myLink, headers: {
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    });

    if (response.statusCode == 200) {
      Get.snackbar("Success", "You were logged out",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: snackColor);
      storage.remove("username");
      storage.remove("userToken");
      storage.remove("user_type");
      Get.offAll(() => const LoginView());
    }
  }


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      backgroundColor: defaultTextColor2,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              // const Text("Taxinet",style: TextStyle(fontWeight: FontWeight.bold,color: primaryColor,fontSize: 20),),
              // Consumer<LoginController>(
              //   builder: (context,userData,child){
              //     return CircleAvatar(
              //       backgroundImage:
              //       NetworkImage(userData.userProfilePic),
              //     );
              //   }
              // ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: (){
                  Get.defaultDialog(
                      buttonColor: primaryColor,
                      title: "Confirm Logout",
                      middleText: "Are you sure you want to logout?",
                      confirm: RawMaterialButton(
                          shape: const StadiumBorder(),
                          fillColor: primaryColor,
                          onPressed: () {
                            logoutUser();
                            Get.back();
                          },
                          child: const Text(
                            "Yes",
                            style: TextStyle(color: Colors.white),
                          )),
                      cancel: RawMaterialButton(
                          shape: const StadiumBorder(),
                          fillColor: primaryColor,
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          )));
                },
              )
            ],
          )),
      body: appState.loading
          ?  SizedBox(
        height: double.infinity,
          child: Image.asset("assets/images/102267-location-loader.gif")) : Column(
        children: [
          const SizedBox(
            height: 20,
          ),

          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    Get.to(()=> const RequestRide());
                  },
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage(
                                "assets/images/86604-for-ride-share-app-car-animation.gif"),
                            fit: BoxFit.cover),
                        border: Border.all(),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(12))),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0, bottom: 8),
                      child: Text(
                        "Request Ride",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: defaultTextColor2,
                            fontSize: 20),
                      ),
                    ),
                    height: 200,
                    width: double.infinity,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("📍 Your Location",style: TextStyle(fontWeight: FontWeight.bold,color: primaryColor),),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Consumer(builder: (context,mapData,child){
              return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: const MapView()
              );
            }),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxinet/constants/app_colors.dart';

import 'package:taxinet/states/app_state.dart';
import 'package:get/get.dart';

class ConfirmDriver extends StatefulWidget {
  String driver;
  String distanceAway;
  String yourLocation;
  String token;
  String userId;
  String taxinetDriver;
  String drop_off_lat;
  String drop_off_lng;
  ConfirmDriver(
      {Key? key,
      required this.driver,
      required this.distanceAway,
      required this.yourLocation,
      required this.token,
      required this.userId,
      required this.taxinetDriver,
        required this.drop_off_lat,
        required this.drop_off_lng
      })
      : super(key: key);

  @override
  State<ConfirmDriver> createState() => _ConfirmDriverState(
      driver: this.driver,
      distanceAway: this.distanceAway,
      yourLocation: this.yourLocation,
      token: this.token,
      userId: this.userId,
      taxinetDriver: this.taxinetDriver,
    drop_off_lat:this.drop_off_lat,
    drop_off_lng:this.drop_off_lng
  );
}

class _ConfirmDriverState extends State<ConfirmDriver> {
  String driver;
  String distanceAway;
  String yourLocation;
  String token;
  String userId;
  String taxinetDriver;
  String drop_off_lat;
  String drop_off_lng;
  _ConfirmDriverState(
      {required this.driver,
      required this.distanceAway,
      required this.yourLocation,
      required this.token,
      required this.userId,
      required this.taxinetDriver,
        required this.drop_off_lat,
        required this.drop_off_lng
      });
  bool isPosting = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Confirm Ride",
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 30,
          ),
          Center(
            child: Image.asset(
              "assets/images/taxinet_cab.png",
              width: 250,
              height: 220,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    driver,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    child: Text(
                  "$distanceAway away",
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 18.0, right: 18.0, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(
                    child: Text(
                  "Your location is: ",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )),
                Expanded(
                    child: Text(
                  yourLocation,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/check.png",
                  width: 40,
                  height: 40,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 18.0),
                  child: Text(
                    "Driver is verified",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: RawMaterialButton(
              onPressed: () {
                appState.requestRide(
                  token,
                  int.parse(taxinetDriver),
                  appState.searchDestination,
                  appState.searchPlaceId,
                  appState.passDLat,
                  appState.passDLng
                );
                Get.snackbar(
                  "Hurray,🙂",
                  "You request is sent to driver,please wait for him to accept",
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                  duration: const Duration(seconds: 10),
                  backgroundColor: snackColor,
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 8,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Confirm",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: defaultTextColor2),
                ),
              ),
              fillColor: primaryColor,
              splashColor: defaultColor,
            ),
          )
        ],
      ),
    );
  }
}

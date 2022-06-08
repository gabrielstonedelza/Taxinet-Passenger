import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;


class MapController extends GetxController{
  static MapController get to => Get.find<MapController>();
  bool isLoading = true;
  String apiKey = "AIzaSyCNrE7Zbx75Y63T5PcPuio7-yIYDgMPSc8";
  final String baseUrl = "https://maps.googleapis.com/maps/api/directions/json";
  final String distanceApi = "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=Adum&origins=Buokrom&units=imperial&key=AIzaSyCNrE7Zbx75Y63T5PcPuio7-yIYDgMPSc8";
  late StreamSubscription<Position> streamSubscription;

  late GoogleMapController _mapController;
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  late double userLatitude = 0.0;
  late double userLongitude = 0.0;
  static LatLng? initialPosition;
  static LatLng? _lastPosition = initialPosition;
  final Set<Marker> markers = {};
  final Set<Polyline> polyLines = {};

  String myLocationName = "";

  late String uToken = "";
  late String dPlaceId = "";
  bool isSuccess = false;

  final storage = GetStorage();
  var username = "";


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserLocation();
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
  }


  Future<void> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await userLocation();
  }

  Future<void> userLocation() async {
    try{
      isLoading = true;
      streamSubscription = Geolocator.getPositionStream().listen((Position position) {
        userLatitude = position.latitude;
        userLongitude = position.longitude;
      });
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 20),forceAndroidLocationManager: true);
      List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);

      // initialPosition = LatLng(position.latitude, position.longitude);
      myLocationName = placemark[2].street!;
      locationController.text = myLocationName;
      var url = Uri.parse("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$myLocationName&inputtype=textquery&key=$apiKey");
      http.Response response = await http.get(url);

      if(response.statusCode == 200){
        var values = jsonDecode(response.body);
        dPlaceId = values['candidates'][0]['place_id'];
      }

    }
    catch(e){
      // Get.snackbar("Sorry 😢", "Your location couldn't be found",colorText: defaultTextColor1,snackPosition: SnackPosition.TOP,backgroundColor: primaryColor);
    }
    finally{
      isLoading = false;
      update();
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    streamSubscription.cancel();
  }
}
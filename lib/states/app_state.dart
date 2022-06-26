import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:get/get.dart';

import 'package:taxinet/models/places_search.dart';
import 'package:taxinet/passenger/home/ride/after_search.dart';

import '../constants/app_colors.dart';
import '../models/place.dart';

late double userLatitude = 0.0;
late double userLongitude = 0.0;
late StreamSubscription<Position> streamSubscription;
late String myLocationName = "";
late String dPlaceId = "";
TextEditingController locationController = TextEditingController();

class DeMapController extends GetxController {
  bool isLoading = true;
  static DeMapController get to => Get.find<DeMapController>();
  String apiKey = "AIzaSyCVohvMiszUGO-kXyXVAPA2S7eiG890K4I";
  late Timer _timer;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserLocation();
    // _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
    //   getCurrentLocation();
    // });
  }

  Future<Object> getUserLocation() async {
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

    return getCurrentLocation();
  }

  Stream<Position> getCurrentLocation() {
    late LocationSettings locationSettings;
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
                "Taxinet will still continue to receive your location even in the background",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      );
    }
    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      userLatitude = position.latitude;
      userLongitude = position.longitude;
    });
    userLocation();
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  Future<void> userLocation() async {
    try {
      isLoading = true;
      if(userLatitude != 0.0 && userLongitude != 0.0){
        List<Placemark> placemark =
        await placemarkFromCoordinates(userLatitude, userLongitude);
        // _initialPosition = LatLng(userLatitude, userLongitude);
        myLocationName = placemark[2].street!;
        locationController.text = myLocationName;
        var url = Uri.parse(
            "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$myLocationName&inputtype=textquery&key=$apiKey");
        http.Response response = await http.get(url);

        if (response.statusCode == 200) {
          var values = jsonDecode(response.body);
          dPlaceId = values['candidates'][0]['place_id'];
          // print(values['candidates'][0]['place_id']);
        }
      }

    } finally {
      isLoading = false;
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    streamSubscription.cancel();
  }
}

class AppState with ChangeNotifier {
  String apiKey = "AIzaSyCVohvMiszUGO-kXyXVAPA2S7eiG890K4I";
  final String baseUrl = "https://maps.googleapis.com/maps/api/directions/json";
  late double lat = userLatitude;
  late double lng = userLongitude;
  String dePassengersLat = userLatitude.toString();
  String dePassengersLng = userLongitude.toString();

  late GoogleMapController _mapController;
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  static final LatLng? _initialPosition = LatLng(userLatitude, userLongitude);
  static LatLng? _lastPosition = _initialPosition;
  final Set<Marker> _markers = {};
  final Set<Marker> _driverMarkers = {};
  final Set<Polyline> _polyLines = {};
  bool isFetching = true;
  late List driversCompletedRides = [];
  late List driversUpdatedLocations = [];
  late List passengersSearchedDestinations = [];
  List get searchedDestinations => passengersSearchedDestinations;
  List get driversUpdatesLocations => driversUpdatedLocations;
  String get yourApiKey => apiKey;
  String searchDestination = "";
  String searchPlaceId = "";
  bool hasDestination = false;
  // String myLocationName = "";
  String get getMyLocationName => myLocationName;
  late List driversLocationMinutes = [];
  List get allDriversLocationMinutes => driversLocationMinutes;

  String get sDestination => searchDestination;
  String get sPlaceId => searchPlaceId;
  bool get gotDestination => hasDestination;

  LatLng get initialPosition => _initialPosition!;
  LatLng get lastPosition => _lastPosition!;
  // GoogleMapsServices get googleMapServices => _googleMapsServices;
  GoogleMapController get mapController => _mapController;
  Set<Marker> get markers => _markers;
  Set<Marker> get driversMarkers => _driverMarkers;
  Set<Polyline> get polyLines => _polyLines;
  bool isLoading = true;
  bool get loading => isLoading;
  String distance = "";
  String deTime = "";
  String get routeDistance => distance;
  String get routeDuration => deTime;
  List<PlaceSearch> searchResults = [];
  StreamController<Places> selectedLocation =
      StreamController<Places>.broadcast();
  List get driversRides => driversCompletedRides;

  //ride details
  late String passenger = "";
  late String pickUp = "";
  late String dropOff = "";
  late double price = 0.0;
  late String dateRequested = "";
  late String passengerProfilePic = "";
  late String uToken = "";
  static LatLng? _lat;
  static LatLng? _lng;
  static LatLng? _dLocation;
  // late String dPlaceId = "";
  String get driversPlaceId => dPlaceId;

  //getters for detail ride
  String get passengerUsername => passenger;
  String get pickUpLocation => pickUp;
  String get dropOffLocation => dropOff;
  double get approvedPrice => price;
  String get dateRideRequested => dateRequested;
  String get passengerPic => passengerProfilePic;
  String get token => uToken;
  LatLng? get driverLatitude => _lat;
  LatLng? get driverLongitude => _lng;
  LatLng? get latlngDriver => _dLocation;
  bool isSuccess = false;
  bool get wasSuccess => isSuccess;
  late String passengersDropOffLat = "";
  late String passengersDropOffLng = "";
  String get passDLat => passengersDropOffLat;
  String get passDLng => passengersDropOffLng;

  // notifications
  late List triggeredNotifications = [];
  late List triggered = [];
  late List yourNotifications = [];
  late List notRead = [];
  late List allNotifications = [];
  late List allNots = [];
  List get triggeredNots => triggeredNotifications;
  List get yourNots => yourNotifications;
  List get allYourNots => allNotifications;

  AppState();

  Future<String> getRouteCoordinates(
      LatLng startLatLng, LatLng endLatLng) async {
    var uri = Uri.parse(
        "$baseUrl?origin=${startLatLng.latitude},${startLatLng.longitude}&destination=${endLatLng.latitude},${endLatLng.longitude}&key=$apiKey");

    http.Response response = await http.get(uri);
    Map values = jsonDecode(response.body);
    final points = values["routes"][0]["overview_polyline"]["points"];
    final legs = values['routes'][0]['legs'];

    if (legs != null) {
      distance = values['routes'][0]['legs'][0]['distance']['text'];
      deTime = values['routes'][0]['legs'][0]['duration']['text'];
    }
    return points;
  }

  void createRoute(String encodedPolyline) {
    _polyLines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 3,
        color: Colors.white,
        points: _convertToLatLng(_decodePoly(encodedPolyline))));
    notifyListeners();
  }

  void addMarker(LatLng location, String address) {
    _markers.add(Marker(
      markerId: MarkerId(_lastPosition.toString()),
      position: location,
      infoWindow: InfoWindow(title: address, snippet: "Go Here"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
    ));
    notifyListeners();
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = [];
    int index = 0;
    int len = poly.length;
    int c = 0;

    do {
      var shift = 0;
      int result = 0;
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) {
      lList[i] += lList[i - 2];
    }
    return lList;
  }

  void sendRequest(String intendedDestination) async {
    List<Location> locations = await locationFromAddress(intendedDestination);
    double latitude = locations[0].latitude;
    double longitude = locations[0].longitude;
    LatLng destination = LatLng(latitude, longitude);
    addMarker(destination, intendedDestination);
    String route = await getRouteCoordinates(_initialPosition!, destination);
    createRoute(route);
    notifyListeners();
  }

  //set for drivers location
  void sendDriversLocationRequest(
      String intendedDestination, LatLng driversLatLng) async {
    List<Location> locations = await locationFromAddress(intendedDestination);
    double latitude = locations[0].latitude;
    double longitude = locations[0].longitude;
    LatLng destination = LatLng(latitude, longitude);
    // addMarker(destination, intendedDestination);
    String route = await getRouteCoordinates(driversLatLng, destination);
    // createRoute(route);
    notifyListeners();
  }

  void onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    notifyListeners();
  }

  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  Future<List<PlaceSearch>> getAutoComplete(String searchItem) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchItem&types=geocode&components=country:gh&key=$apiKey";
    http.Response response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Places> getPlace(String placeId) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/details/json?key=$apiKey&place_id=$placeId";
    http.Response response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    passengersDropOffLat = jsonResult['geometry']['location']['lat'].toString();
    passengersDropOffLng = jsonResult['geometry']['location']['lng'].toString();
    // print(passengersDropOffLat);
    // print(passengersDropOffLng);
    return Places.fromJson(jsonResult);
  }

  searchPlaces(String search) async {
    searchResults = await getAutoComplete(search);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    selectedLocation.add(await getPlace(placeId));
    searchResults = [];
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    selectedLocation.close();
    notifyListeners();
    super.dispose();
  }

  late String fetchingDriversMsg = "";
  late String onlineDriver = "";

  Future<void> getDriversUpdatedLocations(String uToken) async {
    try {
      isLoading = true;
      const completedRides = "https://taxinetghana.xyz/get_drivers_location";
      var link = Uri.parse(completedRides);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $uToken"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        driversUpdatedLocations.assignAll(jsonData);
        for (var i in driversUpdatedLocations) {
          final destinationAddress = Uri.parse(
              "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=place_id:${i['place_id']}|&origins=$myLocationName&key=$apiKey");
          http.Response res = await http.get(destinationAddress);
          if (res.statusCode == 200) {
            var jsonResponse = await jsonDecode(res.body);
            onlineDriver = await jsonResponse['rows'][0]['elements'][0]['duration']['text'];
          } else {

          }
        }
        notifyListeners();
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchRideDetail(int id, String uToken) async {
    try {
      isLoading = true;
      final detailRideUrl = "https://taxinetghana.xyz/ride_requests/$id";
      final myLink = Uri.parse(detailRideUrl);
      http.Response response = await http.get(myLink, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $uToken"
      });
      if (response.statusCode == 200) {
        final codeUnits = response.body;
        var jsonData = jsonDecode(codeUnits);

        passenger = jsonData['passengers_username'];
        pickUp = jsonData['pick_up'];
        dropOff = jsonData['drop_off'];
        price = jsonData['price'];
        dateRequested = jsonData['date_requested'];
        passengerProfilePic = jsonData['get_driver_profile_pic'];
        notifyListeners();
      } else {
        Get.snackbar("Sorry", "please check your internet connection");
      }
    } catch (e) {
      Get.snackbar("Sorry", "please check your internet connection");
    } finally {
      isLoading = false;
    }
  }

  Future<void> getPassengersSearchedDestinations(String uToken) async {
    try {
      isLoading = true;
      const completedRides = "https://taxinetghana.xyz/get_destinations";
      var link = Uri.parse(completedRides);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $uToken"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        passengersSearchedDestinations.assignAll(jsonData);
        notifyListeners();
      } else {
        Get.snackbar("Sorry", "please check your internet connection");
      }
    } catch (e) {
      Get.snackbar("Sorry",
          "something happened or please check your internet connection");
    } finally {
      isLoading = false;
    }
  }

  addToSearchedLocations(
      String token, String destination, String placeId) async {
    const addLocationUrl = "https://taxinetghana.xyz/destination/new/";
    final myLink = Uri.parse(addLocationUrl);
    http.Response response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $token"
    }, body: {
      "searched_destination": destination,
      "place_id": placeId,
      "drop_off_lat": passengersDropOffLng,
      "drop_off_lng": passengersDropOffLat,
    });
    if (response.statusCode == 201) {
      // print("This is printing from sending location $passengersDropOffLng");
      // print("This is printing from sending location $passengersDropOffLat");
      //
    } else {
      print(response.body);
      // Get.snackbar("Oh no!,😔", "You are offline",
      //     colorText: Colors.white,
      //     snackPosition: SnackPosition.TOP,
      //     duration: const Duration(seconds: 5),
      //     backgroundColor: Colors.red);
    }
  }

  requestRide(
    String token,
    int driver,
    String dropOff,
    String passengerDropOffId,
      String dropOffLat,
      String dropOffLng,
  ) async {
    const addLocationUrl = "https://taxinetghana.xyz/request_ride/new/";
    final myLink = Uri.parse(addLocationUrl);
    http.Response response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $token"
    }, body: {
      "driver": driver.toString(),
      "pick_up": myLocationName,
      "drop_off": dropOff,
      "passengers_lat": userLatitude.toString(),
      "passengers_lng": userLongitude.toString(),
      "passengers_pick_up_place_id": dPlaceId,
      "passengers_drop_off_place_id": passengerDropOffId,
      "drop_off_lat": dropOffLat,
      "drop_off_lng": dropOffLng,
    });
    if (response.statusCode == 201) {
      isSuccess = true;
    } else {
      isSuccess = false;
    }
  }

  Future<void> getAllTriggeredNotifications(String token) async {
    const url = "https://taxinetghana.xyz/user_triggerd_notifications";
    var myLink = Uri.parse(url);
    final response =
        await http.get(myLink, headers: {"Authorization": "Token $uToken"});
    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      triggeredNotifications = json.decode(jsonData);
      triggered.assignAll(triggeredNotifications);
      notifyListeners();
    }
  }

  Future<void> getAllUnReadNotifications(String token) async {
    const url = "https://taxinetghana.xyz/user_notifications";
    var myLink = Uri.parse(url);
    final response =
        await http.get(myLink, headers: {"Authorization": "Token $uToken"});
    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      yourNotifications = json.decode(jsonData);
      notRead.assignAll(triggeredNotifications);
      notifyListeners();
    }
  }

  Future<void> getAllNotifications(String token) async {
    const url = "https://taxinetghana.xyz/notifications";
    var myLink = Uri.parse(url);
    final response =
        await http.get(myLink, headers: {"Authorization": "Token $uToken"});
    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      allNotifications = json.decode(jsonData);
      allNots.assignAll(allNotifications);
      notifyListeners();
    }
  }

  unTriggerNotifications(int id) async {
    final requestUrl = "https://fnetghana.xyz/read_notification/$id/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    }, body: {
      "notification_trigger": "Not Triggered",
    });
    if (response.statusCode == 200) {}
  }

  late List allBids = [];

  Future<void> getBids(String rideId, String token) async {
    try {
      isLoading = true;
      final completedRides = "https://taxinetghana.xyz/all_bids/$rideId/";
      var link = Uri.parse(completedRides);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $token"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allBids.assignAll(jsonData);
        notifyListeners();
      }
    } catch (e) {
    } finally {
      isLoading = false;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../requests/googlemap_requests.dart';

class AppState with ChangeNotifier {
  static const apiKey = "AIzaSyB47pcLuY-k7T1fDn0aJiA7K8UHV9CWIWY";
  final String baseUrl = "https://maps.googleapis.com/maps/api/directions/json";


  late GoogleMapController _mapController;
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  static LatLng? _initialPosition;
  static LatLng? _lastPosition = _initialPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  final GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  Duration duration = Duration();
  LatLng get initialPosition => _initialPosition!;
  LatLng get lastPosition => _lastPosition!;
  GoogleMapsServices get googleMapServices => _googleMapsServices;
  GoogleMapController get mapController => _mapController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polyLines => _polyLines;
  bool isLoading = true;
  bool get loading => isLoading;
  String distance = "";
  String deTime = "";
  String get routeDistance => distance;
  String get routeDuration => deTime;


  AppState() {
    _getUserLocation();
  }

  Future<String> getRouteCoordinates(LatLng startLatLng,LatLng endLatLng)async{
    var uri = Uri.parse("$baseUrl?origin=${startLatLng.latitude},${startLatLng.longitude}&destination=${endLatLng.latitude},${endLatLng.longitude}&key=$apiKey");

    http.Response response = await http.get(uri);
    Map values = jsonDecode(response.body);
    print(response.body);
    final points = values["routes"][0]["overview_polyline"]["points"];
    final legs = values['routes'][0]['legs'];

    if(legs != null){

      distance = values['routes'][0]['legs'][0]['distance']['text'];
      deTime = values['routes'][0]['legs'][0]['duration']['text'];
    }
    return points;
  }

  Future<void> _getUserLocation() async {
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
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await userLocation();
  }

  Future<void> userLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,timeLimit: const Duration(seconds: 10));
    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemark);

    _initialPosition = LatLng(position.latitude, position.longitude);
    locationController.text = placemark[2].street!;
    isLoading = false;
    notifyListeners();
  }

  void createRoute(String encodedPolyline) {
    _polyLines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 5,
        color: Colors.black,
        points: _convertToLatLng(_decodePoly(encodedPolyline))));
    notifyListeners();
  }

  void addMarker(LatLng location, String address) {
    _markers.add(Marker(
        markerId: MarkerId(_lastPosition.toString()),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "Go Here"),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueMagenta),
    )
    );
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
    var lList =[];
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
    print(lList.toString());
    return lList;
  }

  void sendRequest(String intendedDestination) async {
    List<Location> locations = await locationFromAddress(intendedDestination);
    double latitude = locations[0].latitude;
    double longitude = locations[0].longitude;
    LatLng destination = LatLng(latitude, longitude);
    addMarker(destination, intendedDestination);
    String route = await getRouteCoordinates(
        _initialPosition!, destination);
    createRoute(route);
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

  Future<double> getPositionBetweenRoutes(LatLng startLatLng,LatLng endLatLng)async{
    final meters = Geolocator.distanceBetween(startLatLng.latitude, startLatLng.longitude, endLatLng.latitude, endLatLng.longitude);

    return meters / 500;
  }

  Future<Placemark> getAddressFromCoordinates(LatLng position)async{
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    return placemarks.first;
  }
}

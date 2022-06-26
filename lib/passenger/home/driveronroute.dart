import 'dart:async';
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../states/app_state.dart';

class DriverOnRoute extends StatefulWidget {
  String rideId;
  String driver;
  String driversLat;
  String driversLng;
  String passengers_pickup;
  String pick_up_place_id;
  DriverOnRoute({Key? key,required this.rideId,required this.driver,required this.driversLat,required this.driversLng,required this.passengers_pickup,required this.pick_up_place_id}) : super(key: key);

  @override
  State<DriverOnRoute> createState() => _DriverOnRouteState(rideId:this.rideId,driver:this.driver,driversLat:this.driversLat,driversLng:this.driversLng,passengers_pickup:this.passengers_pickup,pick_up_place_id:this.pick_up_place_id);
}

class _DriverOnRouteState extends State<DriverOnRoute> {
  String rideId;
  String driver;
  String driversLat;
  String driversLng;
  String passengers_pickup;
  String pick_up_place_id;
  late Timer _timer;

  _DriverOnRouteState({required this.rideId,required this.driver,required this.driversLat,required this.driversLng,required this.passengers_pickup,required this.pick_up_place_id});
  final Completer<GoogleMapController> _mapController = Completer();
  var uToken = "";
  final storage = GetStorage();
  var username = "";
  late List driversLocationDetails = [];
  final deMapController = DeMapController.to;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  List<LatLng> polylineCoordinates = [];
  void setCustomMarkerIcon()async{
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/cab_for_map.png").then((icon){
      sourceIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/location-pin_1.png",).then((icon){
      destinationIcon = icon;
    });
  }
  void getPolyPoints(double passengersLat,double passengersLng) async{
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCVohvMiszUGO-kXyXVAPA2S7eiG890K4I",
      PointLatLng(double.parse(driversLat), double.parse(driversLng)),
      PointLatLng(passengersLat, passengersLng),
    );

    if(result.points.isNotEmpty){
      for (var point in result.points) {
        polylineCoordinates.add(
            LatLng(point.latitude,point.longitude)
        );
      }
      setState(() {});
    }
  }


  Future<void> getDriverLocation()async{
    final url = "https://taxinetghana.xyz/get_driver_location/$driver";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink, headers: {
      "Authorization": "Token $uToken"
    });
    if(response.statusCode == 200){
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      var results = json.decode(jsonData);
      driversLocationDetails.assignAll(results);
      for(var i in driversLocationDetails){
        setState(() {
          driversLat = i['drivers_lat'];
          driversLng = i['drivers_lng'];
        });
      }
    }
    else{
      print(response.body);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    deMapController.getCurrentLocation().listen((position) {
      centerScreen(position);
    });
    final appState = Provider.of<AppState>(context, listen: false);
    setCustomMarkerIcon();
    getPolyPoints(appState.lat,appState.lng);
    appState.sendDriversLocationRequest(passengers_pickup,LatLng(double.parse(driversLat), double.parse(driversLng)));
    appState.setSelectedLocation(pick_up_place_id);
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      getDriverLocation();
    });
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      appState.sendDriversLocationRequest(passengers_pickup,LatLng(double.parse(driversLat), double.parse(driversLng)));
      appState.setSelectedLocation(pick_up_place_id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AppState>(builder: (context,appState,child){
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(double.parse(driversLat),double.parse(driversLng)), zoom: 15.5),
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
                controller.setMapStyle(Utils.mapStyle);
              },
              myLocationEnabled: true,
              trafficEnabled: true,
              compassEnabled: true,
              markers:{
                Marker(
                  markerId: const MarkerId("Source"),
                  position: LatLng(double.parse(driversLat), double.parse(driversLng)),
                  icon: sourceIcon,
                ),
                Marker(
                    markerId: const MarkerId("Destination"),
                    position: LatLng(appState.lat, appState.lng),
                    icon: destinationIcon
                ),
              },
              onCameraMove: appState.onCameraMove,
              polylines:  {
                Polyline(
                    polylineId:const PolylineId("route"),
                    points: polylineCoordinates,
                    color: Colors.green,
                    width: 5
                ),
              },
            ),
          );
        },)
      ),
    );
  }
  Future<void> centerScreen(Position position)async{
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(double.parse(driversLat),double.parse(driversLng)),zoom: 15.5,bearing: position.heading )));
  }
}

class Utils {
  static String mapStyle = ''' 
  [
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#1d2c4d"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8ec3b9"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1a3646"
      }
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#4b6878"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#64779e"
      }
    ]
  },
  {
    "featureType": "administrative.province",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#4b6878"
      }
    ]
  },
  {
    "featureType": "landscape.man_made",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#334e87"
      }
    ]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#023e58"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#283d6a"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#6f9ba5"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1d2c4d"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#023e58"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#3C7680"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#304a7d"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#98a5be"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1d2c4d"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#2c6675"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#255763"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#b0d5ce"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#023e58"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#98a5be"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1d2c4d"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#283d6a"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#3a4762"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#0e1626"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#4e6d70"
      }
    ]
  }
]
  ''';
}
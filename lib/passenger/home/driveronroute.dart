import 'dart:async';
import 'dart:convert';
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
  String pickUp;
  String pickIpId;
  DriverOnRoute({Key? key,required this.rideId,required this.driver,required this.pickUp,required this.pickIpId}) : super(key: key);

  @override
  State<DriverOnRoute> createState() => _DriverOnRouteState(rideId:this.rideId,driver:this.driver,pickUp:this.pickUp,pickIpId:this.pickIpId);
}

class _DriverOnRouteState extends State<DriverOnRoute> {
  String rideId;
  String driver;
  String pickUp;
  String pickIpId;
  late Timer _timer;

  _DriverOnRouteState({required this.rideId,required this.driver,required this.pickUp,required this.pickIpId});
  final Completer<GoogleMapController> _mapController = Completer();
  var uToken = "";
  final storage = GetStorage();
  var username = "";
  late List driversLocationDetails = [];
  late double driversLat = 0.0;
  late double driversLng = 0.0;
  late String driversLocationPlaceId = "";
  late String driversLocationName = "";
  final deMapController = DeMapController.to;


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
          driversLocationPlaceId = i['place_id'];
          driversLocationName = i['location_name'];
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
    // appState.sendRequest(pickUp);
    appState.sendRequest(driversLocationName);
    appState.setSelectedLocation(driversLocationPlaceId);
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      getDriverLocation();
    });
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      appState.sendRequest(driversLocationName);
      appState.setSelectedLocation(driversLocationPlaceId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
                target: appState.initialPosition, zoom: 11.5),
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
            markers: appState.markers,
            onCameraMove: appState.onCameraMove,
            polylines: appState.polyLines,
          ),
        ),
      ),
    );
  }
  Future<void> centerScreen(Position position)async{
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(driversLat,driversLng),zoom: 11.5,bearing: position.heading )));
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
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../models/place.dart';
import '../../../states/app_state.dart';

class AfterSearch extends StatefulWidget {
  const AfterSearch({Key? key}) : super(key: key);

  @override
  State<AfterSearch> createState() => _AfterSearchState();
}

class _AfterSearchState extends State<AfterSearch> {
  final storage = GetStorage();
  late String username = "";
  late String uToken = "";
  late String userId = "";
  final Completer<GoogleMapController> _mapController = Completer();
  final Set<Marker> _markers = {};
  StreamSubscription<Places>? locationSubscription;
  bool isLoading = true;

  bool isFinished = false;
  var itemPlaceid;
  late String apiKey = "";
  late LatLng initialPosition;
  late Timer _timer;
  var items;
  var minutesItems;
  final deMapController = DeMapController.to;

  bool isPosting = false;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    appState.sendRequest(appState.sDestination);
    appState.setSelectedLocation(appState.sPlaceId);
    setState(() {
      apiKey = appState.apiKey;
      initialPosition = appState.initialPosition;
    });
    locationSubscription =
        appState.selectedLocation.stream.listen((place) async {
      if (place != null) {
        goToPlace(place);
      }
      Timer(const Duration(seconds: 10),
          () async => await locationSubscription?.cancel());
    });
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    if (storage.read("user_id") != null) {
      userId = storage.read("user_id");
    }
    deMapController.getCurrentLocation().listen((position) {
      centerScreen(position);
    });

    _timer = Timer.periodic(const Duration(seconds:5), (timer) {
      appState.getDriversUpdatedLocations(uToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultTextColor2,
        elevation: 0,
        leading: IconButton(
          onPressed: () async {
            appState.polyLines.clear();
            appState.markers.clear();
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: defaultTextColor1,
          ),
        ),
        title: Text(
          "${appState.routeDuration}, ${appState.routeDistance}",
          style:
              const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
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
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 12),
                      child: Center(
                        child: Text(
                            "Available Drivers (${appState.driversUpdatedLocations.length})"),
                      ),
                    ),
                    SizedBox(
                      height: 350,
                      child: appState.driversUpdatedLocations.isEmpty ? Text(appState.fetchingDriversMsg) :ListView.builder(
                              itemCount:
                                  appState.driversUpdatedLocations.isNotEmpty
                                      ? appState.driversUpdatedLocations.length
                                      : 0,
                              itemBuilder: (context, index) {
                                items = appState.driversUpdatedLocations[index];
                                return Card(
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        Expanded(
                                            child: Image.asset(
                                          "assets/images/taxinet_cab.png",
                                          width: 20,
                                          height: 20,
                                        )),
                                        Expanded(
                                          child: Text(
                                            "${items['drivers_taxinet_number']}",
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15),
                                          ),
                                        ),
                                        appState.driversUpdatedLocations[index] != null ? Expanded(
                                            child: Text(
                                          "${appState.allDriversLocationMinutes[index]} away",
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 13),
                                        )) : const Expanded(
                                          child: Text(""),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      showMaterialModalBottomSheet(
                                        context: context,
                                        builder: (context) =>
                                            SingleChildScrollView(
                                          controller:
                                              ModalScrollController.of(context),
                                          child: SizedBox(
                                            height: 300,
                                            child: Column(
                                              children: [
                                                Center(
                                                  child: Image.asset(
                                                    "assets/images/taxinet_cab.png",
                                                    width: 150,
                                                    height: 120,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 18.0,
                                                          right: 18.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "${appState.driversUpdatesLocations[index]['drivers_taxinet_number']}",
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: Text(
                                                        "${appState.allDriversLocationMinutes[index]} away",
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 18.0,
                                                          right: 18.0,
                                                          top: 10,
                                                          bottom: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const Expanded(
                                                          child: Text(
                                                        "Your location is: ",
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                      Expanded(
                                                          child: Text(
                                                        appState
                                                            .getMyLocationName,
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                            !appState.wasSuccess ? RawMaterialButton(
                                                  onPressed: () {
                                                    appState.requestRide(
                                                        uToken,
                                                        items['driver'],
                                                        userId,
                                                        appState.myLocationName,
                                                        appState.sDestination,
                                                        appState.dPlaceId,
                                                        appState.searchPlaceId,
                                                        appState.routeDistance,
                                                        appState.routeDuration,
                                                    );
                                                    if (appState.wasSuccess) {
                                                      Get.back();
                                                    }
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  elevation: 8,
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                      "Confirm",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                          color:
                                                              defaultTextColor2),
                                                    ),
                                                  ),
                                                  fillColor: primaryColor,
                                                  splashColor: defaultColor,
                                                ) : Container()
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> goToPlace(Places place) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
            LatLng(place.geometry.location.lat, place.geometry.location.lng),
        zoom: 11.5)));
  }
  Future<void> centerScreen(Position position)async{
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude,position.longitude),zoom: 11.5,bearing: position.heading )));
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
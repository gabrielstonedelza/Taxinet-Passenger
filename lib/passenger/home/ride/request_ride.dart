import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxinet/passenger/home/ride/after_search.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:taxinet/passenger/home/search_location.dart';

import '../../../constants/app_colors.dart';

import '../../../g_controller/userController.dart';
import '../../../states/app_state.dart';
import '../../../views/login/loginview.dart';
import 'package:http/http.dart' as http;


class RequestRide extends StatefulWidget {
  const RequestRide({Key? key}) : super(key: key);

  @override
  State<RequestRide> createState() => _RequestRideState();
}

class _RequestRideState extends State<RequestRide> {
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
  final uController = Get.put(UserController());

  String driver = "";

  @override
  void initState() {
    // TODO: implement initState
    destinationFocus = FocusNode();
    final appState = Provider.of<AppState>(context, listen: false);

    deMapController.getCurrentLocation().listen((position) {
      centerScreen(position);
    });
    super.initState();
  }


  //
  // logoutUser() async {
  //   storage.remove("username");
  //   Get.offAll(() => const LoginView());
  //   const logoutUrl = "https://taxinetghana.xyz/auth/token/logout";
  //   final myLink = Uri.parse(logoutUrl);
  //   http.Response response = await http.post(myLink, headers: {
  //     'Accept': 'application/json',
  //     "Authorization": "Token $uToken"
  //   });
  //
  //   if (response.statusCode == 200) {
  //     Get.snackbar("Success", "You were logged out",
  //         colorText: Colors.white,
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: snackColor);
  //     storage.remove("username");
  //     storage.remove("userToken");
  //     storage.remove("user_type");
  //     Get.offAll(() => const LoginView());
  //   }
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: uController.referral != "" ? ListView(
          children: [
            Consumer<AppState>(builder: (context,appState,child){
              return SizedBox(
                height: MediaQuery.of(context).size.height / 1.8,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(appState.lat,appState.lng), zoom: 14.0),
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
              );
            },),
            Card(
              elevation: 5,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onTap: () {
                          Get.to(() => const SearchLocation());
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                            fillColor: Colors.grey[100],
                            prefixIcon: const Icon(
                              Icons.search,
                              color: defaultTextColor2,
                            ),
                            hintText: "Where to?",
                            hintStyle: const TextStyle(
                                color: defaultTextColor2,
                                fontWeight: FontWeight.bold),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            )),
                        keyboardType: TextInputType.none,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                     Consumer<AppState>(builder: (context,appState,child){
                       return Container(
                         decoration: const BoxDecoration(),
                         height: 300,
                         child: ListView.builder(
                             itemCount: appState.searchedDestinations != null
                                 ? appState.searchedDestinations.length
                                 : 0,
                             itemBuilder: (context, index) {
                               items = appState.searchedDestinations[index];
                               return ListTile(
                                 title: Row(
                                   children: [
                                     const Icon(
                                       Icons.location_on_outlined,
                                       color: Colors.black87,
                                     ),
                                     const SizedBox(
                                       width: 10,
                                     ),
                                     Expanded(
                                       child: RichText(
                                         text: TextSpan(
                                           text: items['searched_destination'],
                                           style: DefaultTextStyle.of(context).style,
                                         ),
                                       ),
                                     ),

                                   ],
                                 ),
                                 subtitle: const Divider(),
                                 onTap: () {

                                   appState.searchDestination =
                                   appState.searchedDestinations[index]
                                   ['searched_destination'];
                                   appState.searchPlaceId =
                                   appState.searchedDestinations[index]
                                   ['place_id'];
                                   appState.hasDestination = hasLocation;
                                   Get.to(() => AfterSearch(drop_off_lat:items['drop_off_lat'],drop_off_lng:items['drop_off_lng']));
                                 },
                               );
                             }),
                       );
                     },),
                  ],
                ),
              ),
            )
          ],
        ) : const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text("Sorry 😢,you need to verify your account in your profile by providing a valid referral from Taxinet."),
          ),
        ),
      ),
    );
  }
  Future<void> centerScreen(Position position)async{
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude,position.longitude),zoom: 15,bearing: position.heading )));
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
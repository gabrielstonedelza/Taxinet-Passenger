import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxinet/passenger/home/ride/after_search.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:taxinet/passenger/home/search_location.dart';

import '../../../constants/app_colors.dart';
import '../../../controllers/login/login_controller.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    destinationFocus = FocusNode();
    final appState = Provider.of<AppState>(context, listen: false);
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }

    appState.getPassengersSearchedDestinations(uToken);
    super.initState();
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
    final loginController = Provider.of<LoginController>(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: appState.initialPosition, zoom: 14.0),
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapType: MapType.normal,
                      onMapCreated: (GoogleMapController controller) {
                        _mapController.complete(controller);
                      },
                      myLocationEnabled: true,
                      compassEnabled: true,
                      markers: appState.markers,
                      onCameraMove: appState.onCameraMove,
                      polylines: appState.polyLines,
                    ),
                  ),
                ),
                Positioned(
                    top: 20,
                    left: 10,
                    child: IconButton(
                      icon: Image.asset(
                        "assets/images/grid.png",
                        width: 40,
                        height: 40,
                      ),
                      onPressed: () {
                        showMaterialModalBottomSheet(
                          context: context,
                          builder: (context) => SingleChildScrollView(
                            controller: ModalScrollController.of(context),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 1.2,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          Get.back();
                                        },
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Consumer<LoginController>(
                                            builder: (context, userData, child) {
                                          return Text(userData.username,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),);
                                        }),
                                        Consumer<LoginController>(
                                            builder: (context, userData, child) {
                                          return CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                userData.userProfilePic),
                                            radius: 30,
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              children: const [
                                                Icon(Icons.info_outlined),
                                                SizedBox(height: 10,),
                                                Text("Info")
                                              ],
                                              mainAxisAlignment: MainAxisAlignment.center,
                                            ),
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: const BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                              )
                                            ),
                                          ),
                                        ),
                                        
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10.0),
                                            child: Container(
                                              child: Column(
                                                children: const [
                                                  Icon(Icons.access_time_sharp),
                                                  SizedBox(height: 10,),
                                                  Text("Trips")
                                                ],
                                                mainAxisAlignment: MainAxisAlignment.center,
                                              ),
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius: const BorderRadius.only(
                                                    topRight: Radius.circular(10),
                                                    topLeft: Radius.circular(10),
                                                    bottomLeft: Radius.circular(10),
                                                    bottomRight: Radius.circular(10),
                                                  )
                                              ),
                                            ),
                                          ),
                                        ),

                                        Expanded(

                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10.0),
                                            child: Container(
                                              child: Column(
                                                children: const [
                                                  Icon(Icons.notifications_outlined),
                                                  SizedBox(height: 10,),
                                                  Text("Notifications")
                                                ],
                                                mainAxisAlignment: MainAxisAlignment.center,
                                              ),
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius: const BorderRadius.only(
                                                    topRight: Radius.circular(10),
                                                    topLeft: Radius.circular(10),
                                                    bottomLeft: Radius.circular(10),
                                                    bottomRight: Radius.circular(10),
                                                  )
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20,),
                                  const Divider(height: 10,),
                                  const SizedBox(height: 20,),
                                  ListTile(
                                    leading: Image.asset("assets/images/settings.png",width: 20,height: 20,),
                                    title: const Text("Settings"),
                                    subtitle: const Text("Edit profile"),
                                    onTap: (){},
                                  ),
                                  const SizedBox(height: 20,),
                                  ListTile(
                                    leading: const Icon(Icons.logout),
                                    title: const Text("Logout"),
                                    onTap: (){
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
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ))
              ],
            ),
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
                    appState.loading
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(
                              strokeWidth: 6,
                              backgroundColor: primaryColor,
                            ),
                          )
                        : Container(
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
                                        // Text(
                                        //   items['searched_destination'],
                                        //   style: const TextStyle(
                                        //       color: Colors.black87),
                                        // ),
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
                                      Get.to(() => const AfterSearch());
                                    },
                                  );
                                }),
                          ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: defaultTextColor2,
        onPressed: () async {
          setState(() {
            hasLocation = false;
          });
          appState.polyLines.clear();
          appState.markers.clear();
          final GoogleMapController controller = await _mapController.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: appState.initialPosition, zoom: 11)));
        },
        child: const Icon(
          Icons.center_focus_strong,
          color: primaryColor,
        ),
      ),
    );
  }
}

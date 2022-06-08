import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxinet/passenger/home/ride/after_search.dart';

import '../../constants/app_colors.dart';
import '../../states/app_state.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({Key? key}) : super(key: key);

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  final Completer<GoogleMapController> _mapController = Completer();
  late FocusNode destinationFocus;
  bool hasLocation = false;
  final storage = GetStorage();
  late String uToken = "";
  var items;
  bool isSearching = false;
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    destinationFocus = FocusNode();
    final appState = Provider.of<AppState>(context, listen: false);
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    appState.getPassengersSearchedDestinations(uToken);
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      appState.getPassengersSearchedDestinations(uToken);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: (){
                      // Get.back();
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 20,),
                  const Text("Enter destination",style: TextStyle(fontWeight: FontWeight.bold),)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0,right: 18),
              child: Row(
                children: [
                  Image.asset("assets/images/pin.png",width: 30,height: 30,),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: TextFormField(
                        controller: appState.locationController,
                        readOnly: true,
                        // focusNode: destinationFocus,
                        decoration: InputDecoration(
                            fillColor: Colors.grey[100],
                            labelText: "Your Location",
                            labelStyle: const TextStyle(color: defaultTextColor2,fontWeight: FontWeight.bold),
                            focusColor: primaryColor,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 18.0,right: 18),
              child: Row(
                children: [
                  Image.asset("assets/images/location-pin.png",width: 30,height: 30,),
                  Expanded(
                    child: Focus(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onChanged: (value) {
                              appState.searchPlaces(value);
                            },
                            controller: appState.destinationController,
                            cursorRadius: const Radius.elliptical(2, 2),
                            cursorWidth: 2,
                            focusNode: destinationFocus,
                            decoration: InputDecoration(
                                fillColor: Colors.grey[100],
                                labelText: "Where to?",
                                labelStyle: const TextStyle(color: defaultTextColor2,fontWeight: FontWeight.bold),
                                focusColor: primaryColor,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: primaryColor, width: 2),
                                    borderRadius: BorderRadius.circular(12)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12))
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        onFocusChange: (hasFocus) async{
                          if(hasFocus) {
                            // do stuff
                            Get.to(() => const SearchLocation());
                            setState(() {
                              hasLocation = false;
                              isSearching = true;
                            });
                            appState.polyLines.clear();
                            appState.markers.clear();
                            final GoogleMapController controller = await _mapController.future;
                            controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                                target: appState.initialPosition,
                                zoom: 11)));
                          }
                          else{
                            setState(() {
                              isSearching = false;
                            });
                          }
                        }
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
           !isSearching ? SizedBox(
              height: 400,
              child: ListView.builder(
                  itemCount:appState.searchedDestinations != null ? appState.searchedDestinations.length : 0,
                  itemBuilder: (context, index) {
                    items = appState.searchedDestinations[index];
                    return ListTile(
                      title: Row(
                        children: [
                          const Icon(Icons.location_on_outlined,color: Colors.black87,),
                          const SizedBox(width: 10,),
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
                        appState.searchDestination = appState.searchedDestinations[index]['searched_destination'];
                        appState.searchPlaceId = appState.searchedDestinations[index]['place_id'];
                        appState.hasDestination = hasLocation;
                        Get.to(() => const AfterSearch());
                      },
                    );
                  }),
            ) : Container(),
            if (appState.searchResults != null &&
                appState.searchResults.isNotEmpty)
              SizedBox(
                height: 300,
                child: ListView.builder(
                    itemCount: appState.searchResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(
                          children: [
                            const Icon(Icons.location_on_outlined,color: Colors.black87,),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: appState.searchResults[index].description,
                                  style: DefaultTextStyle.of(context).style,
                                ),
                              ),
                            ),
                            // Text(
                            //   appState.searchResults[index].description,
                            //   style: const TextStyle(color: Colors.black87),
                            // ),
                          ],
                        ),
                        subtitle: const Divider(),
                        onTap: () {
                          setState(() {
                            hasLocation = true;
                            appState.destinationController.text = "";
                          });
                          FocusScope.of(context).unfocus();
                          appState.searchDestination = appState.searchResults[index].description;
                          appState.searchPlaceId = appState.searchResults[index].placeId;
                          appState.hasDestination = hasLocation;
                          appState.addToSearchedLocations(uToken,appState.searchResults[index].description,appState.searchResults[index].placeId);
                          Get.to(() => const AfterSearch());
                        },
                      );
                    }),
              ),
          ],
        ),
      ),
    );
  }
}

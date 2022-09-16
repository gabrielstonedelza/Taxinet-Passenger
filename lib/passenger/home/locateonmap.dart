import "package:flutter/material.dart";
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:get/get.dart";
import '../../constants/app_colors.dart';
import '../../mapscontroller.dart';

class LocateOnMap extends StatefulWidget {
  String dropOff;
  LocateOnMap({Key? key,required this.dropOff}) : super(key: key);

  @override
  State<LocateOnMap> createState() => _LocateOnMapState(dropOff:this.dropOff);
}

class _LocateOnMapState extends State<LocateOnMap> {

  String dropOff;_LocateOnMapState({required this.dropOff});
  late GoogleMapController mapController;
  late String pickedDropOffName = "nothing";

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  final MapController _mapController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tap on map to pick location",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color:Colors.black)),
          backgroundColor:Colors.transparent,
          elevation:0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon:const Icon(Icons.arrow_back,color:defaultTextColor2)
          ),
          actions: [
            pickedDropOffName != "nothing" ?  RawMaterialButton(
              onPressed: () {
                _mapController.setDropOffLocation(pickedDropOffName);
                // _mapController.dropOffLocation.text = pickedDropOffName;
                Get.back();
              },
              // child: const Text("Send"),
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius
                      .circular(
                      8)),
              elevation: 8,
              fillColor:
              Colors.green,
              splashColor:
              defaultColor,
              child: const Text(
                "Okay",
                style: TextStyle(
                    fontWeight:
                    FontWeight
                        .bold,
                    fontSize: 15,
                    color:
                    defaultTextColor1),
              ),
            ) : Container()
          ],
        ),
        body: Stack(
          children: [
            GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(_mapController.userLatitude,_mapController.userLongitude),
                  zoom: 15.0,
                ),
                myLocationButtonEnabled: true,
                onTap: (latLng)async {

                  List<Placemark> placemark = await placemarkFromCoordinates(latLng.latitude,latLng.longitude);

                  setState(() {
                    pickedDropOffName = placemark[2].street!;
                  });
                }
            ),
            Positioned(
              top: 0,
              left: 0,
              right:0,
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32)),
                child: Container(
                  height: 70,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: primaryColor,
                        // borderRadius: BorderRadius.circular(30),
                        boxShadow: [BoxShadow(offset:Offset(0,4), blurRadius:4,color:Colors.black26)]
                    ),
                    child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left:10.0,right:10),
                          child: Text("You have picked $pickedDropOffName",style: const TextStyle(fontWeight: FontWeight.bold)),
                        )
                    )
                ),
              )
            )
          ],
        ),
      )
    );
  }
}

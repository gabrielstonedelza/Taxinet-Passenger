import "package:flutter/material.dart";
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:get/get.dart";
import '../../constants/app_colors.dart';
import '../../mapscontroller.dart';

class LocatePickUpOnMap extends StatefulWidget {
  String pickUp;
  LocatePickUpOnMap({Key? key,required this.pickUp}) : super(key: key);

  @override
  State<LocatePickUpOnMap> createState() => _LocatePickUpOnMapState(pickUp:this.pickUp);
}

class _LocatePickUpOnMapState extends State<LocatePickUpOnMap> {

  String pickUp;
  _LocatePickUpOnMapState({required this.pickUp});
  late GoogleMapController mapController;
  late String pickedPickedName = "nothing";
  late double pickUpLat = 0.0;
  late double pickUpLng = 0.0;


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
            actions:[
              pickedPickedName != "nothing" ?  TextButton(
                onPressed: () {
                  _mapController.setPickUpLocation(pickedPickedName);
                  _mapController.setPickUpLat(pickUpLat);
                  _mapController.setPickUpLng(pickUpLng);
// _mapController.dropOffLocation.text = pickedDropOffName;
                  Get.back();
                },
                child: const Text("Okay",style: TextStyle(fontWeight: FontWeight.bold))
              ) : Container()
            ]
          ),
          body: Stack(
            children: [
              GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_mapController.userLatitude,_mapController.userLongitude),
                    zoom: 15.0,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onTap: (latLng)async {

                    List<Placemark> placemark = await placemarkFromCoordinates(latLng.latitude,latLng.longitude);
                    pickUpLat = latLng.latitude;
                    pickUpLng = latLng.longitude;

                    setState(() {
                      pickedPickedName = placemark[2].street!;
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
                              child: Text("You have picked $pickedPickedName",style: const TextStyle(fontWeight: FontWeight.bold)),
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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxinet/states/app_state.dart';

class PassengerMapView extends StatefulWidget {

  const PassengerMapView({Key? key}) : super(key: key);

  @override
  State<PassengerMapView> createState() => _PassengerMapViewState();
}

class _PassengerMapViewState extends State<PassengerMapView> {
  Completer<GoogleMapController> mapController = Completer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return appState.loading
        ? const Center(
      child: Text("📍 Fetching your location,please wait",style: TextStyle(color: Colors.amber,fontSize: 17),),
    )
        : SafeArea(
      child: SizedBox(
        height: double.infinity,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
              target: appState.initialPosition, zoom: 11.5),
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller){
            mapController.complete(controller);
          },
          myLocationEnabled: true,
          compassEnabled: true,
          markers: appState.markers,
          onCameraMove: appState.onCameraMove,
          polylines: appState.polyLines,
        ),
      ),
    );
  }
}

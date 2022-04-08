import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxinet/states/app_state.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: MapView());
  }
}

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

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
            child: CircularProgressIndicator(),
          )
        : SafeArea(
          child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: appState.initialPosition, zoom: 11.5),
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  onMapCreated: appState.onCreated,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  markers: appState.markers,
                  onCameraMove: appState.onCameraMove,
                  polylines: appState.polyLines,
                ),

                Positioned(
                    top: 50.0,
                    right: 15.0,
                    left: 15.0,
                    child: Container(
                      height: 50.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(1.0, 5.0),
                                blurRadius: 10,
                                spreadRadius: 3)
                          ]),
                      child: TextFormField(
                        controller: appState.locationController,
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                            hintText: "Pick Up",
                            prefixIcon: Icon(Icons.location_on)),
                      ),
                    )),
                Positioned(
                    top: 120.0,
                    right: 15.0,
                    left: 15.0,
                    child: Container(
                      height: 50.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(1.0, 5.0),
                                blurRadius: 10,
                                spreadRadius: 3)
                          ]),
                      child: TextFormField(
                        controller: appState.destinationController,
                        textInputAction: TextInputAction.go,
                        onFieldSubmitted: (value) {
                          appState.sendRequest(value);
                        },
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                            hintText: "Destination",
                            prefixIcon: Icon(Icons.add_location_alt_sharp)),
                      ),
                    )),
                Positioned(
                  top: 300,
                    child: Text(appState.routeDuration,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.red),)
                ),

                Positioned(
                  top: 400,
                    child: Text(appState.routeDistance,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.red),)),
              ],
            ),
        );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxinet/states/app_state.dart';


class MapView extends StatefulWidget {
  double height;
  MapView({Key? key,required this.height}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState(height:this.height);
}

class _MapViewState extends State<MapView> {
  late double height;
  _MapViewState({required this.height});

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
          child: SizedBox(
            height: height,
            child: GoogleMap(
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
          ),
        );
  }
}

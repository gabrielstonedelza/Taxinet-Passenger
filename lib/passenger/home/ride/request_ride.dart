import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxinet/views/mapview.dart';

import '../../../constants/app_colors.dart';
import '../../../states/app_state.dart';

class RequestRide extends StatefulWidget {
  const RequestRide({Key? key}) : super(key: key);

  @override
  State<RequestRide> createState() => _RequestRideState();
}

class _RequestRideState extends State<RequestRide> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Ride"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Consumer(builder: (context, mapData, child) {
              return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: MapView(
                    height: double.infinity,
                  ));
            }),
            Positioned(
                top: 30.0,
                right: 15.0,
                left: 15.0,
                child: TextFormField(
                  readOnly: true,
                  controller: appState.locationController,
                  cursorRadius: const Radius.elliptical(10, 10),
                  cursorWidth: 10,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.location_on,
                        color: defaultTextColor2,
                      ),
                      focusColor: primaryColor,
                      fillColor: primaryColor,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(12)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                )),
            Positioned(
              top: 105.0,
              right: 15.0,
              left: 15.0,
              child: TextFormField(
                textInputAction: TextInputAction.go,
                onFieldSubmitted: (value){
                  appState.sendRequest(value);
                },
                controller: appState.destinationController,
                cursorColor: defaultTextColor2,
                cursorRadius: const Radius.elliptical(5, 5),
                cursorWidth: 5,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.add_location_alt_sharp,
                      color: defaultTextColor2,
                    ),
                    labelText: "Enter your destination",
                    labelStyle: const TextStyle(color: defaultTextColor2),
                    focusColor: defaultTextColor2,
                    fillColor: defaultTextColor2,
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: defaultTextColor2, width: 2),
                        borderRadius: BorderRadius.circular(12)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
                keyboardType: TextInputType.text,
              ),
            ),
            Positioned(
                top: 300,
                child: Text(
                  appState.routeDuration,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.red),
                )),
            Positioned(
                top: 400,
                child: Text(
                  appState.routeDistance,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.red),
                )),
          ],
        ),
      ),
    );
  }
}

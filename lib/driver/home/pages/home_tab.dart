
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxinet/driver/home/pages/drivermap.dart';
import 'package:taxinet/views/mapview.dart';
import 'package:provider/provider.dart';
import 'package:taxinet/constants/app_colors.dart';

import '../../../states/app_state.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> mapController = Completer();
  var uToken = "";
  final storage = GetStorage();
  var username = "";
  late Timer _timer;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final appState = Provider.of<AppState>(context,listen: false);
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    if(appState.initialPosition != null){
      appState.sendLocation(uToken);
    }
    appState.getDriversUpdatedLocations(uToken);
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      appState.deleteDriversLocations(uToken);
    });
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      appState.sendLocation(uToken);
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    final appState = Provider.of<AppState>(context,listen: false);
    appState.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return const DriverMap();
  }
}

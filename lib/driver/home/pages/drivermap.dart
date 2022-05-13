import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:taxinet/passenger/home/passenger_map.dart';
import 'package:taxinet/passenger/home/ride/request_ride.dart';
import 'package:taxinet/views/mapview.dart';

import '../../../constants/app_colors.dart';

import 'package:http/http.dart' as http;

import '../../../states/app_state.dart';

class DriverMap extends StatefulWidget {
  const DriverMap({Key? key}) : super(key: key);

  @override
  State<DriverMap> createState() => _DriverMapState();
}

class _DriverMapState extends State<DriverMap> {
  final storage = GetStorage();

  bool isFetching = false;
  bool hasInternet = false;
  late String uToken = "";
  late StreamSubscription internetSubscription;
  void _startFetching()async{
    setState(() {
      isFetching = true;
    });
    await Future.delayed(const Duration(seconds: 10));
    setState(() {
      isFetching = false;
    });
  }



  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _startFetching();
    internetSubscription = InternetConnectionChecker().onStatusChange.listen((status) {
      setState(() {
        hasInternet = status == InternetConnectionStatus.connected;
      });
    });
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    internetSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      backgroundColor: defaultTextColor2,

      body: appState.loading
          ?  SizedBox(
          height: double.infinity,
          child: Image.asset("assets/images/102267-location-loader.gif")) : Column(
        children: [
          Expanded(
            child: Consumer(builder: (context,mapData,child){
              return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: const MapView()
              );
            }),
          ),
        ],
      ),
    );
  }
}


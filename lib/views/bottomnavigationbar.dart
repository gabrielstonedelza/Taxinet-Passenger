import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:taxinet/passenger/home/pages/notifications.dart';
import 'package:taxinet/passenger/home/pages/profile.dart';
import 'package:taxinet/passenger/home/pages/schedules.dart';
import 'package:taxinet/views/welcome_options.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constants/app_colors.dart';
import '../controllers/notifications/localnotification_manager.dart';
import '../passenger/home/nointernetconnections.dart';
import '../passenger/home/pages/newprofile.dart';
import '../passenger/home/passenger_home.dart';
import 'home.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  final storage = GetStorage();
  late String username = "";
  late String uToken = "";
  int selectedIndex = 0;
  late PageController pageController;
  bool hasInternet = false;
  late StreamSubscription internetSubscription;

  void onSelectedIndex(int index){
    setState(() {
      selectedIndex = index;
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    internetSubscription = InternetConnectionChecker().onStatusChange.listen((status){
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(()=> this.hasInternet = hasInternet);
    });
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  void dispose(){
    internetSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
          children: hasInternet ? <Widget>[
            const HomePage(),
            PassengerHome(),
            Notifications(),
            const MyProfile(),
          ] : <Widget>[
            const NoInternetConnection()
          ],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              iconTheme: const IconThemeData(color:Colors.white)
          ),
          child: WaterDropNavBar(
            backgroundColor: Colors.white,
            inactiveIconColor: Colors.grey,
            bottomPadding: 10.0,
            waterDropColor: primaryColor,
            onItemSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
              pageController.animateToPage(selectedIndex,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutQuad);
            },
            selectedIndex: selectedIndex,
            barItems: [
              BarItem(
                filledIcon: Icons.home,
                outlinedIcon: Icons.home_outlined,
              ),
              BarItem(
                  filledIcon: Icons.access_time_filled,
                  outlinedIcon: Icons.access_time_outlined),
              BarItem(
                filledIcon: Icons.notifications,
                outlinedIcon: Icons.notifications_outlined,
              ),
              BarItem(
                filledIcon: Icons.person,
                outlinedIcon: Icons.person_outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

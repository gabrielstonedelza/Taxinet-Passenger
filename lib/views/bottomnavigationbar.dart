import 'dart:async';
import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:taxinet/passenger/home/pages/notifications.dart';
import 'package:http/http.dart' as http;
import 'package:taxinet/views/welcome_options.dart';
import 'package:get/get.dart';
import '../accountsblocked.dart';
import '../g_controller/notificationController.dart';
import '../passenger/home/pages/newprofile.dart';
import '../passenger/home/schedules.dart';

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
  NotificationController notificationController = Get.find();
  late List allBlockedUsers = [];
  late List blockedUsernames = [];
  late Timer _timer;
  bool isBlocked = false;
  final screens = [
    const WelcomeOptions(),
    SchedulesHome(),
    Notifications(),
    const MyProfile(),
  ];

  void onSelectedIndex(int index){
    setState(() {
      selectedIndex = index;
    });
  }
  bool isLoading = true;

  fetchBlockedAgents()async{
    const url = "https://fnetghana.xyz/get_blocked_users/";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink,);
    if(response.statusCode == 200){
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      allBlockedUsers = json.decode(jsonData);
      for(var i in allBlockedUsers){
        if(!blockedUsernames.contains(i['get_username'])){
          blockedUsernames.add(i['get_username']);
        }
      }

    }

    setState(() {
      isLoading = false;
      allBlockedUsers = allBlockedUsers;
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
    fetchBlockedAgents();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchBlockedAgents();
    });
  }

  @override
  void dispose(){
    internetSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child:blockedUsernames.contains(username) ? const Scaffold(
          body: AccountBlockNotification()
      ) :Scaffold(
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              indicatorColor: Colors.blue.shade100,
            labelTextStyle:  MaterialStateProperty.all(
              const TextStyle(fontSize:14, fontWeight: FontWeight.bold)
            )
          ),
          child: NavigationBar(
            animationDuration: const Duration(seconds: 3),
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) => setState((){
              selectedIndex = index;
            }),
            height: 60,
            backgroundColor: Colors.white,
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: "Home",
              ),
              const NavigationDestination(
                icon: Icon(Icons.access_time_outlined),
                selectedIcon: Icon(Icons.access_time_filled),
                label: "Rides",
              ),
              GetBuilder<NotificationController>(builder: (controller){
                return NavigationDestination(
                  icon: Badge(
                    animationDuration: const Duration(seconds: 3),
                      // padding: const EdgeInsets.all(2),
                      // position: BadgePosition.bottomStart(),
                      toAnimate: true,
                      shape: BadgeShape.circle,
                      badgeColor: Colors.red,
                      // borderRadius: BorderRadius.circular(8),
                      badgeContent: Text("${notificationController.notRead.length}",style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize:15)),
                      child: const Icon(Icons.notifications_outlined)),
                  selectedIcon: const Icon(Icons.notifications),
                  label: "Notifications",
                );
              }),
              const NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
        ),
        body: screens[selectedIndex],
      )
    );
  }
}

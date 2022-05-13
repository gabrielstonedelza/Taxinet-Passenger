import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxinet/driver/home/pages/rides_tab.dart';
import 'package:taxinet/driver/home/pages/home_tab.dart';
import 'package:taxinet/driver/home/pages/profile_tab.dart';
import 'package:taxinet/driver/home/pages/notifications.dart';

import '../../states/app_state.dart';


class DriverHome extends StatefulWidget {
  const DriverHome({Key? key}) : super(key: key);

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> with SingleTickerProviderStateMixin{
  TabController? _tabController;
  int selectedIndex = 0;

  onTabClicked(int index){
    setState(() {
      selectedIndex = index;
      _tabController!.index = selectedIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      body: appState.loading
          ?  SizedBox(
          height: double.infinity,
          child: Image.asset("assets/images/102267-location-loader.gif")) :TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomePage(),
          Rides(),
          Notifications(),
          ProfilePage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.access_time_sharp),label: "Rides"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications),label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile"),
        ],
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showSelectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onTabClicked,
      ),
    );
  }
}


import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';


import '../constants/app_colors.dart';

Widget myFabMenu(){

  return FabCircularMenu(
    alignment: Alignment.topRight,
    fabColor: primaryColor,
    fabOpenColor: secondaryColor,
    ringDiameter: 250.0,
    ringWidth: 60.0,
    ringColor: defaultTextColor2,
    fabSize: 60.0,
    fabElevation: 12,
    children: [
      IconButton(
        onPressed: (){
          // Get.to(() => const NewDriverHome());
        },
        icon: const Icon(Icons.home,color: primaryColor,),
      ),
      IconButton(
        onPressed: (){
          // Get.to(() => const Rides());
        },
        icon: const Icon(Icons.access_time_sharp,color: primaryColor),
      ),
      IconButton(
        onPressed: (){
          // Get.to(() => const Notifications());
        },
        icon: const Icon(Icons.notifications,color: primaryColor),
      ),
      IconButton(
        onPressed: (){
          // Get.to(() => const ProfilePage());
        },
        icon: const Icon(Icons.person,color: primaryColor),
      ),
    ],
  );
}
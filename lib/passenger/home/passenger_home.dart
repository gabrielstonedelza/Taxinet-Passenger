import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:taxinet/passenger/home/ride/request_ride.dart';
import 'package:taxinet/views/mapview.dart';

import '../../constants/app_colors.dart';
import '../../controllers/login/login_controller.dart';

class PassengerHome extends StatefulWidget {
  const PassengerHome({Key? key}) : super(key: key);

  @override
  State<PassengerHome> createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultTextColor2,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Taxinet",style: TextStyle(fontWeight: FontWeight.bold,color: primaryColor,fontSize: 20),),
              Consumer<LoginController>(
                builder: (context,userData,child){
                  return CircleAvatar(
                    backgroundImage:
                    NetworkImage(userData.userProfilePic),
                  );
                }
              )
            ],
          )),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          // CarouselSlider(
          //     items: [
          //       Container(
          //         alignment: Alignment.bottomLeft,
          //         decoration: BoxDecoration(
          //             image: const DecorationImage(
          //                 image: AssetImage(
          //                     "assets/images/86604-for-ride-share-app-car-animation.gif"),
          //                 fit: BoxFit.cover),
          //             border: Border.all(),
          //             borderRadius:
          //                 const BorderRadius.all(Radius.circular(12))),
          //         child: const Padding(
          //           padding: EdgeInsets.only(left: 8.0, bottom: 10),
          //           child: Text(
          //             "Ride",
          //             style: TextStyle(
          //                 fontWeight: FontWeight.bold,
          //                 color: primaryColor,
          //                 fontSize: 20),
          //           ),
          //         ),
          //         height: 50,
          //         width: 100,
          //       ),
          //       Container(
          //         alignment: Alignment.bottomLeft,
          //         decoration: BoxDecoration(
          //             image: const DecorationImage(
          //                 image: AssetImage(
          //                     "assets/images/90409-delivery-truck.gif"),
          //                 fit: BoxFit.cover),
          //             border: Border.all(),
          //             borderRadius:
          //                 const BorderRadius.all(Radius.circular(12))),
          //         child: const Padding(
          //           padding: EdgeInsets.only(left: 8.0, bottom: 10),
          //           child: Text(
          //             "Delivery",
          //             style: TextStyle(
          //                 fontWeight: FontWeight.bold,
          //                 color: primaryColor,
          //                 fontSize: 20),
          //           ),
          //         ),
          //         height: 50,
          //         width: 100,
          //       )
          //     ],
          //     options: CarouselOptions(
          //       aspectRatio: 3.0,
          //       viewportFraction: 0.8,
          //       initialPage: 0,
          //       enableInfiniteScroll: true,
          //       reverse: false,
          //       autoPlay: false,
          //       autoPlayInterval: const Duration(seconds: 3),
          //       autoPlayAnimationDuration: const Duration(milliseconds: 800),
          //       autoPlayCurve: Curves.fastOutSlowIn,
          //       enlargeCenterPage: true,
          //       scrollDirection: Axis.horizontal,
          //     )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    Get.to(()=> const RequestRide(),transition: Transition.leftToRight);
                  },
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage(
                                "assets/images/86604-for-ride-share-app-car-animation.gif"),
                            fit: BoxFit.cover),
                        border: Border.all(),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(12))),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0, bottom: 8),
                      child: Text(
                        "Ride",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: defaultTextColor2,
                            fontSize: 20),
                      ),
                    ),
                    height: 100,
                    width: 190,
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: AssetImage(
                              "assets/images/90409-delivery-truck.gif"),
                          fit: BoxFit.cover),
                      border: Border.all(),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(12))),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8.0, bottom: 7),
                    child: Text(
                      "Delivery",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: defaultTextColor2,
                          fontSize: 20),
                    ),
                  ),
                  height: 100,
                  width: 190,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Your Location",style: TextStyle(fontWeight: FontWeight.bold,color: primaryColor),),
          ),
          const SizedBox(
            height: 20,
          ),
          Consumer(builder: (context,mapData,child){
            return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: MapView(height: 300,)
            );
          }),
          const SizedBox(
            height: 20,
          ),

        ],
      ),
    );
  }
}


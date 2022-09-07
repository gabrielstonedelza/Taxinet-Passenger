import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxinet/passenger/home/pages/gettickets.dart';
import 'package:taxinet/passenger/home/pages/schedulebus.dart';
import 'package:taxinet/passenger/home/pages/scheduledelivery.dart';
import 'package:taxinet/passenger/home/pages/scheduleluxury.dart';
import 'package:taxinet/passenger/home/pages/scheduletruck.dart';
import 'package:taxinet/passenger/home/schedule_ride.dart';
import '../../constants/app_colors.dart';

Widget myCarouselOne(){
  return CarouselSlider(
      items: [
        GestureDetector(
          onTap: (){
            Get.to(() => const ScheduleRide());
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width:320,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: const DecorationImage(
                          image: AssetImage("assets/images/taxinet.jpg"),
                          fit: BoxFit.fill
                      ),
                      boxShadow: const [BoxShadow(offset:Offset(0,4), blurRadius:4,color:Colors.black26)]
                  ),
                ),
              ),
              const SizedBox(height:20),
              const Text("Taxinet Ride",style: TextStyle(fontWeight: FontWeight.bold,color:defaultBlack,fontSize: 20),textAlign: TextAlign.center,),
            ],
          ),
        ),
        GestureDetector(
          onTap: (){
            Get.to(()=> const ScheduleLuxury());
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width:320,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: const DecorationImage(
                          image: AssetImage("assets/images/suv.png"),
                          fit: BoxFit.fill
                      ),
                      boxShadow: const [BoxShadow(offset:Offset(0,4), blurRadius:4,color:Colors.black26)]
                  ),
                ),
              ),
              const SizedBox(height:20),
              const Text("Taxinet Luxury",style: TextStyle(fontWeight: FontWeight.bold,color:defaultBlack,fontSize: 20),textAlign: TextAlign.center,),
            ],
          ),
        ),
        GestureDetector(
          onTap: (){
            Get.to(()=> const ScheduleTruck());
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width:320,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: const DecorationImage(
                          image: AssetImage("assets/images/truck.jpg"),
                          fit: BoxFit.fill
                      ),
                      boxShadow: const [BoxShadow(offset:Offset(0,4), blurRadius:4,color:Colors.black26)]
                  ),
                ),
              ),
              const SizedBox(height:20),
              const Text("Taxinet Truck",style: TextStyle(fontWeight: FontWeight.bold,color:defaultBlack,fontSize: 20),textAlign: TextAlign.center,),
            ],
          ),
        ),
        GestureDetector(
          onTap: (){
            Get.to(()=> const ScheduleDeliver());
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width:320,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: const DecorationImage(
                          image: AssetImage("assets/images/delivery.jpg"),
                          fit: BoxFit.fill
                      ),
                      boxShadow: const [BoxShadow(offset:Offset(0,4), blurRadius:4,color:Colors.black26)]
                  ),
                ),
              ),
              const SizedBox(height:20),
              const Text("Taxinet Delivery",style: TextStyle(fontWeight: FontWeight.bold,color:defaultBlack,fontSize: 20),textAlign: TextAlign.center,),
            ],
          ),
        ),
        GestureDetector(
          onTap: (){
            Get.to(()=> const ScheduleBus());
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width:320,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: const DecorationImage(
                          image: AssetImage("assets/images/bus.jpg"),
                          fit: BoxFit.fill
                      ),
                      boxShadow: const [BoxShadow(offset:Offset(0,4), blurRadius:4,color:Colors.black26)]
                  ),
                ),
              ),
              const SizedBox(height:20),
              const Text("Taxinet Bus",style: TextStyle(fontWeight: FontWeight.bold,color:defaultBlack,fontSize: 20),textAlign: TextAlign.center,),
            ],
          ),
        ),
        GestureDetector(
          onTap: (){
            Get.to(()=> const TaxinetTicket());
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width:320,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: const DecorationImage(
                          image: AssetImage("assets/images/ticket.jpg"),
                          fit: BoxFit.fill
                      )
                  ),
                ),
              ),
              const SizedBox(height:20),
              const Text("Taxinet Ticket",style: TextStyle(fontWeight: FontWeight.bold,color:defaultBlack,fontSize: 20),textAlign: TextAlign.center,),
            ],
          ),
        ),
      ],
      options: CarouselOptions(
        height: 280,
        aspectRatio: 1.25,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      )
  );
}
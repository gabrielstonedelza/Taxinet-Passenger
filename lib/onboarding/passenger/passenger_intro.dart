import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import "package:get/get.dart";
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:taxinet/onboarding/passenger/welcomepageboard.dart';

import '../../constants/app_colors.dart';
import '../../views/bottomnavigationbar.dart';

class PassengerOnBoarding extends StatefulWidget {
  const PassengerOnBoarding({Key? key}) : super(key: key);

  @override
  State<PassengerOnBoarding> createState() => _PassengerOnBoardingState();
}

class _PassengerOnBoardingState extends State<PassengerOnBoarding> {
  final controller = PageController();
  bool isLastPage = false;
  final storage = GetStorage();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(bottom:80),
          child: PageView(
            controller: controller,
            onPageChanged: (index){
              setState(() {
                isLastPage = index == 6;
              });
            },
            children: [
              buildPage(primaryColor,"assets/images/85795-man-and-woman-say-hi.gif","Welcome to Taxinet","We are happy to see you join our family,please feel free to glance through all our services."),
              buildPage(primaryColor,"assets/images/24152-yellow-taxi.gif","Taxinet Ride","Get one of our Taxinet cars to your destination of choice with ease.Go to homepage and click on the Taxi icon to schedule your ride."),
              buildPage(primaryColor,"assets/images/115439-mokum-taxi.gif","Taxinet Luxury","Want to ride in style?\nSchedule one of our luxury cars of your choice."),
              buildPage(primaryColor,"assets/images/98455-delivery-truck.gif","Taxinet Delivery","Fastest delivery service ever in Ghana now.\n Where do you want your items deliverted?\nSchedule and we will get them to you."),
              buildPage(primaryColor,"assets/images/90409-delivery-truck.gif","Taxinet Truck","Want a truch for any service?\n We are here for you."),
              buildPage(primaryColor,"assets/images/100548-bus-carga-trackmile.gif","Taxinet Bus","Want a bus for an adventure?"),
              buildPage(primaryColor,"assets/images/9932-flight-ticket.gif","Taxinet Tickets","Book your tickets with us at affordable price"),
            ],
          ),
        ),
        bottomSheet: isLastPage ? Container(
          padding: const EdgeInsets.symmetric(horizontal:10),
          height: 80,
          width:MediaQuery.of(context).size.width,
          color:Colors.black,
          child: TextButton(
            onPressed: () async{
              storage.write("viewedIntro","ViewedInto");
              Get.offAll(()=> const MyBottomNavigationBar());
            },
            child: const Text("Get Started",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white,fontSize:20))
          ),
        ) :Container(
          padding: const EdgeInsets.symmetric(horizontal:10),
          height: 80,
          color:Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: const Text("Skip",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white)),
                onPressed: (){
                  controller.jumpToPage(6);
                }
              ),
              Center(child:SmoothPageIndicator(
                controller: controller,
                count: 7,
                onDotClicked: (index){
                  controller.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                },
              )),
              TextButton(
                  child: const Text("Next",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white)),
                  onPressed: (){
                    controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                  }
              ),
            ],
          )
        ),
      ),
    );
  }
}

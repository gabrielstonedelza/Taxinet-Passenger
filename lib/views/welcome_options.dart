import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:taxinet/constants/app_colors.dart';
import 'package:get/get.dart';
import 'package:taxinet/passenger/home/passenger_home.dart';

class WelcomeOptions extends StatefulWidget {
  const WelcomeOptions({Key? key}) : super(key: key);

  @override
  State<WelcomeOptions> createState() => _WelcomeOptionsState();
}

class _WelcomeOptionsState extends State<WelcomeOptions> {

  final storage = GetStorage();
  late String username = "";
  late String uToken = "";

  String greetingMessage(){
    var timeNow = DateTime.now().hour;
    if (timeNow <= 12) {
      return 'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      return 'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20,),
          Center(
            child: Text("${greetingMessage()}, ${username.capitalize}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
          ),
          const Center(
            child: Text("What do you want today?",style: TextStyle(fontWeight: FontWeight.bold,fontSize:15,color: Colors.white),),
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GestureDetector(
                    onTap: (){
                      Get.to(()=> const PassengerHome());
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Expanded(child: Image.asset("assets/images/taxinet_cab.png")),
                            const Expanded(child: Center(child: Text("Taxinet Ride",style: TextStyle(fontWeight: FontWeight.bold,fontSize:15,color: defaultTextColor1),),))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GestureDetector(
                    onTap: (){
                      Get.snackbar(
                          "Hi 😛", "Taxinet Luxury coming soon",
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: primaryColor
                      );
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [

                            Expanded(child: Image.asset("assets/images/pngaaa.com-510073.png")),

                            const Expanded(child: Center(child: Text("Taxinet Luxury",style: TextStyle(fontWeight: FontWeight.bold,fontSize:15,color: defaultTextColor1)),))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          const Divider(),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GestureDetector(
                    onTap: (){
                      Get.snackbar(
                          "Hi 😛", "Taxinet Truck coming soon",
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 5),
                          colorText: Colors.white,
                          backgroundColor: primaryColor
                      );
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [

                            Expanded(child: Image.asset("assets/images/pngaaa.com-1805551.png")),
                            const Expanded(child: Center(child: Text("Taxinet Track",style: TextStyle(fontWeight: FontWeight.bold,fontSize:15,color: defaultTextColor1)),))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GestureDetector(
                    onTap: (){
                      Get.snackbar(
                          "Hi 😛", "Taxinet Delivery coming soon",
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 5),
                          colorText: Colors.white,
                          backgroundColor: primaryColor,
                      );
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Expanded(child: Image.asset("assets/images/pngaaa.com-684094.png")),
                            const Expanded(child: Center(child: Text("Taxinet Delivery",style: TextStyle(fontWeight: FontWeight.bold,fontSize:15,color: defaultTextColor1)),))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

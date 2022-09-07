import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import "package:get/get.dart";
import "package:flutter/material.dart";
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:taxinet/passenger/home/paymentmethods.dart';
import '../constants/app_colors.dart';
import '../controllers/notifications/localnotification_manager.dart';
import '../g_controller/userController.dart';
import '../g_controller/walletcontroller.dart';
import '../passenger/home/mycarousel.dart';
import '../passenger/home/pages/gettickets.dart';
import '../passenger/home/pages/notifications.dart';
import '../passenger/home/pages/schedulebus.dart';
import '../passenger/home/pages/scheduledelivery.dart';
import '../passenger/home/pages/scheduleluxury.dart';
import '../passenger/home/pages/scheduletruck.dart';
import '../passenger/home/schedule_ride.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  final int _currentPage = 0;
  final storage = GetStorage();
  late String username = "";
  late String uToken = "";
  late String userid = "";
  UserController userController = Get.find();
  WalletController walletController = Get.find();
  final formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  bool isPosting = false;

  bool isFetching = true;
  bool isLoading = true;
  late List allNotifications = [];
  late List yourNotifications = [];
  late List notRead = [];
  late List triggered = [];
  late List unreadNotifications = [];
  late List triggeredNotifications = [];
  late List notifications = [];
  late List allNots = [];
  late Timer _timer;
  bool canSchedule = false;
  List dataListNames = [
    "Taxinet Ride",
    "Taxinet Luxury",
    "Taxinet Truck",
    "Taxinet Delivery",
    "Taxinet Bus",
    "Taxinet Ticktes",
  ];
  List dataListImages = [
    "assets/images/taxinet.jpg",
    "assets/images/suv.png",
    "assets/images/truck.jpg",
    "assets/images/delivery.jpg",
    "assets/images/bus.jpg",
    "assets/images/ticket.jpg",
  ];
  List<Widget> dataListPages = [
    const ScheduleRide(),
    const ScheduleLuxury(),
    const ScheduleTruck(),
    const ScheduleDeliver(),
    const ScheduleBus(),
    const TaxinetTicket()
  ];

  Future<void> getAllTriggeredNotifications() async {
    const url = "https://fnetghana.xyz/get_passengers_triggered_notifications/";
    var myLink = Uri.parse(url);
    final response =
    await http.get(myLink, headers: {"Authorization": "Token $uToken"});
    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      triggeredNotifications = json.decode(jsonData);
      triggered.assignAll(triggeredNotifications);
    }
  }

  Future<void> getAllUnReadNotifications() async {
    const url = "https://fnetghana.xyz/get_passenger_notifications/";
    var myLink = Uri.parse(url);
    final response =
    await http.get(myLink, headers: {"Authorization": "Token $uToken"});
    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      yourNotifications = json.decode(jsonData);
      notRead.assignAll(yourNotifications);
    }
  }

  Future<void> getAllPassengerNotifications() async {
    const url = "https://fnetghana.xyz/passengers_notifications/";
    var myLink = Uri.parse(url);
    final response =
    await http.get(myLink, headers: {"Authorization": "Token $uToken"});
    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      notifications = json.decode(jsonData);
      allNots.assignAll(notifications);
    }
    setState(() {
      isLoading = false;
      allNotifications = allNotifications;
      isFetching = false;
    });
  }

  unTriggerNotifications(int id) async {
    final requestUrl = "https://fnetghana.xyz/read_notification/$id/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    }, body: {
      "notification_trigger": "Not Triggered",
    });
    if (response.statusCode == 200) {}
  }

  updateReadNotification(int id) async {
    final requestUrl = "https://taxinetghana.xyz/user_read_notifications/$id/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    }, body: {
      "read": "Read",
    });
    if (response.statusCode == 200) {}
  }

  void _startPosting() async {
    setState(() {
      isPosting = true;
    });
    await Future.delayed(const Duration(seconds: 4));
    setState(() {
      isPosting = false;
    });
  }

  String greetingMessage() {
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

  processLoadWallet() async {
    const depositUrl = "https://taxinetghana.xyz/request_to_load_wallet/";
    final myLink = Uri.parse(depositUrl);
    final res = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    }, body: {
      // "passenger": userid,
      "amount": amountController.text,
    });
    if (res.statusCode == 201) {
      Get.snackbar("Congratulations", "Request sent.",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: snackColor);

      setState(() {
        amountController.text = "";
      });
     Get.back();
      // Get.offAll(() => const MyBottomNavigationBar());
    } else {
      // print(res.body);
      Get.snackbar("Error", "Something went wrong,please try again later",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5));
    }
  }

  @override
  void initState(){
    super.initState();
    _pageController = PageController(initialPage: _currentPage,viewportFraction: 0.8);
    if(double.parse(walletController.wallet) == 0.00){
      setState(() {
        canSchedule = false;
      });
    }
    else{
      setState(() {
        canSchedule = true;
      });
    }

    getAllTriggeredNotifications();
    _timer = Timer.periodic(const Duration(seconds: 12), (timer) {
      getAllTriggeredNotifications();
      getAllUnReadNotifications();
      for (var i in triggered) {
        localNotificationManager.showAllNotification(
            i['notification_title'], i['notification_message']);
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      for (var e in triggered) {
        unTriggerNotifications(e["id"]);
      }
    });
    localNotificationManager.setOnAllNotificationReceive(onNotificationReceive);
    localNotificationManager.setOnAllNotificationClick(onNotificationClick);
  }

  //notifications localNotificationManager
  onNotificationClick(String payload) {
    Get.to(() => Notifications());
  }
  onNotificationReceive(ReceiveNotification notification) {}

  @override
  void dispose(){
    super.dispose();
    _pageController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical:40),
        child: Column(
          children:  [
            Center(
              child: BackdropFilter(
                filter:
                ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: userController.profileImageUpload !=
                    null
                    ? GetBuilder<UserController>(
                  builder: (controller) {
                    return CircleAvatar(
                      backgroundImage: FileImage(
                          userController
                              .profileImageUpload!),
                      radius: size.width * 0.14,
                      backgroundColor: Colors.pink,
                    );
                  },
                )
                    : GetBuilder<UserController>(
                  builder: (controller) {
                    return userController.profileImage == "" ? const CircleAvatar(
                      backgroundImage: AssetImage("assets/images/user.png"),
                      radius: 40,
                    ) :CircleAvatar(
                      backgroundImage: NetworkImage(
                          userController.profileImage),
                      radius: size.width * 0.14,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
                child: Text("Wallet",
                    style: TextStyle(fontWeight: FontWeight.bold,color: secondaryColor,fontSize: 15))),
            const SizedBox(height: 10),
            Center(child: GetBuilder<WalletController>(
                builder: (controller) {
                  return Text(
                      "GHS ${walletController.wallet}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25));
                })),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: (){
                showMaterialModalBottomSheet(
                  context: context,
                  // expand: true,
                  isDismissible: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.vertical(
                          top: Radius.circular(25.0))),
                  bounce: true,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context)
                            .viewInsets
                            .bottom),
                    child: SizedBox(
                        height: 250,
                        child: Column(
                          mainAxisSize:
                          MainAxisSize.min,
                          children: [
                            const SizedBox(height: 30),
                            const Center(
                                child: Text(
                                    "How much would you like to load into your wallet?",
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight
                                            .bold))),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                              const EdgeInsets.all(
                                  18.0),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets
                                          .only(
                                          bottom:
                                          10.0),
                                      child:
                                      TextFormField(
                                        controller:
                                        amountController,
                                        // cursorColor:
                                        // primaryColor,
                                        cursorRadius:
                                        const Radius
                                            .elliptical(
                                            3, 3),
                                        cursorWidth: 10,
                                        decoration: const InputDecoration(
                                            labelText:
                                            "Enter amount",
                                            labelStyle:
                                            TextStyle(
                                                color:
                                                secondaryColor),
                                            focusColor:
                                            primaryColor,
                                            fillColor:
                                            primaryColor,
                                            // focusedBorder: OutlineInputBorder(
                                            //     borderSide: const BorderSide(
                                            //         color:
                                            //         primaryColor,
                                            //         width:
                                            //         2),
                                            //     borderRadius:
                                            //     BorderRadius.circular(
                                            //         12)),
                                            // border: OutlineInputBorder(
                                            //     borderRadius:
                                            //     BorderRadius.circular(12))
                                        ),
                                        keyboardType:
                                        TextInputType
                                            .number,
                                        validator:
                                            (value) {
                                          if (value!
                                              .isEmpty) {
                                            return "Please enter amount";
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                        height: 20),
                                    RawMaterialButton(
                                      onPressed:
                                          () {
                                        if(amountController.text == ""){
                                          Get.snackbar("Amount Error", "please enter amount to load",
                                              duration: const Duration(seconds: 4),
                                              snackPosition: SnackPosition.BOTTOM,
                                              backgroundColor: Colors.red,
                                              colorText: defaultTextColor1);
                                        }
                                        else{
                                          Get.back();
                                          Get.to(()=> PaymentMethods(amount:amountController.text));
                                        }
                                      },
                                      // child: const Text("Send"),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8)),
                                      elevation:
                                      8,
                                      fillColor:
                                      defaultBlack,
                                      splashColor:
                                      defaultColor,
                                      child:
                                      const Text(
                                        "Top Up",
                                        style: TextStyle(
                                            fontWeight: FontWeight
                                                .bold,
                                            fontSize:
                                            15,
                                            color:
                                            defaultTextColor1),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                );
              },
              child: Container(
                width: 140,
                  height: 60,
                  decoration: BoxDecoration(
                      color: defaultBlack,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [BoxShadow(offset:Offset(0,4), blurRadius:4,color:Colors.white38)]
                  ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/deposit.png",width: 40, height: 40),
                    const SizedBox(width: 10),
                    const Text("Top Up",style: TextStyle(fontWeight: FontWeight.bold,color:defaultTextColor1))
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            myCarouselOne(),
          ],
        )
      ),

    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:taxinet/constants/app_colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:taxinet/passenger/home/schedule_ride.dart';

import '../controllers/notifications/localnotification_manager.dart';
import '../g_controller/notificationController.dart';
import '../g_controller/schedulescontroller.dart';
import '../g_controller/userController.dart';
import '../g_controller/walletcontroller.dart';
import '../mapscontroller.dart';
import '../onboarding/passenger/passenger_intro.dart';
import '../passenger/home/pages/notifications.dart';
import '../passenger/home/paymentmethods.dart';
import '../passenger/home/payments.dart';
import '../widgets/shimmers/shimmerwidget.dart';

class WelcomeOptions extends StatefulWidget {
  const WelcomeOptions({Key? key}) : super(key: key);

  @override
  State<WelcomeOptions> createState() => _WelcomeOptionsState();
}

class _WelcomeOptionsState extends State<WelcomeOptions> {
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

  final MapController _mapController = Get.find();
  NotificationController notificationController = Get.find();
  ScheduleController scheduleController = Get.find();

  Future<void> getAllTriggeredNotifications() async {
    const url = "https://taxinetghana.xyz/user_triggerd_notifications/";
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
    const url = "https://taxinetghana.xyz/user_notifications/";
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

  Future<void> getAllNotifications() async {
    const url = "https://taxinetghana.xyz/get_all_driver_notifications/";
    var myLink = Uri.parse(url);
    final response =
    await http.get(myLink, headers: {"Authorization": "Token $uToken"});
    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      allNotifications = json.decode(jsonData);
      allNots.assignAll(allNotifications);
    }
  }

  unTriggerNotifications(int id) async {
    final requestUrl = "https://taxinetghana.xyz/user_read_notifications/$id/";
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
      // Navigator.pop(context);
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
  void initState() {
    // ignore: todo
    // TODO: implement initState

    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    if (storage.read("userid") != null) {
      userid = storage.read("userid");
    }
    _mapController.getUserLocation();
    userController.getUserProfile(uToken);
    userController.getAllUsers(uToken);
    userController.getAllDrivers();
    userController.getAllPassengers();
    walletController.getUserWallet(uToken);
    notificationController.getAllNotifications(uToken);
    notificationController.getAllUnReadNotifications(uToken);
    scheduleController.getAllSchedules(uToken);
    scheduleController.getActiveSchedules(uToken);
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      userController.getUserProfile(uToken);
      userController.getAllUsers(uToken);
      userController.getAllDrivers();
      userController.getAllPassengers();
      walletController.getUserWallet(uToken);
      notificationController.getAllNotifications(uToken);
      notificationController.getAllUnReadNotifications(uToken);
      scheduleController.getAllSchedules(uToken);
      scheduleController.getActiveSchedules(uToken);
      });
    super.initState();

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

  //  awesome_notifications
  //   AwesomeNotifications().isNotificationAllowed().then((isAllowed) => {
  //     if(!isAllowed) {
  //       Get.defaultDialog(
  //         title: "Allow Notifications",
  //         content: const Text("Taxinet would like to send you notifications"),
  //         actions: [
  //           TextButton(
  //             onPressed: (){
  //                AwesomeNotifications().requestPermissionToSendNotifications().then((_)=>{
  //                Get.back()
  //                });
  //             },
  //             child: const Text("Allow ")
  //           ),
  //           TextButton(
  //               onPressed: (){
  //                 Get.back();
  //               },
  //               child: const Text("Don't Allow ")
  //           ),
  //         ]
  //       )
  //     }
  //   });
  }

  //notifications localNotificationManager
  onNotificationClick(String payload) {
    Get.to(() => Notifications());
  }

  onNotificationReceive(ReceiveNotification notification) {}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: ListView(
          children: [
            Container(
              height: 250,
              decoration: const BoxDecoration(
                // color: primaryColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 30),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showMaterialModalBottomSheet(
                          context: context,
                          // expand: true,
                          isDismissible: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0))),
                          bounce: true,
                          builder: (context) => Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: SizedBox(
                                height: 250,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 30),
                                    const Center(
                                        child: Text(
                                            "How much would you like to load into your wallet?",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Form(
                                        key: formKey,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: TextFormField(
                                                controller: amountController,
                                                // cursorColor:
                                                // primaryColor,
                                                cursorRadius:
                                                    const Radius.elliptical(
                                                        3, 3),
                                                cursorWidth: 10,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: "Enter amount",
                                                  labelStyle: TextStyle(
                                                      color: secondaryColor),
                                                  focusColor: primaryColor,
                                                  fillColor: primaryColor,
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Please enter amount";
                                                  }
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            RawMaterialButton(
                                              onPressed: () {
                                                if (amountController.text ==
                                                    "") {
                                                  Get.snackbar("Amount Error",
                                                      "please enter amount to load",
                                                      duration: const Duration(
                                                          seconds: 4),
                                                      snackPosition:
                                                          SnackPosition.BOTTOM,
                                                      backgroundColor:
                                                          Colors.red,
                                                      colorText:
                                                          defaultTextColor1);
                                                } else {
                                                  Get.back();
                                                  Get.to(() => PaymentMethods(
                                                      amount: amountController
                                                          .text));
                                                }
                                              },
                                              // child: const Text("Send"),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              elevation: 8,
                                              fillColor: defaultBlack,
                                              splashColor: defaultColor,
                                              child: const Text(
                                                "Top Up",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: defaultTextColor1),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/deposit.png",
                              width: 50, height: 50),
                          const SizedBox(height: 10),
                          const Text(
                            "Top Up",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on),
                            GetBuilder<MapController>(builder: (controller) {
                              return _mapController.isLoading
                                  ? const ShimmerWidget.rectangular(
                                      width: 100, height: 20)
                                  : Text(_mapController.myLocationName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: secondaryColor,
                                          fontSize: 15));
                            })
                          ],
                        )),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: GetBuilder<UserController>(
                                builder: (controller) {
                                  return controller.isLoading
                                      ? const ShimmerWidget.circular(
                                          width: 100, height: 100)
                                      : controller.profileImage == ""
                                          ? const CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  "assets/images/user.png"),
                                              radius: 50,
                                            )
                                          : CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  controller.profileImage),
                                              radius: size.width * 0.14,
                                            );
                                },
                              ),
                      ),
                      Expanded(
                        child: Center(child:
                            GetBuilder<WalletController>(builder: (controller) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.account_balance_wallet),
                              const SizedBox(width: 10),
                              walletController.isLoading
                                  ? const ShimmerWidget.rectangular(
                                      width: 100, height: 20)
                                  : Text("GHS ${walletController.wallet}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                            ],
                          );
                        })),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  Expanded(
                      child: GestureDetector(
                          onTap: () {
                            Get.to(() => const Transfers());
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10),
                              Image.asset("assets/images/transfer.png",width: 50,height: 50,),
                              const SizedBox(height: 10),
                              const Text(
                                "Transfer",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              )
                            ],
                          )))
                ],
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32), topRight: Radius.circular(32)),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 600,
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    IconButton(onPressed: (){
                      Get.to(() => const PassengerOnBoarding());
                    },icon: Lottie.asset("assets/json/120887-info.json",width:100,height: 100,fit: BoxFit.cover)),
                    Center(
                      child: Text(
                        "${greetingMessage()}, ${userController.username.capitalize}",
                        style: const TextStyle(
                            color: defaultTextColor2,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        "What do you want today?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: defaultTextColor2),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: GestureDetector(
                                onTap: () {
                                  walletController.canBook
                                      ? Get.to(() => const ScheduleRide())
                                      : Get.snackbar("Sorry 😭",
                                          "your wallet is low,please load wallet.",
                                          duration: const Duration(seconds: 8),
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.red,
                                          colorText: defaultTextColor1);
                                },
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: const BoxDecoration(
                                    color: pearl,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      children: [
                                        Expanded(
                                            child: Image.asset(
                                                "assets/images/taxinet_cab.png")),
                                        const SizedBox(height: 10),
                                        const Expanded(
                                            child: Center(
                                          child: Text(
                                            "Taxinet Ride",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: GestureDetector(
                                onTap: () {
                                  Get.snackbar(
                                      "Hi 😛", "Taxinet Luxury coming soon",
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 5),
                                      colorText: Colors.white,
                                      backgroundColor: primaryColor);
                                },
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: const BoxDecoration(
                                    color: pearl,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      children: [
                                        Expanded(
                                            child: Image.asset(
                                                "assets/images/pngaaa.com-510073.png")),
                                        const SizedBox(height: 10),
                                        const Expanded(
                                            child: Center(
                                          child: Text("Taxinet Luxury",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              )),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: GestureDetector(
                                onTap: () {
                                  Get.snackbar(
                                      "Hi 😛", "Taxinet Truck coming soon",
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 5),
                                      colorText: Colors.white,
                                      backgroundColor: primaryColor);
                                },
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: const BoxDecoration(
                                    color: pearl,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      children: [
                                        Expanded(
                                            child: Image.asset(
                                                "assets/images/pngaaa.com-1805551.png")),
                                        const SizedBox(height: 10),
                                        const Expanded(
                                            child: Center(
                                          child: Text("Taxinet Truck",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              )),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: GestureDetector(
                                onTap: () {
                                  Get.snackbar(
                                    "Hi 😛",
                                    "Taxinet Delivery coming soon",
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
                                    color: pearl,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      children: [
                                        Expanded(
                                            child: Image.asset(
                                                "assets/images/pngaaa.com-684094.png")),
                                        const SizedBox(height: 10),
                                        const Expanded(
                                            child: Center(
                                          child: Text("Taxinet Delivery",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              )),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: GestureDetector(
                                onTap: () {
                                  Get.snackbar(
                                      "Hi 😛", "Taxinet Bus coming soon",
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 5),
                                      colorText: Colors.white,
                                      backgroundColor: primaryColor);
                                },
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: const BoxDecoration(
                                    color: pearl,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      children: const [
                                        Expanded(
                                            child: Text("🚍️",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20))),
                                        SizedBox(height: 10),
                                        Expanded(
                                            child: Center(
                                          child: Text("Taxinet Bus",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              )),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: GestureDetector(
                                onTap: () {
                                  Get.snackbar(
                                    "Hi 😛",
                                    "Taxinet Tickets coming soon",
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
                                    color: pearl,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      children: const [
                                        // Expanded(
                                        //     child: Image.asset(
                                        //         "assets/images/ticket.png")),
                                        Expanded(
                                            child: Text("✈️",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20))),
                                        SizedBox(height: 10),
                                        Expanded(
                                            child: Center(
                                          child: Text("Taxinet Tickets",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              )),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget homeShimmer() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //  for profile image
          const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: ShimmerWidget.circular(width: 100, height: 100),
          ),
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  ShimmerWidget.rectangular(height: 16),
                  SizedBox(height: 16),
                  ShimmerWidget.rectangular(height: 16),
                ]),
          )
        ],
      ),
    );
  }
}

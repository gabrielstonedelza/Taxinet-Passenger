import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:taxinet/constants/app_colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:taxinet/passenger/home/schedule_ride.dart';

import '../constants/changethemebutton.dart';
import '../controllers/notifications/localnotification_manager.dart';
import '../g_controller/userController.dart';
import '../g_controller/walletcontroller.dart';
import '../passenger/home/pages/notifications.dart';

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
      Navigator.pop(context);
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
    super.initState();
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            fit: StackFit.loose,
            clipBehavior: Clip.hardEdge,
            children: [
              SizedBox(
                height: size.height * 1.2,
                width: MediaQuery.of(context).size.width,
                child: Container(
                    decoration: const BoxDecoration(
                      color: defaultBlack,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        userController.isLoading
                            ? Center(
                                child: CardSkeleton(
                                isCircularImage: true,
                                isBottomLinesActive: true,
                              ))
                            :
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
                                            return CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  userController.profileImage),
                                              radius: size.width * 0.14,
                                            );
                                          },
                                        ),
                                ),
                              ),
                        const SizedBox(height: 10),
                        const Center(
                            child: Text("Wallet",
                                style: TextStyle(fontWeight: FontWeight.bold,color: muted))),
                        const SizedBox(height: 10),
                        Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(child: GetBuilder<WalletController>(
                                      builder: (controller) {
                                    return Text(
                                        "GHS ${walletController.wallet}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25));
                                  })),
                                  IconButton(
                                      onPressed: () {
                                        showMaterialModalBottomSheet(
                                          context: context,
                                          // expand: true,
                                          isDismissible: true,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(
                                                          25.0))),
                                          bounce: true,
                                          builder: (context) => Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: SizedBox(
                                                height: 300,
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
                                                                cursorColor:
                                                                    primaryColor,
                                                                cursorRadius:
                                                                    const Radius
                                                                            .elliptical(
                                                                        10, 10),
                                                                cursorWidth: 10,
                                                                decoration: InputDecoration(
                                                                    labelText:
                                                                        "Enter amount",
                                                                    labelStyle:
                                                                        const TextStyle(
                                                                            color:
                                                                                secondaryColor),
                                                                    focusColor:
                                                                        primaryColor,
                                                                    fillColor:
                                                                        primaryColor,
                                                                    focusedBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(
                                                                            color:
                                                                                primaryColor,
                                                                            width:
                                                                                2),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                12)),
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(12))),
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
                                                            isPosting
                                                                ? const Center(
                                                                    child: CircularProgressIndicator
                                                                        .adaptive(
                                                                      strokeWidth:
                                                                          5,
                                                                      backgroundColor:
                                                                          primaryColor,
                                                                      valueColor: AlwaysStoppedAnimation<
                                                                              Color>(
                                                                          Colors
                                                                              .black),
                                                                    ),
                                                                  )
                                                                : RawMaterialButton(
                                                                    onPressed:
                                                                        () {
                                                                      _startPosting();
                                                                      setState(
                                                                          () {
                                                                        isPosting =
                                                                            true;
                                                                      });

                                                                      if (formKey
                                                                          .currentState!
                                                                          .validate()) {
                                                                        processLoadWallet();
                                                                      } else {
                                                                        return;
                                                                      }
                                                                    },
                                                                    // child: const Text("Send"),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8)),
                                                                    elevation:
                                                                        8,
                                                                    fillColor:
                                                                        primaryColor,
                                                                    splashColor:
                                                                        defaultColor,
                                                                    child:
                                                                        const Text(
                                                                      "Send",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20,
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
                                      icon:
                                          const Icon(Icons.edit, color: pearl))
                                ],
                              ),
                        const SizedBox(height: 10),
                      ],
                    )),
              ),
              Positioned(
                top: 250,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32)),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 550,
                    decoration: const BoxDecoration(color: primaryColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const ChangeThemeButtonWidget(),
                              const SizedBox(width:40),
                              Text(
                                "${greetingMessage()}, ${userController.username.capitalize}",
                                style: const TextStyle(
                                    color: defaultTextColor2,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        // const SizedBox(height: 10),
                        const Center(
                          child: Text(
                            "What do you want today?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: defaultTextColor2
                            ),
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
                                      canSchedule ?
                                      Get.to(() => const ScheduleRide()) : Get.snackbar("Sorry 😭", "your wallet is low,please load wallet.",
                                          duration: const Duration(seconds: 8),
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.red,
                                          colorText: defaultTextColor1);
                                    },
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: const BoxDecoration(
                                        color: secondaryColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Column(
                                          children: [
                                            Expanded(
                                                child: Image.asset(
                                                    "assets/images/taxinet_cab.png")),
                                            const Expanded(
                                                child: Center(
                                              child: Text(
                                                "Taxinet Ride",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
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
                                        color: secondaryColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Column(
                                          children: [
                                            Expanded(
                                                child: Image.asset(
                                                    "assets/images/pngaaa.com-510073.png")),
                                            const Expanded(
                                                child: Center(
                                              child: Text("Taxinet Luxury",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
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
                                        color: secondaryColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Column(
                                          children: [
                                            Expanded(
                                                child: Image.asset(
                                                    "assets/images/pngaaa.com-1805551.png")),
                                            const Expanded(
                                                child: Center(
                                              child: Text("Taxinet Truck",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
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
                                        color: secondaryColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Column(
                                          children: [
                                            Expanded(
                                                child: Image.asset(
                                                    "assets/images/pngaaa.com-684094.png")),
                                            const Expanded(
                                                child: Center(
                                              child: Text("Taxinet Delivery",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
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
                                        color: secondaryColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Column(
                                          children: [
                                            Expanded(
                                                child: Image.asset(
                                                    "assets/images/bus.png")),
                                            const Expanded(
                                                child: Center(
                                                  child: Text("Taxinet Bus",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15,
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
                                        color: secondaryColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Column(
                                          children: [
                                            Expanded(
                                                child: Image.asset(
                                                    "assets/images/ticket.png")),
                                            const Expanded(
                                                child: Center(
                                                  child: Text("Taxinet Tickets",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15,
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NewCardSkeleton extends StatelessWidget {
  const NewCardSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Skeleton(
          height: 120,
          width: 120,
        ),
      ],
    );
  }
}

class Skeleton extends StatelessWidget {
  const Skeleton({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.04),
            borderRadius: const BorderRadius.all(Radius.circular(16))));
  }
}

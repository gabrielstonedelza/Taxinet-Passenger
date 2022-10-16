import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:taxinet/g_controller/userController.dart';
import 'package:flip_card/flip_card.dart';
import 'package:taxinet/passenger/home/pages/editProfile.dart';
import '../../../constants/app_colors.dart';
import '../../../views/login/loginview.dart';
import 'package:http/http.dart' as http;

import '../../../views/login/newlogin.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final storage = GetStorage();

  double hPadding = 40;
  bool isOpened = false;

  PanelController panelController = PanelController();

  UserController userController = Get.find();

  logoutUser() async {
    storage.remove("username");
    Get.offAll(() => const NewLogin());
    const logoutUrl = "https://taxinetghana.xyz/auth/token/logout";
    final myLink = Uri.parse(logoutUrl);
    http.Response response = await http.post(myLink, headers: {
      'Accept': 'application/json',
      "Authorization": "Token ${storage.read("userToken")}"
    });

    if (response.statusCode == 200) {
      Get.snackbar("Success", "You were logged out",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: snackColor);
      storage.remove("username");
      storage.remove("userToken");
      storage.remove("user_type");
      storage.remove("verified");
      storage.remove("viewedIntro");
      Get.offAll(() => const NewLogin());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            FractionallySizedBox(
                alignment: Alignment.topCenter,
                heightFactor: 0.7,
                child: userController.profileImageUpload != null
                    ? GetBuilder<UserController>(
                        builder: (controller) {
                          return Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(
                                        userController.profileImageUpload!),
                                    fit: BoxFit.cover)),
                          );
                        },
                      )
                    : GetBuilder<UserController>(
                        builder: (controller) {
                          return Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        userController.profileImage),
                                    fit: BoxFit.cover)),
                          );
                        },
                      )),
            FractionallySizedBox(
              alignment: Alignment.bottomCenter,
              heightFactor: 0.3,
              child: Container(
                color: Colors.white,
              ),
            ),
            SlidingUpPanel(
              controller: panelController,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32), topRight: Radius.circular(32)),
              minHeight: MediaQuery.of(context).size.height * 0.3,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
              body: GestureDetector(
                onTap: () => panelController.close(),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
              onPanelSlide: (value) {
                if (value >= 0.2) {
                  if (!isOpened) {
                    setState(() {
                      isOpened = true;
                    });
                  }
                }
              },
              onPanelClosed: () {
                setState(() {
                  isOpened = false;
                });
              },
              panelBuilder: (ScrollController controller) {
                return SingleChildScrollView(
                  controller: controller,
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: hPadding),
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showMaterialModalBottomSheet(
                                          backgroundColor: secondaryColor,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10))),
                                          bounce: true,
                                          context: context,
                                          builder: (context) =>
                                              SingleChildScrollView(
                                            controller:
                                                ModalScrollController.of(
                                                    context),
                                            child: SizedBox(
                                              height: 200,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(18.0),
                                                child: ListView(
                                                  children: [
                                                    const Center(
                                                      child: Text(
                                                        "Logout",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              RawMaterialButton(
                                                            onPressed: () {
                                                              logoutUser();
                                                            },
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12)),
                                                            elevation: 8,
                                                            fillColor:
                                                                Colors.red,
                                                            splashColor:
                                                                defaultColor,
                                                            child:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                "Yes",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15,
                                                                    color:
                                                                        defaultTextColor1),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child:
                                                              RawMaterialButton(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12)),
                                                            elevation: 8,
                                                            fillColor:
                                                                primaryColor,
                                                            splashColor:
                                                                defaultColor,
                                                            child:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                "No",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15,
                                                                    color:
                                                                        defaultTextColor1),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Image.asset(
                                        "assets/images/power-off.png",
                                        width: 30,
                                        height: 30,
                                        color: Colors.red,
                                      ),
                                    ),
                                    GetBuilder<UserController>(
                                        builder: (controller) {
                                      return Text(
                                        controller.fullName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      );
                                    }),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // GetBuilder<UserController>(
                                //     builder: (controller) {
                                //   return Text(
                                //     controller.username,
                                //     style: const TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 15,
                                //         color: Colors.grey),
                                //   );
                                // }),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Icon(FontAwesomeIcons.envelope,
                                          color: Colors.grey),
                                      GetBuilder<UserController>(
                                        builder: (controller) {
                                          return Text(controller.email);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.phone,
                                      color: Colors.grey,
                                    ),
                                    GetBuilder<UserController>(
                                      builder: (controller) {
                                        return Text(controller.phoneNumber);
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: !isOpened,
                                  child: Expanded(
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        panelController.open();
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      elevation: 8,
                                      fillColor: primaryColor,
                                      splashColor: defaultColor,
                                      child: const Text(
                                        "More",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: defaultTextColor1),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: !isOpened,
                                  child: const SizedBox(
                                    width: 10,
                                  ),
                                ),
                                Expanded(
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      Get.to(() => const EditProfile());
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    elevation: 8,
                                    fillColor: primaryColor,
                                    splashColor: defaultColor,
                                    child: const Icon(
                                      FontAwesomeIcons.edit,
                                      color: defaultTextColor1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            userController.frontGhanaCard != "" &&
                                    userController.backGhanaCard != ""
                                ? const Center(
                                    child: Text(
                                      "Ghana Card",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : const Text(""),
                          ],
                        ),
                      ),
                      userController.frontGhanaCard != "" &&
                              userController.backGhanaCard != ""
                          ? GetBuilder<UserController>(
                              builder: (controller) {
                                return FlipCard(
                                  fill: Fill
                                      .fillBack, // Fill the back side of the card to make in the same size as
                                  direction:
                                      FlipDirection.HORIZONTAL, // default
                                  front: userController.frontGhanaCard != ""
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Container(
                                            height: 200,
                                            width: 320,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        controller
                                                            .frontGhanaCard),
                                                    fit: BoxFit.cover)),
                                          ),
                                        )
                                      : const Text(
                                          "You haven't uploaded your Ghana Card yet"),
                                  back: userController.backGhanaCard != ""
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Container(
                                            height: 200,
                                            width: 320,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        controller
                                                            .backGhanaCard),
                                                    fit: BoxFit.cover)),
                                          ),
                                        )
                                      : const Text(
                                          "You haven't uploaded your Ghana Card yet"),
                                );
                              },
                            )
                          : userController.frontGhanaCard != "" &&
                                  userController.backGhanaCard != ""
                              ? const Center(
                                  child: Text("Loading your GH Card"),
                                )
                              : Container(),
                      const SizedBox(
                        height: 10,
                      ),
                      userController.frontGhanaCard != "" &&
                              userController.backGhanaCard != ""
                          ? const Center(
                              child: Text(
                                "Tap to flip card",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 18.0, right: 18.0),
                            child: Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(FontAwesomeIcons.user),
                                ),
                                Text(
                                  "Referral: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          userController.referral != ""
                              ? GetBuilder<UserController>(
                                  builder: (controller) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 18.0, left: 18.0),
                                      child: Text(
                                        controller.referral,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  },
                                )
                              : const Padding(
                                  padding: EdgeInsets.only(top: 18.0),
                                  child: Text(
                                    "No referral added",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GetBuilder<UserController>(
                        builder: (controller) {
                          if (controller.referral != "") {
                            return Image.asset(
                              "assets/images/check.png",
                              width: 50,
                              height: 50,
                            );
                          } else {
                            return const Center(
                              child: Text("Not Verified"),
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

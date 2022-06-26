import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:taxinet/g_controller/userController.dart';
import 'package:flip_card/flip_card.dart';
import 'package:taxinet/passenger/home/pages/editProfile.dart';
import '../../../constants/app_colors.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  double hPadding = 40;
  PanelController panelController = PanelController();
  FlipCardController? _controller;
  bool isOpened = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = FlipCardController();
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
              child: Get.find<UserController>().profileImage != "" ? GetBuilder<UserController>(
                builder: (controller) {
                  return Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(controller.profileImage),
                            fit: BoxFit.cover)),
                  );
                },
              ):const Icon(
                FontAwesomeIcons.user,size: 20,
              )
            ),
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
                onTap: ()=> panelController.close(),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
              onPanelSlide: (value){
                if(value >= 0.2){
                  if(!isOpened){
                    setState(() {
                      isOpened = true;
                    });
                  }
                }
              },
              onPanelClosed: (){
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
                                GetBuilder<UserController>(
                                    builder: (controller) {
                                  return Text(
                                    controller.fullName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  );
                                }),
                                const SizedBox(
                                  height: 10,
                                ),
                                GetBuilder<UserController>(
                                    builder: (controller) {
                                  return Text(
                                    controller.username,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.grey),
                                  );
                                }),
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
                                  visible:!isOpened,
                                  child: Expanded(
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        panelController.open();
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8)),
                                      elevation: 8,
                                      child: const Text(
                                        "More",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: defaultTextColor1),
                                      ),
                                      fillColor: primaryColor,
                                      splashColor: defaultColor,
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
                                      Get.to(()=> EditProfile(username:Get.find<UserController>().username,email:Get.find<UserController>().email,phone:Get.find<UserController>().phoneNumber,profilePic:Get.find<UserController>().profileImage));
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    elevation: 8,
                                    child: const Icon(
                                      FontAwesomeIcons.edit,
                                      color: defaultTextColor1,
                                    ),
                                    fillColor: primaryColor,
                                    splashColor: defaultColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Get.find<UserController>().frontGhanaCard != "" && Get.find<UserController>().backGhanaCard != "" ? const Center(
                              child: Text(
                                "Ghana Card",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ):Text(""),
                          ],
                        ),
                      ),
                      Get.find<UserController>().frontGhanaCard != "" && Get.find<UserController>().backGhanaCard != "" ? GetBuilder<UserController>(
                        builder: (controller) {
                          return FlipCard(
                            fill: Fill
                                .fillBack, // Fill the back side of the card to make in the same size as
                            direction:
                            FlipDirection.HORIZONTAL, // default
                            front: Get.find<UserController>().frontGhanaCard != "" ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 200,
                                width: 320,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            controller.frontGhanaCard),
                                        fit: BoxFit.cover)),
                              ),
                            ): const Text("You haven't uploaded your Ghana Card yet"),
                            back: Get.find<UserController>().backGhanaCard != "" ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 200,
                                width: 320,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            controller.backGhanaCard),
                                        fit: BoxFit.cover)),
                              ),
                            ):const Text("You haven't uploaded your Ghana Card yet"),
                          );
                        },
                      ): Get.find<UserController>().frontGhanaCard != "" && Get.find<UserController>().backGhanaCard != "" ? const Center(
                        child: Text("Loading your GH Card"),
                      ) : Container(),
                      const SizedBox(
                        height: 10,
                      ),
                      Get.find<UserController>().frontGhanaCard != "" && Get.find<UserController>().backGhanaCard != "" ? const Center(
                        child: Text(
                          "Tap to flip card",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ):Container(),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0,right: 18.0),
                            child: Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(FontAwesomeIcons.user),
                                ),
                                Text("Referral: ",style: TextStyle(fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          Get.find<UserController>().referral != "" ? GetBuilder<UserController>(builder: (controller){
                            return Padding(
                              padding: const EdgeInsets.only(top: 18.0,left: 18.0),
                              child: Text(controller.referral,style: const TextStyle(fontWeight: FontWeight.bold),),
                            );
                          },) : const Padding(
                            padding: EdgeInsets.only(top: 18.0),
                            child: Text("No referral added",style: TextStyle(fontWeight: FontWeight.bold),),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GetBuilder<UserController>(builder: (controller){
                        if(controller.referral != "") {
                          return Image.asset("assets/images/check.png",width: 50,height: 50,);
                        }
                        else{
                          return const Center(child: Text("Not Verified"),);
                        }
                      },),
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

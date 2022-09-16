import "package:flutter/material.dart";
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:taxinet/passenger/home/pages/verifiedprofile.dart';
import 'package:taxinet/views/login/newlogin.dart';
import '../../../constants/app_colors.dart';
import '../../../g_controller/userController.dart';
import "package:get/get.dart";

import '../../../views/login/loginview.dart';
import 'completeset.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final storage = GetStorage();
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
      storage.remove("userid");
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: primaryColor,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: (){
                  Get.to(()=> const VerifiedProfile());
                },
                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        userController.profileImageUpload != null
                            ? GetBuilder<UserController>(
                          builder: (controller) {
                            return Container(
                              width:50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
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
                              width:50,
                              height: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          userController.profileImage),
                                      fit: BoxFit.cover)),
                            );
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GetBuilder<UserController>(
                                builder: (controller) {
                                  return Text(
                                    controller.fullName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  );
                                }),
                            const SizedBox(height: 10),
                            GetBuilder<UserController>(
                              builder: (controller) {
                                return Text(controller.email,style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12),);
                              },
                            )
                          ],
                        ),
                        const Icon(Icons.arrow_forward_ios,color: Colors.grey)
                      ],
                    ),
                  )
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Get.to(() => const CompleteSetUp());
                },
                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.person_outlined,color: muted),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Verify Identity",style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                Text("Complete your account verification",style:TextStyle(color: muted,fontSize: 12)),
                              ],
                            ),
                            const Icon(Icons.arrow_forward_ios,color: Colors.grey,size: 15,)
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        RawMaterialButton(
                          onPressed: () {
                            Get.defaultDialog(
                                buttonColor: primaryColor,
                                middleTextStyle: const TextStyle(fontSize: 12),
                                titleStyle: const TextStyle(fontSize: 15),
                                title: "Are you sure you want to logout?",
                                content: Row(
                                  children: [
                                    Expanded(
                                        child: RawMaterialButton(
                                          onPressed:
                                              () {
                                            logoutUser();
                                          },
                                          // child: const Text("Send"),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(8)),
                                          elevation:
                                          8,
                                          child:
                                          const Text(
                                            "Yes",
                                            style: TextStyle(
                                                fontWeight: FontWeight
                                                    .bold,
                                                fontSize:
                                                20,
                                                color:
                                                defaultTextColor1),
                                          ),
                                          fillColor:
                                          Colors.red,
                                          splashColor:
                                          defaultColor,
                                        )),
                                    const SizedBox(width: 20),
                                    Expanded(
                                        child: RawMaterialButton(
                                          onPressed:
                                              () {
                                            Get.back();
                                          },
                                          // child: const Text("Send"),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(8)),
                                          elevation:
                                          8,
                                          child:
                                          const Text(
                                            "No",
                                            style: TextStyle(
                                                fontWeight: FontWeight
                                                    .bold,
                                                fontSize:
                                                20,
                                                color:
                                                defaultTextColor1),
                                          ),
                                          fillColor:
                                          primaryColor,
                                          splashColor:
                                          defaultColor,
                                        )),
                                  ],
                                )
                            );
                          },
                          // child: const Text("Send"),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  8)),
                          elevation: 8,
                          fillColor:
                          Colors.red,
                          splashColor:
                          defaultColor,
                          child: const Text(
                            "Logout",
                            style: TextStyle(
                                fontWeight:
                                FontWeight
                                    .bold,
                                fontSize: 15,
                                color:
                                defaultTextColor1),
                          ),
                        )

                      ],
                    ),
                  )
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}

import "package:flutter/material.dart";
import "package:get/get.dart";
import '../../../constants/app_colors.dart';
import '../../../g_controller/userController.dart';
import '../../../widgets/shimmers/shimmerwidget.dart';

class VerifiedProfile extends StatefulWidget {
  const VerifiedProfile({Key? key}) : super(key: key);

  @override
  State<VerifiedProfile> createState() => _VerifiedProfileState();
}

class _VerifiedProfileState extends State<VerifiedProfile> {
  UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.transparent,
        elevation:0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon:const Icon(Icons.arrow_back,color:defaultTextColor2)
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            const Center(
              child: Text("My Profile",style: TextStyle(fontWeight: FontWeight.bold))
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: (){
                Get.defaultDialog(
                    buttonColor: primaryColor,
                    title: "Select",
                    content: Row(
                      children: [
                        Expanded(
                            child: Column(
                              children: [
                                GestureDetector(
                                  child: Image.asset("assets/images/image-gallery.png",width: 50,height: 50,),
                                  onTap: () {
                                    Get.find<UserController>().getFromGalleryForProfilePic();
                                    Get.back();
                                  },
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Gallery",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )
                              ],
                            )),
                        Expanded(
                            child: Column(
                              children: [
                                GestureDetector(
                                  child: Image.asset("assets/images/photo-camera-interface-symbol-for-button.png",width: 50,height: 50,),
                                  onTap: () {
                                    Get.find<UserController>().getFromCameraForProfilePic();
                                    Get.back();
                                  },
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Camera",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )
                              ],
                            )),
                      ],
                    )
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GetBuilder<UserController>(
                    builder: (controller) {
                      return userController.isLoading
                          ? const ShimmerWidget.circular(
                          width: 100, height: 100)
                          : userController.profileImage == ""
                          ? const CircleAvatar(
                        backgroundImage: AssetImage(
                            "assets/images/user.png"),
                        radius: 50,
                      )
                          : Container(
                        width:100,
                        height: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    userController.profileImage),
                                fit: BoxFit.cover)),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            ListTile(
              title: const Padding(
                padding: EdgeInsets.only(bottom:8.0),
                child: Text("Full Name",style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              subtitle: GetBuilder<UserController>(
                  builder: (controller) {
                    return Text(
                      controller.fullName,
                      style: const TextStyle(

                          fontSize: 12),
                    );
                  }),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom:8.0),
                child: Row(
                  children: [
                    const Text("Email",style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    Image.asset("assets/images/verified.png",width: 20,height: 20,)
                  ],
                ),
              ),
              subtitle: GetBuilder<UserController>(
                  builder: (controller) {
                    return Text(
                      controller.email,
                      style: const TextStyle(

                          fontSize: 12),
                    );
                  }),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom:8.0),
                child: Row(
                  children: [
                    const Text("Phone Number",style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    Image.asset("assets/images/verified.png",width: 20,height: 20,)
                  ],
                ),
              ),
              subtitle: GetBuilder<UserController>(
                  builder: (controller) {
                    return Text(
                      controller.phoneNumber,
                      style: const TextStyle(

                          fontSize: 12),
                    );
                  }),
            ),
            const Divider(),
            const SizedBox(height: 10),
            ListTile(
              title: const Padding(
                padding: EdgeInsets.only(bottom:8.0),
                child: Text("Promoter",style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              subtitle: GetBuilder<UserController>(
                  builder: (controller) {
                    return Text(
                      controller.promoterName,
                      style: const TextStyle(

                          fontSize: 12),
                    );
                  }),
            ),
            const Divider(),
            const SizedBox(height: 10),
          ],
        ),
      )
    );
  }
}

import 'dart:math';

import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:get/get.dart";
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../constants/app_colors.dart';
import '../../../g_controller/userController.dart';
import '../../../sendsms.dart';


class CompleteSetUp extends StatefulWidget {
  const CompleteSetUp({Key? key}) : super(key: key);

  @override
  State<CompleteSetUp> createState() => _CompleteSetUpState();
}

class _CompleteSetUpState extends State<CompleteSetUp> {
  UserController userController = Get.find();
  final _formKey = GlobalKey<FormState>();
  TextEditingController referralController = TextEditingController();
  late final TextEditingController _oTPController = TextEditingController();
  bool isPosting = false;
  bool hasOTP = false;
  bool sentOTP = false;
  late int oTP = 0;
  bool userExists = false;
  bool isTaxinet = false;
  final SendSmsController sendSms = SendSmsController();


  generate5digit(){
    var rng = Random();
    var rand = rng.nextInt(90000) + 10000;
    oTP = rand.toInt();
  }

  @override
  void initState() {
    super.initState();
    generate5digit();
  }

  @override
  Widget build(BuildContext context) {

    Size size  = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Setup",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color:Colors.black)),
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
        child: userController.isUpdating ? const Center(
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 5,
            backgroundColor: primaryColor,
          )
        ) : ListView(
          children: [
            const SizedBox(height: 20),
            const Center(child: Text("You need to upload your Ghana and add a referral from Taxinet  to complete your account verification")),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: (){
                userController.frontGhanaCard == "" ? Get.defaultDialog(
                    buttonColor: primaryColor,
                    middleTextStyle: const TextStyle(fontSize: 12),
                    titleStyle: const TextStyle(fontSize: 15),
                    title: "Select front side of card",
                    content: Row(
                      children: [
                        Expanded(
                            child: Column(
                              children: [
                                GestureDetector(
                                  child: Image.asset("assets/images/image-gallery.png",width: 50,height: 50,),
                                  onTap: () {
                                    Get.find<UserController>().getFromGalleryForFrontCard();
                                    Get.back();
                                  },
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Gallery",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                )
                              ],
                            )),
                        Expanded(
                            child: Column(
                              children: [
                                GestureDetector(
                                  child: Image.asset("assets/images/photo-camera-interface-symbol-for-button.png",width: 50,height: 50,),
                                  onTap: () {
                                    Get.find<UserController>().getFromCameraForFrontCard();
                                    Get.back();
                                  },
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Camera",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                )
                              ],
                            )),
                      ],
                    )
                ) : Get.defaultDialog(
                    buttonColor: primaryColor,
                    middleTextStyle: const TextStyle(fontSize: 12),
                    titleStyle: const TextStyle(fontSize: 15),
                    title: "😀 Success",
                    content: const Center(
                      child: Text("You have already uploaded your card.")
                    )
                );
              },
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset("assets/images/id-card.png",width: 30,height: 30,),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          Row(
                            children: const [
                              Text("Upload front Ghana Card"),
                              SizedBox(width: 10),
                              Icon(Icons.upload,color:muted)
                            ],
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("We will be matching your details on your card with the one you have already provided",style: TextStyle(color:muted,fontSize: 12)),
                    ),
                    const SizedBox(height: 10),
                  ],
                )
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                userController.backGhanaCard == "" ? Get.defaultDialog(
                  middleTextStyle: const TextStyle(fontSize: 12),
                    titleStyle: const TextStyle(fontSize: 15),
                    buttonColor: primaryColor,
                    title: "Select backside of card",
                    content: Row(
                      children: [
                        Expanded(
                            child: Column(
                              children: [
                                GestureDetector(
                                  child: Image.asset("assets/images/image-gallery.png",width: 50,height: 50,),
                                  onTap: () {
                                    Get.find<UserController>().getFromGalleryForBackCard();
                                    Get.back();
                                  },
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Gallery",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                )
                              ],
                            )),
                        Expanded(
                            child: Column(
                              children: [
                                GestureDetector(
                                  child: Image.asset("assets/images/photo-camera-interface-symbol-for-button.png",width: 50,height: 50,),
                                  onTap: () {
                                    Get.find<UserController>().getFromCameraForBackCard();
                                    Get.back();
                                  },
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Camera",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                )
                              ],
                            )),
                      ],
                    )
                ) :
                Get.defaultDialog(
                    buttonColor: primaryColor,
                    middleTextStyle: const TextStyle(fontSize: 12),
                    titleStyle: const TextStyle(fontSize: 15),
                    title: "😀 Success",
                    content: const Center(
                        child: Text("You have already uploaded your card")
                    )
                );
              },
              child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/images/id-card.png",width: 30,height: 30,),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:[
                            Row(
                              children: const [
                                Text("Upload backside of Ghana Card"),
                                SizedBox(width: 10),
                                Icon(Icons.upload,color:muted)
                              ],
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("We will be matching your details on your card with the one you have already provided",style: TextStyle(color:muted,fontSize: 12)),
                      ),
                      const SizedBox(height: 10),
                    ],
                  )
              ),
            ),
            const SizedBox(height: 20),
            userController.referral == "" ? Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text("You need at least one person from Taxinet to refer you.")
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                     !sentOTP ? Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: TextFormField(
                          onChanged: (value){
                            if(value.length == 10 && userController.phoneNumbers.contains(value)){
                              Get.snackbar("Success", "number is in the system",
                                  colorText: defaultTextColor1,
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: snackColor);
                              setState(() {
                                sentOTP = true;
                                String telnum = referralController.text;
                                telnum = telnum.replaceFirst("0", '+233');
                                sendSms.sendMySms(telnum, "Taxinet",
                                    "Your code $oTP");
                              });
                            }
                            if(value.length == 10 && !userController.phoneNumbers.contains(value)){
                              Get.snackbar("Number Error", "number is not in the system.Please enter a valid number",
                                  colorText: defaultTextColor1,
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 5)
                              );
                            }
                          },
                          controller: referralController,
                          cursorColor: defaultTextColor2,
                          style: const TextStyle(color: defaultTextColor2),
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.person,color: defaultTextColor2,),
                            hintText: "Enter referral number",
                            hintStyle: const TextStyle(color: defaultTextColor2,),
                              focusColor: primaryColor,
                              fillColor: primaryColor,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: defaultTextColor2, width: 2),
                                  borderRadius: BorderRadius.circular(12))

                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if(value!.isEmpty){
                              return "Please enter customer number";
                            }
                          },
                        ),
                      ) : Container(),
                      const SizedBox(height: 20),
                      sentOTP ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onChanged: (value){
                                if(value.length == 5 && int.parse(value) == oTP){
                                  setState(() {
                                    hasOTP = true;
                                    sentOTP = false;
                                  });
                                  userController.updatePassengerProfile(referralController.text.trim());
                                }
                                else if(value.length == 5 && int.parse(value) == oTP){
                                  Get.snackbar("OTP Error", "You entered an invalid code.",
                                      colorText: defaultTextColor1,
                                      snackPosition: SnackPosition.TOP,
                                      backgroundColor: Colors.red);
                                }
                              },
                              controller: _oTPController,
                              cursorColor: defaultTextColor2,
                              style: const TextStyle(color: defaultTextColor2),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter OTP",
                                hintStyle: const TextStyle(color: defaultTextColor2,),
                                  focusColor: primaryColor,
                                  fillColor: primaryColor,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: defaultTextColor2, width: 2),
                                      borderRadius: BorderRadius.circular(12))
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          const Text("A message with your OTP has been sent to the number provider"),
                          const SizedBox(height: 10,),
                          GestureDetector(
                              onTap: (){
                                String telnum = referralController.text;
                                telnum = telnum.replaceFirst("0", '+233');
                                sendSms.sendMySms(telnum, "Taxinet",
                                    "Your code $oTP");
                                Get.snackbar("Success", "OTP was resent",
                                    colorText: defaultTextColor1,
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: snackColor);
                              },
                              child: const Text("Resend OTP",style: TextStyle(fontWeight: FontWeight.bold,color: defaultTextColor2),)
                          ),
                          const SizedBox(height: 20,),
                        ],
                      ) : Container(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ) : Container(),
          ],
        ),
      ),
    );
  }
}

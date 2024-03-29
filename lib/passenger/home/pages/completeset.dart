import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:taxinet/passenger/home/pages/verifynumber.dart';
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
  TextEditingController pin1Controller = TextEditingController();
  TextEditingController pin2Controller = TextEditingController();
  TextEditingController pin3Controller = TextEditingController();
  TextEditingController pin4Controller = TextEditingController();
  TextEditingController pin5Controller = TextEditingController();

  late final TextEditingController _oTPController = TextEditingController();
  bool isPosting = false;
  bool hasOTP = false;
  bool sentOTP = false;
  late int oTP = 0;
  bool userExists = false;
  bool isTaxinet = false;
  final SendSmsController sendSms = SendSmsController();
  final storage = GetStorage();
  late String username = "";
  late String uToken = "";
  late String userid = "";
  bool isSuccess = false;
  


  generate5digit(){
    var rng = Random();
    var rand = rng.nextInt(90000) + 10000;
    oTP = rand.toInt();
  }
  updatePassengerProfile() async {
    const updateUrl = "https://taxinetghana.xyz/update_passenger_profile/";
    final myUrl = Uri.parse(updateUrl);
    http.Response response = await http.put(
      myUrl,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $uToken"
      },
      body: {
        "referral": referralController.text
      },
    );
    if (response.statusCode == 200) {
      Get.snackbar("Hurray 😀", "referral added successfully,please wait for at least a minute for this to take effect",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          colorText: defaultTextColor1);
      setState(() {
        referralController.text = "";
        isSuccess = true;
      });
    } else {
      Get.snackbar("Sorry 😢", "something went wrong,please try again later",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: defaultTextColor1);
    }
  }

  @override
  void initState() {
    super.initState();
    generate5digit();
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    if (storage.read("userid") != null) {
      userid = storage.read("userid");
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: primaryColor,
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
        child: userController.referral == "" ? ListView(
          children: [
            const SizedBox(height: 20),
            Card(
              elevation:12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(child: Text("You need to  add a referral from Taxinet  to complete your account verification")),
                )),

            const SizedBox(height: 20),
            userController.referral == "" ? Column(
              children: [
                const SizedBox(height: 20),
                !isSuccess ?  Form(
                  key: _formKey,
                  child: Column(
                    children: [
                     !sentOTP ? Card(
                       elevation: 12,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10)
                       ),
                       child: Padding(
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
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.person,color: defaultTextColor2,),
                              hintText: "Enter referral number",
                              hintStyle: TextStyle(color: defaultTextColor2,),
                                focusColor: primaryColor,
                                fillColor: primaryColor,

                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if(value!.isEmpty){
                                return "Please enter customer number";
                              }
                            },
                          ),
                        ),
                     ) : Container(),
                      const SizedBox(height: 10),
                      sentOTP ? SlideInUp(
                        animate: true,
                        child: Card(
                          elevation: 12,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
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
                                        updatePassengerProfile();
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
                                myPinBox(),
                                const SizedBox(height: 10,),
                              ],
                            ),
                          ),
                        ),
                      ) : Container(),
                      // sentOTP ? SlideInUp(animate:true,child: myPinBox()) : Container()
                    ],
                  ),
                ): Container(),
                const SizedBox(height: 20),
              ],
            ) : Container(),
          ],
        ): Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(
              child: Text("You have already verified your account",style: TextStyle(fontWeight: FontWeight.bold,))
            )
          ],
        ),
      ),
    );
  }

  Widget myPinBox(){

    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 68,
            width: 64,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[500]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Center(
                child: TextFormField(
                  controller: pin1Controller,
                  onChanged: (value){
                    if(value.length == 1 && value == oTP.toString()[0]){
                      FocusScope.of(context).nextFocus();
                    }
                    else{
                      Get.snackbar("Number Error", "invalid number",
                          duration: const Duration(seconds: 5),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: defaultTextColor1);
                    }
                  },
                  autofocus: true,
                  style: Theme.of(context).textTheme.headline6,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [LengthLimitingTextInputFormatter(1),FilteringTextInputFormatter.digitsOnly],
                  // controller: otpController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: defaultTextColor1,),
                  ),
                  cursorColor: defaultTextColor1,
                ),
              ),
            ),

          ),
          SizedBox(
            height: 68,
            width: 64,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[500]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Center(
                child: TextFormField(
                  controller: pin2Controller,
                  onChanged: (value){
                    if(value.length == 1 && value == oTP.toString()[1]){
                      FocusScope.of(context).nextFocus();
                    }
                    else{
                      Get.snackbar("Number Error", "invalid number",
                          duration: const Duration(seconds: 5),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: defaultTextColor1);
                    }
                  },
                  style: Theme.of(context).textTheme.headline6,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [LengthLimitingTextInputFormatter(1),FilteringTextInputFormatter.digitsOnly],
                  // controller: otpController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: defaultTextColor1,),
                  ),
                  cursorColor: defaultTextColor1,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 68,
            width: 64,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[500]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Center(
                child: TextFormField(
                  controller: pin3Controller,
                  onChanged: (value){
                    if(value.length == 1 && value == oTP.toString()[2]){
                      FocusScope.of(context).nextFocus();
                    }
                    else{
                      Get.snackbar("Number Error", "invalid number",
                          duration: const Duration(seconds: 5),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: defaultTextColor1);
                    }
                  },
                  style: Theme.of(context).textTheme.headline6,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [LengthLimitingTextInputFormatter(1),FilteringTextInputFormatter.digitsOnly],
                  // controller: otpController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: defaultTextColor1,),
                  ),
                  cursorColor: defaultTextColor1,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 68,
            width: 64,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[500]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Center(
                child: TextFormField(
                  controller: pin4Controller,
                  onChanged: (value){
                    if(value.length == 1 && value == oTP.toString()[3]){
                      FocusScope.of(context).nextFocus();
                    }
                    else{
                      Get.snackbar("Number Error", "invalid number",
                          duration: const Duration(seconds: 5),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: defaultTextColor1);
                    }
                  },
                  style: Theme.of(context).textTheme.headline6,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [LengthLimitingTextInputFormatter(1),FilteringTextInputFormatter.digitsOnly],
                  // controller: otpController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: defaultTextColor1,),
                  ),
                  cursorColor: defaultTextColor1,
                ),
              ),
            ),

          ),
          SizedBox(
            height: 68,
            width: 64,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[500]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Center(
                child: TextFormField(
                  controller: pin5Controller,
                  onChanged: (value){
                    if(value.length == 1 && value == oTP.toString()[4]){
                      // FocusScope.of(context).nextFocus();
                      setState(() {
                        hasOTP = true;
                        sentOTP = false;
                      });
                      updatePassengerProfile();
                    }
                    else{
                      Get.snackbar("Number Error", "invalid number",
                          duration: const Duration(seconds: 5),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: defaultTextColor1);
                    }
                  },
                  style: Theme.of(context).textTheme.headline6,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [LengthLimitingTextInputFormatter(1),FilteringTextInputFormatter.digitsOnly],
                  // controller: otpController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: defaultTextColor1,),
                  ),
                  cursorColor: defaultTextColor1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

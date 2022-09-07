import 'dart:ui';
import 'package:dio/dio.dart';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:taxinet/g_controller/userController.dart';
import '../../../constants/app_colors.dart';


class EditProfile extends StatefulWidget {

  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  UserController userController = Get.find();

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _nameOnGCardController;
  late final TextEditingController _nextOfKinController;
  late final TextEditingController _nextOfKinPhoneNumberController;
  late final TextEditingController _referralController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _nameOnGCardFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _nextOfKinFocusNode = FocusNode();
  final FocusNode _nextOfKinPhoneNumberFocusNode = FocusNode();
  final FocusNode _referralFocusNode = FocusNode();
  var dio = Dio();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usernameController = TextEditingController(text:userController.username);
    _fullNameController = TextEditingController(text:userController.fullName);
    _nameOnGCardController = TextEditingController(text: userController.nameOnGhanaCard);
    _nextOfKinController = TextEditingController(text: userController.nextOfKin);
    _nextOfKinPhoneNumberController = TextEditingController(text: userController.nextOfKinPhoneNumber);
    _referralController = TextEditingController(text: userController.referral);
    _phoneController = TextEditingController(text: userController.phoneNumber);
    _emailController = TextEditingController(text: userController.email);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    _nameOnGCardController.dispose();
    _nextOfKinController.dispose();
    _nextOfKinPhoneNumberController.dispose();
    _referralController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: (){
                Get.back();
              },
                child: const Padding(
                  padding: EdgeInsets.only(left: 18.0),
                  child: Text("Cancel",),
                )
            ),
            const Text("Update Profile"),
            GestureDetector(
              onTap: (){
                if(_nameOnGCardController.text != _fullNameController.text){
                  Get.snackbar("Sorry",
                      "the name of your Ghana card should match that of your full name",
                  snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.red,colorText: defaultTextColor1,duration: const Duration(seconds: 6));
                }
                if(_formKey.currentState!.validate()){
                  // userController.updateProfileDetails(_usernameController.text.trim(),_emailController.text.trim(),_fullNameController.text.trim(),_phoneController.text.trim());
                  // userController.updatePassengerProfile(_nameOnGCardController.text.trim(), _nextOfKinController.text.trim(), _nextOfKinPhoneNumberController.text.trim(), _referralController.text.trim());
                  if(userController.isUpdating){
                    Get.defaultDialog(
                        title: "",
                        radius: 20,
                        backgroundColor: Colors.black54,
                        barrierDismissible: false,
                        content: Row(
                          children: const [
                            Expanded(child: Center(child: CircularProgressIndicator.adaptive(
                              strokeWidth: 5,
                              backgroundColor: primaryColor,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                            ))),
                            Expanded(child: Text("Processing",style: TextStyle(color: Colors.white),))
                          ],
                        )
                    );
                  }
                  Get.back();
                }
              },
                child: const Text("Done",style: TextStyle(color: primaryColor),)
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                Center(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: userController.profileImageUpload != null ? GetBuilder<UserController>(builder: (controller){
                      return CircleAvatar(
                        backgroundImage: FileImage(userController.profileImageUpload!),
                        radius: size.width * 0.16,
                      );
                    },
                    ) : GetBuilder<UserController>(builder: (controller){
                      return CircleAvatar(
                        backgroundImage: NetworkImage(userController.profileImage),
                        radius: size.width * 0.16,
                      );
                    },
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * 0.10,
                  left: size.width * 0.58,
                  child: Container(
                    height: size.width * 0.1,
                    width: size.width * 0.1,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                        border:
                        Border.all(color: defaultTextColor1, width: 2)),
                    child: IconButton(
                      icon: const Icon(Icons.edit,color: defaultTextColor1,),
                      onPressed: (){
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
                        // Get.back();
                      },
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height:15,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 38.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      focusNode: _usernameFocusNode,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.person,
                            color: defaultTextColor1,
                          ),
                          hintText: "Username",
                          hintStyle: TextStyle(color: defaultTextColor1)),
                      cursorColor: defaultTextColor1,
                      style: const TextStyle(color: defaultTextColor1),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter username";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _fullNameController,
                      focusNode: _fullNameFocusNode,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.person,
                            color: defaultTextColor1,
                          ),
                          hintText: "Full Name",
                          hintStyle: TextStyle(color: defaultTextColor1)),
                      cursorColor: defaultTextColor1,
                      style: const TextStyle(color: defaultTextColor1),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter full name";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            FontAwesomeIcons.envelope,
                            color: defaultTextColor1,
                          ),
                          hintText: "Email",
                          hintStyle: TextStyle(color: defaultTextColor1)),
                      cursorColor: defaultTextColor1,
                      style: const TextStyle(color: defaultTextColor1),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter your email address";
                        }
                        else{
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      focusNode: _phoneNumberFocusNode,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            FontAwesomeIcons.phone,
                            color: defaultTextColor1,
                          ),
                          hintText: "Phone Number",
                          hintStyle: TextStyle(color: defaultTextColor1)),
                      cursorColor: defaultTextColor1,
                      style: const TextStyle(color: defaultTextColor1),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter correct phone number ";
                        }
                        if(value.length < 10){
                          return "Enter correct phone number";
                        }
                        else{
                          return null;
                        }
                      },
                    ),

                    const Divider(color: defaultTextColor1,),
                    TextFormField(
                      controller: _nameOnGCardController,
                      focusNode: _nameOnGCardFocusNode,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.person,
                            color: defaultTextColor1,
                          ),
                          hintText: "Name on Ghana Card",
                          hintStyle: TextStyle(color: defaultTextColor1)),
                      cursorColor: defaultTextColor1,
                      style: const TextStyle(color: defaultTextColor1),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter your name on the Ghana card";
                        }
                        else{
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _nextOfKinController,
                      focusNode: _nextOfKinFocusNode,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.person,
                            color: defaultTextColor1,
                          ),
                          hintText: "Next of Kin",
                          hintStyle: TextStyle(color: defaultTextColor1)),
                      cursorColor: defaultTextColor1,
                      style: const TextStyle(color: defaultTextColor1),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter your next of Kin";
                        }
                        else{
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _nextOfKinPhoneNumberController,
                      focusNode: _nextOfKinPhoneNumberFocusNode,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            FontAwesomeIcons.phone,
                            color: defaultTextColor1,
                          ),
                          hintText: "Next of Kin's Phone Number",
                          hintStyle: TextStyle(color: defaultTextColor1)),
                      cursorColor: defaultTextColor1,
                      style: const TextStyle(color: defaultTextColor1),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter phone number for next of kin";
                        }
                        else{
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _referralController,
                      focusNode: _referralFocusNode,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.person,
                            color: defaultTextColor1,
                          ),
                          hintText: "Referral",
                          hintStyle: TextStyle(color: defaultTextColor1)),
                      cursorColor: defaultTextColor1,
                      style: const TextStyle(color: defaultTextColor1),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter your referral";
                        }
                        else{
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    //upload front side of Ghana card
                    userController.frontGhanaCard == "" && userController.backGhanaCard == "" ?
                    const Center(
                      child: Text("Upload front and back side of your Gh card",style: TextStyle(color: defaultTextColor1),),
                    ): Container(),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        userController.frontGhanaCard == "" ?
                        Column(
                          children: [
                            const Text("Front Side",style: TextStyle(color: defaultTextColor1),),
                            const SizedBox(
                              height: 10,
                            ),
                            IconButton(
                              icon: const Icon(FontAwesomeIcons.upload,color: defaultTextColor1,),
                              onPressed: (){
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
                                                    Get.find<UserController>().getFromGalleryForFrontCard();
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
                                                    Get.find<UserController>().getFromCameraForFrontCard();
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
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ) : Container(),
                        const SizedBox(width: 10,),
                        //upload back side of Ghana card
                        userController.backGhanaCard == "" ?
                        Column(
                          children: [
                            const Text("Back Side",style: TextStyle(color: defaultTextColor1),),
                            const SizedBox(
                              height: 10,
                            ),
                            IconButton(
                              icon: const Icon(FontAwesomeIcons.upload,color: defaultTextColor1,),
                              onPressed: (){
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
                                                    Get.find<UserController>().getFromGalleryForBackCard();
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
                                                    Get.find<UserController>().getFromCameraForBackCard();
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
                                // Get.back();
                              },

                            ),
                            const SizedBox(height: 10,),
                          ],
                        ) : Container(),
                      ],
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
}

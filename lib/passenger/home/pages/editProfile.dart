import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:taxinet/g_controller/userController.dart';
import '../../../constants/app_colors.dart';
import 'dart:io';

class EditProfile extends StatefulWidget {
  String username;
  String email;
  String phone;
  String profilePic;
  EditProfile({Key? key,required this.username,required this.email, required this.phone,required this.profilePic}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState(username:this.username,email:this.email,phone:this.phone,profilePic:this.profilePic);
}

class _EditProfileState extends State<EditProfile> {
  String username;
  String email;
  String phone;
  String profilePic;
  _EditProfileState({required this.username,required this.email, required this.phone,required this.profilePic});
  // final userController = Get.put(UserController());

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _nameOnGCardController;
  late final TextEditingController _nextOfKinController;
  late final TextEditingController _nextOfKinPhoneNumberController;
  late final TextEditingController _referralController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  final FocusNode _usernameFocusNode = FocusNode();
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
    _usernameController = TextEditingController(text:username);
    _nameOnGCardController = TextEditingController();
    _nextOfKinController = TextEditingController();
    _nextOfKinPhoneNumberController = TextEditingController();
    _referralController = TextEditingController();
    _phoneController = TextEditingController(text: phone);
    _emailController = TextEditingController(text: phone);
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
                RawMaterialButton(
                  onPressed: () {
                    Get.find<UserController>().updateProfileDetails(_usernameController.text.trim(), _emailController.text.trim(), _phoneController.text.trim());
                    Get.find<UserController>().updatePassengerProfile(_nameOnGCardController.text.trim(), _nextOfKinController.text.trim(), _nextOfKinPhoneNumberController.text.trim(), _referralController.text.trim());
                    if(Get.find<UserController>().isUpdating){
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
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                  elevation: 8,
                  child: const Text(
                    "Update",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: defaultTextColor1),
                  ),
                  fillColor: primaryColor,
                  splashColor: defaultColor,
                ),
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
          children: [
            const SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                Center(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Get.find<UserController>().profileImageUpload != null ? CircleAvatar(
                      backgroundImage: FileImage(Get.find<UserController>().profileImageUpload!),
                      radius: size.width * 0.16,
                    ) : CircleAvatar(
                      backgroundImage: NetworkImage(Get.find<UserController>().profileImage),
                      radius: size.width * 0.16,
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
                      icon: const Icon(FontAwesomeIcons.edit,color: defaultTextColor1,),
                      onPressed: (){
                        showMaterialModalBottomSheet(
                          backgroundColor: secondaryColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          bounce: true,
                          context: context,
                          builder: (context) => SingleChildScrollView(
                            controller: ModalScrollController.of(context),
                            child: SizedBox(
                              height: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: ListView(
                                  children: [
                                    const Center(
                                      child: Text(
                                        "Select",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height:15,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.08,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.grey[500]?.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(
                      child: TextFormField(
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
                            return "";
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: size.height * 0.08,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.grey[500]?.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(
                      child: TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.person,
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
                            return "";
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: size.height * 0.08,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.grey[500]?.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(
                      child: TextFormField(
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
                            return "";
                          }
                        },
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  const Divider(color: defaultTextColor1,),
                  Container(
                    height: size.height * 0.08,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.grey[500]?.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(
                      child: TextFormField(
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
                            return "";
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: size.height * 0.08,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.grey[500]?.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(
                      child: TextFormField(
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
                            return "";
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: size.height * 0.08,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.grey[500]?.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(
                      child: TextFormField(
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
                        textInputAction: TextInputAction.done,
                        validator: (value){
                          if(value!.isEmpty){
                            return "";
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: size.height * 0.08,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.grey[500]?.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(
                      child: TextFormField(
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
                        textInputAction: TextInputAction.next,
                        validator: (value){
                          if(value!.isEmpty){
                            return "";
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //upload front side of Ghana card
                  const Text("Upload front side of Ghana Card",style: TextStyle(color: defaultTextColor1),),
                  const SizedBox(
                    height: 10,
                  ),
                  IconButton(
                    onPressed: (){
                      showMaterialModalBottomSheet(
                        backgroundColor: secondaryColor,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        bounce: true,
                        context: context,
                        builder: (context) => SingleChildScrollView(
                          controller: ModalScrollController.of(context),
                          child: SizedBox(
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: ListView(
                                children: [
                                  const Center(
                                    child: Text(
                                      "Select",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(FontAwesomeIcons.upload,size: 40,color: defaultTextColor1,),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //upload back side of Ghana card
                  const Text("Upload back side of Ghana Card",style: TextStyle(color: defaultTextColor1),),
                  const SizedBox(
                    height: 10,
                  ),
                  IconButton(
                    onPressed: (){
                      showMaterialModalBottomSheet(
                        backgroundColor: secondaryColor,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        bounce: true,
                        context: context,
                        builder: (context) => SingleChildScrollView(
                          controller: ModalScrollController.of(context),
                          child: SizedBox(
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: ListView(
                                children: [
                                  const Center(
                                    child: Text(
                                      "Select",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(FontAwesomeIcons.upload,size: 40,color: defaultTextColor1,),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(height: 25,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

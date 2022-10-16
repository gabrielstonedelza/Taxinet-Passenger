import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taxinet/constants/app_colors.dart';
import 'package:taxinet/g_controller/registration_controller.dart';
import 'package:taxinet/views/login/newlogin.dart';
import 'package:taxinet/widgets/backgroundImage.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final registerData = MyRegistrationController.to;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _rePasswordController;
  late final TextEditingController _phoneNumberController;
  final _formKey = GlobalKey<FormState>();
  bool isObscured = true;
  bool isPosting = false;
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _rePasswordFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _fullNameController = TextEditingController();
    _passwordController = TextEditingController();
    _rePasswordController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        const BackgroundImage(image: "assets/images/taxi3.jpg"),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),

                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Form(
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
                                  return "Enter username";
                                }
                                else{
                                  return null;
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
                                  return "Enter email";
                                }
                                else{
                                  return null;
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
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Enter full name";
                                }
                                else{
                                  return null;
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
                              controller: _phoneNumberController,
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
                              textInputAction: TextInputAction.next,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Enter phone number";
                                }
                                if(value.length < 10){
                                  return "Enter a valid phone number";
                                }
                                else{
                                  return null;
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
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: (){
                                      setState(() {
                                        isObscured = !isObscured;
                                      });
                                    },
                                    icon: Icon(isObscured ? Icons.visibility : Icons.visibility_off,color: defaultTextColor1,),
                                  ),
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(
                                    FontAwesomeIcons.lock,
                                    color: defaultTextColor1,
                                  ),
                                  hintText: "Password",
                                  hintStyle: const TextStyle(color: defaultTextColor1)),
                              cursorColor: defaultTextColor1,
                              style: const TextStyle(color: defaultTextColor1),
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.next,
                              obscureText: isObscured,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Enter password";
                                }
                                else{
                                  return null;
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
                              controller: _rePasswordController,
                              focusNode: _rePasswordFocusNode,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: (){
                                      setState(() {
                                        isObscured = !isObscured;
                                      });
                                    },
                                    icon: Icon(isObscured ? Icons.visibility : Icons.visibility_off,color: defaultTextColor1,),
                                  ),
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(
                                    FontAwesomeIcons.lock,
                                    color: defaultTextColor1,
                                  ),
                                  hintText: "Retype Password",
                                  hintStyle: const TextStyle(color: defaultTextColor1)),
                              cursorColor: defaultTextColor1,
                              style: const TextStyle(color: defaultTextColor1),
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              obscureText: isObscured,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "confirm password";
                                }
                                else{
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 25,),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: primaryColor
                          ),
                          height: size.height * 0.08,
                          width: size.width * 0.8,
                          child: RawMaterialButton(
                            onPressed: () {

                              if (_formKey.currentState!.validate()) {
                                registerData.registerUser(_usernameController.text.trim(),_emailController.text.trim(),_fullNameController.text.trim(),_phoneNumberController.text.trim(), _passwordController.text.trim(),_rePasswordController.text.trim());

                              } else {
                                // Get.defaultDialog(
                                //     title: "",
                                //     radius: 20,
                                //     backgroundColor: Colors.black54,
                                //     barrierDismissible: false,
                                //     content: Row(
                                //       children: const [
                                //         Expanded(child: Center(child: CircularProgressIndicator.adaptive(
                                //           strokeWidth: 5,
                                //           backgroundColor: primaryColor,
                                //           valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                                //         ))),
                                //         Expanded(child: Text("Processing",style: TextStyle(color: Colors.white),))
                                //       ],
                                //     )
                                // );
                                Get.snackbar("Error", "Something went wrong,check form",
                                    colorText: defaultTextColor1,
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red
                                );
                                return;
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                            ),
                            elevation: 8,
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: defaultTextColor1),
                            ),
                            fillColor: primaryColor,
                            splashColor: defaultColor,
                          ),
                        ),
                        const SizedBox(height: 20,),
                        const Text("Already have an account?",style: TextStyle(fontWeight: FontWeight.bold,color: defaultTextColor1),),
                        const SizedBox(height: 20,),
                        ElevatedButton(
                          child: const Text("Login",style: TextStyle(fontWeight: FontWeight.bold,color: defaultTextColor1),),
                          onPressed: (){
                            Get.to(()=> const NewLogin());
                          },
                        ),
                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

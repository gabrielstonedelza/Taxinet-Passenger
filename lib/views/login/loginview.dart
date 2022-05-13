import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../controllers/login/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool isObscured = true;
  bool isPosting = false;
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  void _startPosting()async{
    setState(() {
      isPosting = true;
    });
    await Future.delayed(const Duration(seconds: 4));
    setState(() {
      isPosting = false;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          const SizedBox(height: 20,),
          Image.asset("assets/images/taxinet_new.png",height: 250,),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      focusNode: _usernameFocusNode,
                      controller: _usernameController,
                      cursorColor: defaultTextColor2,
                      cursorRadius: const Radius.elliptical(10, 10),
                      cursorWidth: 5,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person,color: defaultTextColor2,),
                          hintText: "Enter your username",
                          hintStyle: const TextStyle(color: defaultTextColor2,),
                          focusColor: primaryColor,
                          filled: true,
                          fillColor: primaryColor,
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: primaryColor, width: 2),
                              borderRadius: BorderRadius.circular(12)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if(value!.isEmpty){
                          return "Please enter your username";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      focusNode: _passwordFocusNode,
                      controller: _passwordController,
                      cursorColor: defaultTextColor2,
                      cursorRadius: const Radius.elliptical(10, 10),
                      cursorWidth: 5,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock,color: defaultTextColor2,),
                          suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                isObscured = !isObscured;
                              });
                            },
                            icon: Icon(isObscured ? Icons.visibility : Icons.visibility_off,color: defaultTextColor2,),
                          ),
                          hintText: "Enter your password",
                          hintStyle: const TextStyle(color: defaultTextColor2),
                          focusColor: primaryColor,
                          filled: true,
                          fillColor: primaryColor,
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: primaryColor, width: 2),
                              borderRadius: BorderRadius.circular(12)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                      keyboardType: TextInputType.text,
                      obscureText: isObscured,
                      validator: (value) {
                        if(value!.isEmpty){
                          return "Please enter your password";
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20,),
               isPosting ? const Center(
                 child: CircularProgressIndicator(
                   strokeWidth: 6,
                   color: primaryColor,
                 ),
               ) :   RawMaterialButton(
                    onPressed: () {
                      _startPosting();
                      setState(() {
                        isPosting = true;
                      });
                      if (!_formKey.currentState!.validate()) {
                        Get.snackbar("Error", "Something went wrong",
                            colorText: defaultTextColor1,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red
                        );
                        setState(() {
                          isPosting = false;
                        });
                        return;
                      } else {
                        Provider.of<LoginController>(context,listen: false).loginUser(_usernameController.text, _passwordController.text);
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    elevation: 8,
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: defaultTextColor2),
                    ),
                    fillColor: primaryColor,
                    splashColor: defaultColor,
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}

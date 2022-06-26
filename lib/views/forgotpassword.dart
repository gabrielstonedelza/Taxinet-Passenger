import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taxinet/constants/app_colors.dart';
import 'package:taxinet/widgets/backgroundImage.dart';
import 'package:get/get.dart';


class ForGotPassword extends StatefulWidget {
  const ForGotPassword({Key? key}) : super(key: key);

  @override
  State<ForGotPassword> createState() => _ForGotPasswordState();
}

class _ForGotPasswordState extends State<ForGotPassword> {
  late final TextEditingController _emailController;
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        const BackgroundImage(image: "assets/images/taxi2.jpg"),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text("Forgot Password",style: TextStyle(color: defaultTextColor1),),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: (){
                Get.back();
              },
            ),
          ),
          body: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.1,),
                    SizedBox(
                      width: size.width * 0.8,
                      child: const Text("Enter your email address below and we will send you instructions to reset your password",style: TextStyle(color: defaultTextColor1),),
                    ),
                    const SizedBox(height: 20,),
                Container(
                  height: size.height * 0.08,
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.grey[500]?.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16)
                  ),
                  child: Center(
                    child: TextField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(FontAwesomeIcons.envelope,color: defaultTextColor1,),
                          hintText: "Username",
                          hintStyle: TextStyle(color: defaultTextColor1)
                      ),
                      cursorColor: defaultTextColor1,
                      style: const TextStyle(color: defaultTextColor1),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ),
                    const SizedBox(height: 20,),
                    RawMaterialButton(
                      onPressed: () {

                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      ),
                      elevation: 8,
                      child: const Text(
                        "Send",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: defaultTextColor1),
                      ),
                      fillColor: primaryColor,
                      splashColor: defaultColor,
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

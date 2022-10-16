import "package:flutter/material.dart";
import 'package:flutter/services.dart';

import '../../../constants/app_colors.dart';

class VerifyNumber extends StatelessWidget {
  const VerifyNumber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size  = MediaQuery.of(context).size;
    final TextEditingController otpController = TextEditingController();
    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 68,
            width: 64,
            child: Container(
              height: size.height * 0.08,
              width: size.width * 0.8,
              decoration: BoxDecoration(
                  color: Colors.grey[500]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Center(
                child: TextFormField(
                  onChanged: (value){
                    if(value.length == 1){
                      FocusScope.of(context).nextFocus();
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
            // child: TextFormField(
            //   onChanged: (value){
            //     if(value.length == 1){
            //       FocusScope.of(context).nextFocus();
            //     }
            //   },
            //     decoration: const InputDecoration(
            //       border: InputBorder.none,
            //       hintText: "0",
            //       hintStyle: TextStyle(color: defaultTextColor2,),
            //       focusColor: primaryColor,
            //       fillColor: primaryColor,
            //
            //     ),
            //   style: Theme.of(context).textTheme.headline6,
            //   keyboardType: TextInputType.number,
            //   textAlign: TextAlign.center,
            //   inputFormatters: [LengthLimitingTextInputFormatter(1),FilteringTextInputFormatter.digitsOnly],
            // )
            ),
          SizedBox(
            height: 68,
            width: 64,
            child: Container(
              height: size.height * 0.08,
              width: size.width * 0.8,
              decoration: BoxDecoration(
                  color: Colors.grey[500]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Center(
                child: TextFormField(
                  onChanged: (value){
                    if(value.length == 1){
                      FocusScope.of(context).nextFocus();
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
            // child: TextFormField(
            //   onChanged: (value){
            //     if(value.length == 1){
            //       FocusScope.of(context).nextFocus();
            //     }
            //   },
            //     decoration: const InputDecoration(
            //       border: InputBorder.none,
            //       hintText: "0",
            //       hintStyle: TextStyle(color: defaultTextColor2,),
            //       focusColor: primaryColor,
            //       fillColor: primaryColor,
            //
            //     ),
            //   style: Theme.of(context).textTheme.headline6,
            //   keyboardType: TextInputType.number,
            //   textAlign: TextAlign.center,
            //   inputFormatters: [LengthLimitingTextInputFormatter(1),FilteringTextInputFormatter.digitsOnly],
            // )
          ),
          SizedBox(
            height: 68,
            width: 64,
            child: Container(
              height: size.height * 0.08,
              width: size.width * 0.8,
              decoration: BoxDecoration(
                  color: Colors.grey[500]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Center(
                child: TextFormField(
                  onChanged: (value){
                    if(value.length == 1){
                      FocusScope.of(context).nextFocus();
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
              height: size.height * 0.08,
              width: size.width * 0.8,
              decoration: BoxDecoration(
                  color: Colors.grey[500]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Center(
                child: TextFormField(
                  onChanged: (value){
                    if(value.length == 1){
                      FocusScope.of(context).nextFocus();
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
            // child: TextFormField(
            //   onChanged: (value){
            //     if(value.length == 1){
            //       FocusScope.of(context).nextFocus();
            //     }
            //   },
            //     decoration: const InputDecoration(
            //       border: InputBorder.none,
            //       hintText: "0",
            //       hintStyle: TextStyle(color: defaultTextColor2,),
            //       focusColor: primaryColor,
            //       fillColor: primaryColor,
            //
            //     ),
            //   style: Theme.of(context).textTheme.headline6,
            //   keyboardType: TextInputType.number,
            //   textAlign: TextAlign.center,
            //   inputFormatters: [LengthLimitingTextInputFormatter(1),FilteringTextInputFormatter.digitsOnly],
            // )
          ),
          SizedBox(
            height: 68,
            width: 64,
            child: Container(
              height: size.height * 0.08,
              width: size.width * 0.8,
              decoration: BoxDecoration(
                  color: Colors.grey[500]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Center(
                child: TextFormField(
                  onChanged: (value){
                    if(value.length == 1){
                      FocusScope.of(context).nextFocus();
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
            // child: TextFormField(
            //   onChanged: (value){
            //     if(value.length == 1){
            //       FocusScope.of(context).nextFocus();
            //     }
            //   },
            //     decoration: const InputDecoration(
            //       border: InputBorder.none,
            //       hintText: "0",
            //       hintStyle: TextStyle(color: defaultTextColor2,),
            //       focusColor: primaryColor,
            //       fillColor: primaryColor,
            //
            //     ),
            //   style: Theme.of(context).textTheme.headline6,
            //   keyboardType: TextInputType.number,
            //   textAlign: TextAlign.center,
            //   inputFormatters: [LengthLimitingTextInputFormatter(1),FilteringTextInputFormatter.digitsOnly],
            // )
          ),
        ],
      ),
    );
  }
}

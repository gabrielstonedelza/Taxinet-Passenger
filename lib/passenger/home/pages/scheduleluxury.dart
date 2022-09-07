import "package:flutter/material.dart";
import "package:get/get.dart";
import '../../../constants/app_colors.dart';

class ScheduleLuxury extends StatefulWidget {
  const ScheduleLuxury({Key? key}) : super(key: key);

  @override
  State<ScheduleLuxury> createState() => _ScheduleLuxuryState();
}

class _ScheduleLuxuryState extends State<ScheduleLuxury> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:AppBar(
          title: const Text("Schedule Luxury",style:TextStyle(color: defaultTextColor2)),
          centerTitle: true,
          backgroundColor:Colors.transparent,
          elevation:0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon:const Icon(Icons.arrow_back,color:defaultTextColor2)
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(
              child: Text("😀 Taxinet Luxury coming soon",style: TextStyle(fontWeight: FontWeight.bold,)),
            )
          ],
        )
      )
    );
  }
}

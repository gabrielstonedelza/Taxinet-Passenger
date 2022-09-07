import "package:flutter/material.dart";
import "package:get/get.dart";
import '../../../constants/app_colors.dart';

class ScheduleTruck extends StatefulWidget {
  const ScheduleTruck({Key? key}) : super(key: key);

  @override
  State<ScheduleTruck> createState() => _ScheduleTruckState();
}

class _ScheduleTruckState extends State<ScheduleTruck> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar:AppBar(
              title: const Text("Schedule Truck",style:TextStyle(color: defaultTextColor2)),
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
                  child: Text("😀 Schedule Truck coming soon",style: TextStyle(fontWeight: FontWeight.bold,)),
                )
              ],
            )
        )
    );
  }
}

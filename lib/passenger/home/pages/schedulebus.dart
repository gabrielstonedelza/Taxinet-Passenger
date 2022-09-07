import "package:flutter/material.dart";
import "package:get/get.dart";
import '../../../constants/app_colors.dart';

class ScheduleBus extends StatefulWidget {
  const ScheduleBus({Key? key}) : super(key: key);

  @override
  State<ScheduleBus> createState() => _ScheduleBusState();
}

class _ScheduleBusState extends State<ScheduleBus> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar:AppBar(
              title: const Text("Schedule Bus",style:TextStyle(color: defaultTextColor2)),
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
                  child: Text("😀 Taxinet Bus coming soon",style: TextStyle(fontWeight: FontWeight.bold,)),
                )
              ],
            )
        )
    );
  }
}

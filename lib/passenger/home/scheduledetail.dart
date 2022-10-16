import "package:flutter/material.dart";

import '../../constants/app_colors.dart';
import '../../g_controller/schedulescontroller.dart';
import "package:get/get.dart";

import '../../widgets/shimmers/shimmerwidget.dart';

class ScheduleDetail extends StatefulWidget {
  String slug;
  String title;
  String id;
  ScheduleDetail({Key? key, required this.slug,required this.title,required this.id}) : super(key: key);

  @override
  State<ScheduleDetail> createState() => _ScheduleDetailState(slug:this.slug,title:this.title,id:this.id);
}

class _ScheduleDetailState extends State<ScheduleDetail> {
  String slug;
  String title;
  String id;
  _ScheduleDetailState({required this.slug,required this.title,required this.id});

  ScheduleController controller = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getDetailSchedule(slug);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title,style:const TextStyle(color: defaultTextColor2)),
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
      body: ListView(
        children: [
          const SizedBox(height:20),
          Padding(
            padding: const EdgeInsets.only(left:15, right:15,),
            child: Card(
              elevation:12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Assigned Driver",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                          const SizedBox(height:10),
                          Row(
                            children: [
                              GetBuilder<ScheduleController>(
                                builder: (controller) {
                                  return controller.assignedDriverSPic == "" ? const CircleAvatar(
                                    backgroundImage: AssetImage("assets/images/user.png"),
                                    radius: 50,
                                  ):CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        controller.
                                        assignedDriverSPic),
                                    radius: 30,
                                  );
                                },
                              ),
                              const SizedBox(width: 20,),
                              GetBuilder<ScheduleController>(builder: (controller) {
                                return Text(controller.assignedDriver,);
                              })
                            ],
                          )
                        ]
                    ),
                    const SizedBox(height:10),
                    const Divider(),
                    const SizedBox(height:10),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Schedule Type",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                          const SizedBox(height:10),
                          GetBuilder<ScheduleController>(builder: (controller) {
                            return controller.scheduleType == "" ? const ShimmerWidget.rectangular(height: 20) : Text(controller.scheduleType);
                          })
                        ]
                    ),
                    const SizedBox(height:10),
                    const Divider(),
                    const SizedBox(height:10),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Schedule Priority",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                          const SizedBox(height:10),
                          GetBuilder<ScheduleController>(builder: (controller) {
                            return controller.schedulePriority == "" ? const ShimmerWidget.rectangular(height: 20) :Text(controller.schedulePriority);
                          })
                        ]
                    ),
                    const SizedBox(height:10),
                    const Divider(),
                    const SizedBox(height:10),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Description",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                          const SizedBox(height:10),
                          GetBuilder<ScheduleController>(builder: (controller) {
                            return controller.description == "" ? const ShimmerWidget.rectangular(height: 20) :  Text(controller.description);
                          })
                        ]
                    ),
                    const SizedBox(height:10),
                    const Divider(),
                    const SizedBox(height:10),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Ride Type",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                          const SizedBox(height:10),
                          GetBuilder<ScheduleController>(builder: (controller) {
                            return controller.rideType == "" ? const ShimmerWidget.rectangular(height: 20) : Text(controller.rideType);
                          })
                        ]
                    ),
                    const SizedBox(height:10),
                    const Divider(),
                    const SizedBox(height:10),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Pickup Location",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                          const SizedBox(height:10),
                          GetBuilder<ScheduleController>(builder: (controller) {
                            return controller.pickUpLocation == "" ? const ShimmerWidget.rectangular(height: 20) : Text(controller.pickUpLocation);
                          })
                        ]
                    ),
                    const SizedBox(height:10),
                    const Divider(),
                    const SizedBox(height:10),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Drop Off Location",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                          const SizedBox(height:10),
                          GetBuilder<ScheduleController>(builder: (controller) {
                            return controller.dropOffLocation == "" ? const ShimmerWidget.rectangular(height: 20) : Text(controller.dropOffLocation);
                          })
                        ]
                    ),
                    const SizedBox(height:10),
                    const Divider(),
                    const SizedBox(height:10),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Pick up time",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                          const SizedBox(height:10),
                          GetBuilder<ScheduleController>(builder: (controller) {
                            return controller.pickUpTime == "" ? const ShimmerWidget.rectangular(height: 20) :   Text(controller.pickUpTime);
                          })
                        ]
                    ),
                    const SizedBox(height:10),
                    const Divider(),
                    const SizedBox(height:10),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Start Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                          const SizedBox(height:10),
                          GetBuilder<ScheduleController>(builder: (controller) {
                            return controller.startDate == "" ? const ShimmerWidget.rectangular(height: 20) :  Text(controller.startDate);
                          })
                        ]
                    ),
                    const SizedBox(height:10),
                    const Divider(),
                    const SizedBox(height:10),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Status",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                          const SizedBox(height:10),
                          GetBuilder<ScheduleController>(builder: (controller) {
                            return controller.status == "" ? const ShimmerWidget.rectangular(height: 20) :  Text(controller.status);
                          })
                        ]
                    ),
                    const SizedBox(height:10),
                    const Divider(),
                    const SizedBox(height:10),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Date Requested",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                          const SizedBox(height:10),
                          GetBuilder<ScheduleController>(builder: (controller) {
                            return controller.dateRequested == "" ? const ShimmerWidget.rectangular(height: 20) : Text(controller.dateRequested);
                          })
                        ]
                    ),
                    const SizedBox(height:10),
                    const Divider(),
                    const SizedBox(height:10),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Time Requested",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                          const SizedBox(height:10),
                          GetBuilder<ScheduleController>(builder: (controller) {
                            return controller.timeRequested == "" ? const ShimmerWidget.rectangular(height: 20) : Text(controller.timeRequested.toString().split(".").first);
                          })
                        ]
                    ),
                    const SizedBox(height:10),
                    const Divider(),
                    const SizedBox(height:10),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Price",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                          const SizedBox(height:10),
                          GetBuilder<ScheduleController>(builder: (controller) {
                            return controller.price == "" ? const ShimmerWidget.rectangular(height: 20) : Text(controller.price);
                          })
                        ]
                    ),
                    const SizedBox(height:10),
                    const Divider(),
                    const SizedBox(height:10),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Charge",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                          const SizedBox(height:10),
                          GetBuilder<ScheduleController>(builder: (controller) {
                            return controller.charge == "" ? const ShimmerWidget.rectangular(height: 20) : Text(controller.charge);
                          })
                        ]
                    ),
                  ],

                ),
              )
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:get_storage/get_storage.dart';

import '../../constants/app_colors.dart';
import '../../g_controller/schedulescontroller.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';

import '../../widgets/shimmers/shimmerwidget.dart';

class ScheduleDetail extends StatefulWidget {
  String slug;
  String id;
  ScheduleDetail({Key? key, required this.slug,required this.id}) : super(key: key);

  @override
  State<ScheduleDetail> createState() => _ScheduleDetailState(slug:this.slug,id:this.id);
}

class _ScheduleDetailState extends State<ScheduleDetail> {
  String slug;
  String id;
  _ScheduleDetailState({required this.slug,required this.id});
  final storage = GetStorage();
  var username = "";
  String uToken = "";
  bool isLoading = true;

  ScheduleController controller = Get.find();
  List detailScheduleItems = [];
  String assignedDriver = "";
  String assignedDriversId = "";
  String assignedDriverSPic = "";
  String scheduleType = "";
  String schedulePriority = "";
  String rideType = "";
  String pickUpLocation = "";
  String dropOffLocation = "";
  String pickUpTime = "";
  String startDate = "";
  String status = "";
  String dateRequested = "";
  String timeRequested = "";
  String description = "";
  String price = "";
  String charge = "";
  String passenger = "";

  Future<void> getDetailSchedule() async {

      final walletUrl = "https://taxinetghana.xyz/ride_requests/$id/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $uToken"
      });
      if (response.statusCode == 200) {
        final codeUnits = response.body;
        var jsonData = jsonDecode(codeUnits);
        assignedDriversId = jsonData['assigned_driver'].toString();
        assignedDriver = jsonData['get_assigned_driver_name'];
        assignedDriverSPic = jsonData['get_assigned_driver_profile_pic'];
        scheduleType = jsonData['schedule_type'];
        schedulePriority = jsonData['schedule_priority'];
        description = jsonData['schedule_description'];
        rideType = jsonData['ride_type'];
        pickUpLocation = jsonData['pickup_location'];
        dropOffLocation = jsonData['drop_off_location'];
        pickUpTime = jsonData['pick_up_time'];
        startDate = jsonData['start_date'];
        status = jsonData['status'];
        dateRequested = jsonData['date_scheduled'];
        timeRequested = jsonData['time_scheduled'];
        price = jsonData['price'];
        charge = jsonData['charge'];
        passenger = jsonData['passenger'].toString();
      }
      else{
        if (kDebugMode) {
          print(response.body);
        }
      }
      setState(() {
        isLoading = false;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    getDetailSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(id,style:const TextStyle(color: defaultTextColor2)),
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
      body: isLoading ? const Center(
          child:CircularProgressIndicator.adaptive(
            strokeWidth: 5,
            backgroundColor: primaryColor,
          )
      ) : ListView(
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
                          assignedDriverSPic == "" ? const CircleAvatar(
                          backgroundImage: AssetImage("assets/images/user.png"),
                                  radius: 50,
                                ):CircleAvatar(
                                  backgroundImage: NetworkImage(
                                  assignedDriverSPic),
                              radius: 30,
                            ),
                              const SizedBox(width: 20,),
                              Text(assignedDriver,)
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
                          scheduleType == "" ? const ShimmerWidget.rectangular(height: 20) : Text(scheduleType)
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
                          rideType == "" ? const ShimmerWidget.rectangular(height: 20) : Text(rideType)
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
                          pickUpLocation == "" ? const ShimmerWidget.rectangular(height: 20) : Text(pickUpLocation)
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
                          dropOffLocation == "" ? const ShimmerWidget.rectangular(height: 20) : Text(dropOffLocation)
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
                          pickUpTime == "" ? const ShimmerWidget.rectangular(height: 20) :   Text(pickUpTime)
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
                          startDate == "" ? const ShimmerWidget.rectangular(height: 20) :  Text(startDate)
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
                          status == "" ? const ShimmerWidget.rectangular(height: 20) :  Text(status)
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
                          dateRequested == "" ? const ShimmerWidget.rectangular(height: 20) : Text(dateRequested)
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
                          timeRequested == "" ? const ShimmerWidget.rectangular(height: 20) : Text(timeRequested.toString().split(".").first)
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
                          price == "" ? const ShimmerWidget.rectangular(height: 20) : Text(price)
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
                          charge == "" ? const ShimmerWidget.rectangular(height: 20) : Text(charge)
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

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../g_controller/schedulescontroller.dart';
import '../scheduledetail.dart';



class AllSchedules extends StatefulWidget {

  const AllSchedules({Key? key}) : super(key: key);

  @override
  State<AllSchedules> createState() => _AllSchedulesState();
}

class _AllSchedulesState extends State<AllSchedules> {

  var items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("All Schedules"),
          backgroundColor:primaryColor,
        ),
        backgroundColor: primaryColor,
        body: GetBuilder<ScheduleController>(builder:(scheduleController){
          return ListView.builder(
              itemCount: scheduleController.allSchedules != null ? scheduleController.allSchedules.length : 0,
              itemBuilder: (context,index){
                items = scheduleController.allSchedules[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10,),
                  child: SlideInUp(
                    animate: true,
                    child: Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                            onTap: (){
                              Get.to(()=> ScheduleDetail(slug:scheduleController.allSchedules[index]['slug'],id:scheduleController.allSchedules[index]['id'].toString()));
                              // Navigator.pop(context);
                            },
                            leading: const Icon(Icons.access_time_filled),
                            title: Text(items['get_passenger_name'],style:const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top:10.0),
                              child: Text(items['date_scheduled']),
                            )
                        )
                    ),
                  ),
                );
              }
          );
        })
    );
  }
}
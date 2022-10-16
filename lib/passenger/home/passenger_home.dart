import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:taxinet/passenger/home/scheduledetail.dart';
import '../../constants/app_colors.dart';
import '../../g_controller/schedulescontroller.dart';
import '../../g_controller/userController.dart';


class PassengerHome extends StatelessWidget {
  PassengerHome({Key? key}) : super(key: key);

  String greetingMessage(){
    var timeNow = DateTime.now().hour;
    if (timeNow <= 12) {
      return 'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      return 'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }
  UserController userController = Get.find();
  ScheduleController scheduleController = Get.find();
  var items;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: primaryColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30,),
                Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height:30),
                        const Center(
                          child: Text("Schedules",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: defaultTextColor2),)
                        ),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: (){
                                    showMaterialModalBottomSheet(
                                      context: context,
                                      isDismissible: true,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.vertical(
                                              top: Radius.circular(
                                                  25.0))),
                                      bounce: true,
                                      builder: (context) => SingleChildScrollView(
                                        controller: ModalScrollController.of(context),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 600,
                                              child:  ListView.builder(
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
                                                                Get.to(()=> ScheduleDetail(slug:scheduleController.allSchedules[index]['slug'],title:scheduleController.allSchedules[index]['schedule_title'],id:scheduleController.allSchedules[index]['id'].toString()));
                                                                // Navigator.pop(context);
                                                              },
                                                                leading: const Icon(Icons.access_time_filled),
                                                                title: Text(items['schedule_title'],style:const TextStyle(fontWeight: FontWeight.bold)),
                                                                subtitle: Padding(
                                                                  padding: const EdgeInsets.only(top:10.0),
                                                                  child: Text(items['date_scheduled']),
                                                                )
                                                            )
                                                        ),
                                                      ),
                                                    );
                                                  }
                                              )
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      color: greyBack,
                                      height: 85,
                                      width: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Icon(FontAwesomeIcons.list,color: greenBack,),
                                                Text("${scheduleController.allSchedules.length}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: pearl),)
                                              ],
                                            ),
                                            const SizedBox(height: 10,),
                                            const Text("All",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: pearl),)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20,),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    showMaterialModalBottomSheet(
                                      context: context,
                                      isDismissible: true,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.vertical(
                                              top: Radius.circular(
                                                  25.0))),
                                      bounce: true,
                                      builder: (context) => SingleChildScrollView(
                                        controller: ModalScrollController.of(context),
                                        child: SizedBox(
                                            height: 600,
                                            child: ListView.builder(
                                                itemCount: scheduleController.activeSchedules != null ? scheduleController.activeSchedules.length : 0,
                                                itemBuilder: (context,index){
                                                  items = scheduleController.activeSchedules[index];
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
                                                                Get.to(()=> ScheduleDetail(slug:scheduleController.activeSchedules[index]['slug'],title:scheduleController.activeSchedules[index]['schedule_title'],id:scheduleController.allSchedules[index]['id'].toString()));
                                                              },
                                                              leading: const Icon(Icons.access_time_filled),
                                                              title: Text(items['schedule_title'],style:const TextStyle(fontWeight: FontWeight.bold)),
                                                              subtitle: Padding(
                                                                padding: const EdgeInsets.only(top:10.0),
                                                                child: Text(items['date_scheduled']),
                                                              )
                                                          )
                                                      ),
                                                    ),
                                                  );
                                                }
                                            )
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      color: greyBack,
                                      height: 85,
                                      width: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Icon(FontAwesomeIcons.fire,color: primaryColor,),
                                                Text("${scheduleController.activeSchedules.length}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: pearl),)
                                              ],
                                            ),
                                            const SizedBox(height: 10,),
                                            const Text("Active",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: pearl),)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),

    );
  }
}

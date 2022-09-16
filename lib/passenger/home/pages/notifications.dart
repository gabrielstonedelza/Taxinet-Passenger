import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxinet/constants/app_colors.dart';
import 'package:taxinet/g_controller/notificationController.dart';
import '../../../g_controller/userController.dart';
import '../../../views/bottomnavigationbar.dart';
import '../../../widgets/shimmers/listshimmer.dart';
import '../../../widgets/shimmers/shimmerwidget.dart';
import '../scheduledetail.dart';
import 'newprofile.dart';


class Notifications extends StatelessWidget {
  final uController = Get.put(UserController());
  NotificationController notificationController = Get.find();
  var items;

  Notifications({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor:primaryColor,

      ),
      backgroundColor: primaryColor,
      body: ListView.builder(
        itemCount: notificationController.allNotifications != null ? notificationController.allNotifications.length :0,
          itemBuilder: (context,index){
          items = notificationController.allNotifications[index];
            return Column(
              children: [
                const SizedBox(height: 10,),
                SlideInUp(
                  animate: true,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18,right: 18),
                    child: notificationController.allNotifications != null ? Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:items['read'] == "Read" ? ListTile(

                        leading: const CircleAvatar(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            child: Icon(Icons.notifications)
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                          child: Text(items['notification_title']),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(items['notification_message']),
                        ),
                      ) :ListTile(
                        onTap: (){
                          Get.offAll(() => const MyBottomNavigationBar());
                        },
                        leading: const CircleAvatar(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            child: Icon(Icons.notifications)
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                          child: Text(items['notification_title'],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(items['notification_message']),
                        ),
                      ),
                    ) : const ShimmerWidget.rectangular(height: 20),
                  ),
                )
              ],
            );

          }
      )
    );
  }

}
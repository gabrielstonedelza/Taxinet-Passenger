import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:taxinet/controllers/notification_provider.dart';
import 'package:taxinet/g_controller/notificationController.dart';
import 'package:taxinet/g_controller/registration_controller.dart';
import 'package:taxinet/g_controller/userController.dart';
import 'package:taxinet/splash.dart';
import 'package:taxinet/states/schedule_state.dart';
import 'package:get/get.dart';
import 'constants/themeprovider.dart';
import 'g_controller/login_controller.dart';
import 'g_controller/ridesController.dart';
import 'g_controller/schedulescontroller.dart';
import 'g_controller/walletcontroller.dart';
import 'mapscontroller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await GetStorage.init();
 
  Get.put(MyLoginController());
  Get.put(MyRegistrationController());
  Get.put(RidesController());
  Get.put(NotificationController());
  Get.put(UserController());
  Get.put(WalletController());
  Get.put(ScheduleController());
  Get.put(MapController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => ScheduleState()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.leftToRight,
        // themeMode: ThemeMode.system,
        // theme:MyThemes.lightTheme,
        // darkTheme: MyThemes.darkTheme,
        home: SplashScreen(),
      ),
    );
  }
}

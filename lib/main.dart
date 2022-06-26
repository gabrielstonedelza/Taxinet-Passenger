import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:taxinet/g_controller/registration_controller.dart';
import 'package:taxinet/g_controller/userController.dart';
import 'package:taxinet/splash.dart';
import 'package:taxinet/states/app_state.dart';
import 'package:get/get.dart';
import 'g_controller/login_controller.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await GetStorage.init();
  Get.put(MyLoginController());
  Get.put(MyRegistrationController());
  Get.put(DeMapController());
  Get.put(UserController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(context)=> AppState()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.upToDown,
        theme: ThemeData(
// This is the theme of your application.
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.sansitaSwashedTextTheme(Theme.of(context).textTheme)

        ),
        home: const SplashScreen(),
      ),
    );
  }
}

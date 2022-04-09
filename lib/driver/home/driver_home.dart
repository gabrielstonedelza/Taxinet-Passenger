import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/login/login_controller.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({Key? key}) : super(key: key);

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Consumer<LoginController>(builder: (context,loginData,child){
      //     return Text(loginData.loggedInUsername);
      //   }),
      // ),
      body: Center(
        child: Text("THis is drivers home"),
      ),
    );
  }
}

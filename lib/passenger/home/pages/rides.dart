import 'package:flutter/material.dart';

class Rides extends StatefulWidget {
  const Rides({Key? key}) : super(key: key);

  @override
  State<Rides> createState() => _RidesState();
}

class _RidesState extends State<Rides> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("This is rides"),
      ),
    );
  }
}
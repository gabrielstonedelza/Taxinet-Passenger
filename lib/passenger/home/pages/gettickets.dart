import "package:flutter/material.dart";
import "package:get/get.dart";
import '../../../constants/app_colors.dart';

class TaxinetTicket extends StatefulWidget {
  const TaxinetTicket({Key? key}) : super(key: key);

  @override
  State<TaxinetTicket> createState() => _TaxinetTicketState();
}

class _TaxinetTicketState extends State<TaxinetTicket> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar:AppBar(
              title: const Text("Book Ticket",style:TextStyle(color: defaultTextColor2)),
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
                  child: Text("😀 Taxinet Ticket coming soon",style: TextStyle(fontWeight: FontWeight.bold,)),
                )
              ],
            )
        )
    );
  }
}

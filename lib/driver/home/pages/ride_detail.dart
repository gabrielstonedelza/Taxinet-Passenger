import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:taxinet/constants/app_colors.dart';

import '../../../states/app_state.dart';

class RideDetail extends StatefulWidget {
  final id;
  RideDetail({Key? key,this.id}) : super(key: key);

  @override
  State<RideDetail> createState() => _RideDetailState(id:this.id);
}

class _RideDetailState extends State<RideDetail> {
  var uToken = "";
  final storage = GetStorage();
  var username = "";
  final id;
  _RideDetailState({ required this.id});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final appState = Provider.of<AppState>(context,listen: false);
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }

    appState.fetchRideDetail(id,uToken);
  }
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ride Details"),
      ),
      body: appState.loading ? const Center(
        child: CircularProgressIndicator(
          strokeWidth: 5,
          color: primaryColor,
        ),
      ) :ListView(
        children: [
          const SizedBox(height: 20,),
          Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      appState.passengerPic != null ? CircleAvatar(
                        backgroundImage: NetworkImage(appState.passengerPic),
                        radius: 30,
                      ) : const Icon(Icons.person),
                      const SizedBox(width: 20,),
                      Center(
                        child: Text(appState.passengerUsername.toString().toUpperCase()),
                      )
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      const Text("Pick up: "),
                      Text(appState.pickUpLocation),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Drop Off: "),
                      Text(appState.dropOffLocation),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Date: "),
                      Text(appState.dateRideRequested),
                    ],
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:taxinet/controllers/login/login_controller.dart';
import 'package:taxinet/passenger/home/ride/request_ride.dart';
import '../../../constants/app_colors.dart';
import '../../../models/place.dart';
import '../../../states/app_state.dart';

class AfterSearch extends StatefulWidget {

  const AfterSearch({Key? key}) : super(key: key);

  @override
  State<AfterSearch> createState() => _AfterSearchState();
}

class _AfterSearchState extends State<AfterSearch> {

  final storage = GetStorage();
  late String username = "";
  late String uToken = "";
  late String userId = "";
  final Completer<GoogleMapController> _mapController = Completer();
  final Set<Marker> _markers = {};
  StreamSubscription<Places>? locationSubscription;
  bool isLoading = true;

  bool isFinished = false;
  var itemPlaceid;
  late String apiKey = "";
  late LatLng initialPosition;
  late Timer _timer;

  bool isPosting = false;

  void _startPosting()async{
    setState(() {
      isPosting = true;
    });
    await Future.delayed(const Duration(seconds: 4));
    setState(() {
      isPosting = false;
    });
  }


  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    appState.sendRequest(appState.sDestination);
    appState.setSelectedLocation(appState.sPlaceId);
    setState(() {
      apiKey = appState.apiKey;
      initialPosition = appState.initialPosition;
    });
    locationSubscription = appState.selectedLocation.stream.listen((place) async{
      if (place != null) {
        goToPlace(place);
      }
      Timer(const Duration(seconds: 10),() async => await locationSubscription?.cancel());
    });
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    if (storage.read("user_id") != null) {
      userId = storage.read("user_id");
    }
    appState.getDriversUpdatedLocations(uToken);

    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      appState.getDriversUpdatedLocations(uToken);
    });
  }


  // @override
  // void dispose() {
  //   final appState = Provider.of<AppState>(context, listen: false);
  //   appState.allDriversLocationMinutes.clear();
  //   locationSubscription?.cancel();
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final userState = Provider.of<LoginController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultTextColor2,
        elevation: 0,
        leading: IconButton(
          onPressed: ()async{
            appState.polyLines.clear();
            appState.markers.clear();
            final GoogleMapController controller = await _mapController.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: appState.initialPosition,
                zoom: 11)));
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back,color: defaultTextColor1,),
        ),
        title: Text("${appState.routeDuration}, ${appState.routeDistance}",style: const TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold),),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height/2,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: appState.initialPosition, zoom: 11.5),
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller){
                    _mapController.complete(controller);
                  },
                  myLocationEnabled: true,
                  compassEnabled: true,
                  markers: appState.markers,
                  onCameraMove: appState.onCameraMove,
                  polylines: appState.polyLines,
                ),),
            ),

            ClipRRect(
                borderRadius:  const BorderRadius.only(
            topLeft: Radius.circular(12),
        topRight: Radius.circular(12)
    ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height/2,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0,bottom: 12),
                      child: Center(child: Text("Available Drivers (${appState.driversUpdatesLocations.length})"),),
                    ),
                    SizedBox(
                      height: 350,
                      child:appState.loading ? Center(
                        child: Image.asset("assets/images/100153-loader-loading-animation.gif",width: 50,height: 50,),
                      ):  ListView.builder(
                          itemCount: appState.driversUpdatesLocations != null ? appState.driversUpdatesLocations.length : 0,
                          itemBuilder: (context,index){
                            return Card(
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Expanded(child: Image.asset("assets/images/taxinet_cab.png",width: 20,height: 20,)),
                                    Expanded(
                                      child: Text("${appState.driversUpdatesLocations[index]['username'].toString().capitalize}",style: const TextStyle(color: Colors.grey,fontSize: 15),),
                                    ),
                                    Expanded(child: Text("${appState.allDriversLocationMinutes[index]} away",style: const TextStyle(color: Colors.grey,fontSize: 13),)),
                                  ],
                                ),
                                onTap: (){
                                  showMaterialModalBottomSheet(
                                    context: context,
                                    builder: (context) => SingleChildScrollView(
                                      controller: ModalScrollController.of(context),
                                      child: SizedBox(
                                        height: 300,
                                        child: Column(
                                          children: [
                                            Center(
                                              child: Image.asset("assets/images/taxinet_cab.png",width: 150,height: 120,),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 18.0,right: 18.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(child: Text("${appState.driversUpdatesLocations[index]['username'].toString().capitalize}",style: const TextStyle(color: Colors.grey,fontSize: 20,fontWeight: FontWeight.bold),),),
                                                  Expanded(child: Text("${appState.allDriversLocationMinutes[index]} away",style: const TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.bold),)),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 18.0,right: 18.0,top: 10,bottom: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  const Expanded(child: Text("Your location is: ",style: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.bold),)),
                                                  
                                                  Expanded(child: Text(appState.getMyLocationName,style: const TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.bold),)),
                                                ],
                                              ),
                                            ),
                                            isPosting ? const Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 6,
                                                color: primaryColor,
                                              ),
                                            ) : RawMaterialButton(
                                              onPressed: (){
                                                _startPosting();
                                                setState(() {
                                                  isPosting = true;
                                                });
                                                appState.requestRide(uToken, appState.driversUpdatesLocations[index]['driver'], userId, appState.myLocationName, appState.sDestination);
                                                if(appState.wasSuccess){
                                                  Get.back();
                                                  showMaterialModalBottomSheet(
                                                    context: context,
                                                    builder: (context) => SingleChildScrollView(
                                                      controller: ModalScrollController.of(context),
                                                      child: SizedBox(
                                                        height: 300,
                                                        child: Column(
                                                          children: [
                                                            RichText(
                                                              text: TextSpan(
                                                                text: "Your request is sent,please wait for driver to accept and provide you with the charge for your trip.Please if you are not okay with price,please feel free and hit the bid button and enter your bid",
                                                                style: DefaultTextStyle.of(context).style,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12)
                                              ),
                                              elevation: 8,
                                              child: const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Confirm",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                      color: defaultTextColor2),
                                                ),
                                              ),
                                              fillColor: primaryColor,
                                              splashColor: defaultColor,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> goToPlace(Places place) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(place.geometry.location.lat, place.geometry.location.lng),
        zoom: 11.5)));
  }
}

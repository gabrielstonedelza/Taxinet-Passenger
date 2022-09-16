import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:taxinet/passenger/home/pages/completeset.dart';
import '../../constants/app_colors.dart';
import '../../g_controller/userController.dart';
import '../../mapscontroller.dart';
import '../../states/schedule_state.dart';
import 'locateonmap.dart';
import 'locatepickuponmap.dart';
import 'package:http/http.dart' as http;

class ScheduleRide extends StatefulWidget {
  const ScheduleRide({Key? key}) : super(key: key);

  @override
  State<ScheduleRide> createState() => _ScheduleRideState();
}

class _ScheduleRideState extends State<ScheduleRide> {
  List scheduleOptions =[
    "Select Schedule Type",
    "One Time",
    "Daily",
    "Days",
    "Weekly",
    "Until Cancelled"
  ];

  List priorities = [
    "Select Schedule Priority",
    "High",
    "Low"
  ];

  String _currentSelectedScheduleType = "Select Schedule Type";

  String _currentSelectedPriority = "Select Schedule Priority";

  late final  TextEditingController _scheduleTitleController = TextEditingController();

  late final  TextEditingController _scheduleDescriptionController = TextEditingController();

  late final  TextEditingController _pickUpLocationController = TextEditingController();

  late final  TextEditingController _dropOffLocationController =  TextEditingController();

  late final  TextEditingController _pickUpTimeController = TextEditingController();

  late final  TextEditingController _startDateController = TextEditingController();

  final FocusNode _scheduleTitleFocusNode = FocusNode();

  final FocusNode _scheduleDescriptionFocusNode = FocusNode();

  final FocusNode _pickUpLocationFocusNode = FocusNode();

  final FocusNode _dropOffLocationFocusNode = FocusNode();

  var uToken = "";
  final storage = GetStorage();
  var username = "";
  UserController userController = Get.find();

  final _formKey = GlobalKey<FormState>();
  late DateTime _dateTime;
  TimeOfDay _timeOfDay = const TimeOfDay(hour: 8, minute: 30);
  bool isPosting = false;
  final MapController _mapController = Get.find();

  scheduleRide() async {
    const requestUrl = "https://taxinetghana.xyz/request_ride/new/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    }, body: {
      "schedule_title": _scheduleTitleController.text,
      "schedule_type": _currentSelectedScheduleType,
      "schedule_priority": _currentSelectedPriority,
      "schedule_description": _scheduleDescriptionController.text,
      "pickup_location": _pickUpLocationController.text,
      "drop_off_location": _dropOffLocationController.text,
      "pick_up_time": _pickUpTimeController.text,
      "start_date": _startDateController.text,
    });
    if (response.statusCode == 201) {

      Get.snackbar("Success 😀", "request sent.",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          colorText: defaultTextColor1);
      setState(() {
        _scheduleTitleController.text = "";
        _currentSelectedScheduleType = "Select Schedule Type";
        _currentSelectedPriority = "Select Schedule Priority";
        _scheduleDescriptionController.text = "";
        _pickUpLocationController.text = "";
        _dropOffLocationController.text = "";
        _pickUpTimeController.text = "";
        _startDateController.text = "";
      });
    }
    else{
      if (kDebugMode) {
        print(response.body);
      }
      Get.snackbar("Sorry 😢", "something went wrong,please try again later.",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: defaultTextColor1);
    }
  }

  void _startPosting()async{
    setState(() {
      isPosting = true;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      isPosting = false;
    });
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size  = MediaQuery.of(context).size;
    final scheduleState = Provider.of<ScheduleState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule Ride",style:TextStyle(color: defaultTextColor2)),
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
      body: ListView(
        children: [
          const SizedBox(height: 10,),
         userController.referral == "" ? Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             const SizedBox(height: 150,),
             const Center(
               child: Text("You need to provide one referral from Taxinet first",style:TextStyle(fontWeight:FontWeight.bold))
             ),
             const SizedBox(height: 10,),
             RawMaterialButton(
               onPressed: () {
                  Get.to(() => const CompleteSetUp());
               },
               shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(10)
               ),
               elevation: 8,
               fillColor: primaryColor,
               splashColor: defaultColor,
               child: const Padding(
                 padding: EdgeInsets.all(8.0),
                 child: Text(
                   "Go to setup",
                   style: TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: 20,
                       color: Colors.white),
                 ),
               ),
             )
           ],
         ) : Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0,right: 10),
                        child: TextFormField(
                          controller: _scheduleTitleController,
                          focusNode: _scheduleTitleFocusNode,
                          autocorrect: true,
                          enableSuggestions: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Schedule Title",
                            hintStyle: TextStyle(color: defaultTextColor2,),
                          ),
                          cursorColor: defaultTextColor2,
                          style: const TextStyle(color: defaultTextColor2),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter Title";
                            }
                            else{
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0,right: 10),
                        child: TextFormField(
                          autocorrect: true,
                          enableSuggestions: true,
                          controller: _scheduleDescriptionController,
                          focusNode: _scheduleDescriptionFocusNode,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Description",
                            hintStyle: TextStyle(color: defaultTextColor2),

                          ),
                          cursorColor: defaultTextColor2,
                          style: const TextStyle(color: defaultTextColor2),
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,

                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter Description";
                            }
                            else{
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                        child: DropdownButton(
                          hint: const Text("Select Schedule Type"),
                          isExpanded: true,
                          underline: const SizedBox(),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                          items: scheduleOptions.map((dropDownStringItem) {
                            return DropdownMenuItem(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem),
                            );
                          }).toList(),
                          onChanged: (newValueSelected) {
                            _onDropDownItemSelectedScheduleType(newValueSelected);
                          },
                          value: _currentSelectedScheduleType,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                        child: DropdownButton(
                          hint: const Text("Select Schedule Priority"),
                          isExpanded: true,
                          underline: const SizedBox(),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                          items: priorities.map((dropDownStringItem) {
                            return DropdownMenuItem(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem),
                            );
                          }).toList(),
                          onChanged: (newValueSelected) {
                            _onDropDownItemSelectedPriority(newValueSelected);
                          },
                          value: _currentSelectedPriority,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  GetBuilder<MapController>(builder: (controller){
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0,right: 10),
                          child: TextFormField(
                            readOnly:true,
                            autocorrect: true,
                            controller: _pickUpLocationController..text=controller.pickUpLocation,
                            focusNode: _pickUpLocationFocusNode,
                            decoration: InputDecoration(
                              prefixIcon: IconButton(
                                  onPressed: () async{
                                    Get.to(() =>  LocatePickUpOnMap(pickUp:"PickUp"));
                                  },
                                  icon: const Icon(Icons.location_on,color:Colors.green)
                              ),
                              border: InputBorder.none,
                              hintText: "Pick Up Location",
                              hintStyle: const TextStyle(color: defaultTextColor2),
                            ),
                            cursorColor: defaultTextColor2,
                            style: const TextStyle(color: defaultTextColor2),
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,

                            validator: (value){
                              if(value!.isEmpty){
                                return "Enter Pick Up Location";
                              }
                              else{
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 15,),
                  GetBuilder<MapController>(builder: (controller){
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0,right: 10),
                          child: TextFormField(
                            readOnly:true,
                            autocorrect: true,
                            controller: _dropOffLocationController..text=controller.dropOffLocation,
                            focusNode: _dropOffLocationFocusNode,
                            decoration: InputDecoration(
                              prefixIcon: IconButton(
                                  onPressed: () async{
                                    Get.to(() => LocateOnMap(dropOff:"DropOff"));
                                  },
                                  icon: const Icon(Icons.location_on,color:Colors.red)
                              ),
                              border: InputBorder.none,
                              hintText: "Drop Off Location",
                              hintStyle: const TextStyle(color: defaultTextColor2),

                            ),
                            cursorColor: defaultTextColor2,
                            style: const TextStyle(color: defaultTextColor2),
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,

                            validator: (value){
                              if(value!.isEmpty){
                                return "Enter Drop Off Location";
                              }
                              else{
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(

                      controller: _startDateController,
                      cursorColor: primaryColor,
                      cursorRadius: const Radius.elliptical(10, 10),
                      cursorWidth: 10,
                      readOnly: true,
                      style: const TextStyle(color: defaultTextColor2),
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.event,color: secondaryColor,),
                            onPressed: (){
                              showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2080)
                              ).then((value) {
                                setState(() {
                                  _dateTime = value!;
                                  _startDateController.text = _dateTime.toString().split("00").first;
                                });
                              });
                            },
                          ),
                          labelText: "click on icon to pick start date",
                          labelStyle: const TextStyle(color: defaultTextColor2),

                          focusColor: primaryColor,
                          fillColor: primaryColor,
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: primaryColor, width: 2),
                              borderRadius: BorderRadius.circular(12)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please pick a start date";
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      controller: _pickUpTimeController,
                      cursorColor: primaryColor,
                      cursorRadius: const Radius.elliptical(10, 10),
                      cursorWidth: 10,
                      readOnly: true,
                      style: const TextStyle(color: defaultTextColor2),
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.access_time,color: secondaryColor,),
                            onPressed: (){
                              showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                                setState(() {
                                  _timeOfDay = value!;
                                  _pickUpTimeController.text = _timeOfDay.format(context).toString();
                                });
                              });
                            },
                          ),
                          labelText: "Click on icon to pick up time",
                          labelStyle: const TextStyle(color: defaultTextColor2),

                          focusColor: primaryColor,
                          fillColor: primaryColor,
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: primaryColor, width: 2),
                              borderRadius: BorderRadius.circular(12)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please pick a start date";
                        }
                      },
                    ),
                  ),
                isPosting ? const Center(
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 5,
                    backgroundColor: primaryColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.black
                    ),
                  ),
                ) :  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: primaryColor
                    ),
                    height: size.height * 0.06,
                    width: size.width * 0.6,
                    child: RawMaterialButton(
                      onPressed: () {
                        setState(() {
                          isPosting = true;
                        });
                        _startPosting();
                        if (_formKey.currentState!.validate()) {
                          scheduleRide();

                        } else {
                          Get.snackbar("Error", "Something went wrong",
                              colorText: defaultTextColor2,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red
                          );
                          return;
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      ),
                      elevation: 8,
                      fillColor: primaryColor,
                      splashColor: defaultColor,
                      child: const Text(
                        "Request",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: defaultTextColor2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDropDownItemSelectedScheduleType(newValueSelected) {
    setState(() {
      _currentSelectedScheduleType = newValueSelected;
    });
  }

  void _onDropDownItemSelectedPriority(newValueSelected) {
    setState(() {
      _currentSelectedPriority = newValueSelected;
    });
  }
}

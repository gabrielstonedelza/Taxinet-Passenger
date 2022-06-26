import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_colors.dart';
import '../../states/app_state.dart';

class BiddingPage extends StatefulWidget {
  String rideId;
  String driver;
  BiddingPage({Key? key,required this.rideId,required this.driver}) : super(key: key);

  @override
  State<BiddingPage> createState() => _BiddingPageState(rideId:this.rideId,driver:this.driver);
}

class _BiddingPageState extends State<BiddingPage> {
  String rideId;
  String driver;
  _BiddingPageState({required this.rideId,required this.driver});

  var uToken = "";
  final storage = GetStorage();
  var username = "";
  late Timer _timer;
  late final TextEditingController _priceController = TextEditingController();
  final FocusNode _priceFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var items;
  late List userProfile = [];
  late List userData = [];
  var userId = "";
  var profilePic = "";
  var taxinetNumber = "";
  var carName = "";
  var carModel = "";
  var licensePlate = "";
  bool verified = false;
  String phoneNumber = "";
  late List driverDetails = [];

  Future<void> callDriver(String url)async{
    if(await canLaunch(url)){
      await launch(url);
    }
    else{
      Get.snackbar("Sorry", "There was an error trying to call driver");
    }
  }


  bidPrice() async {
    final bidUrl = "https://taxinetghana.xyz/bid_ride/$rideId/";
    final myLink = Uri.parse(bidUrl);
    http.Response response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    }, body: {
      "ride": rideId,
      "bid": _priceController.text,
    });
    if (response.statusCode == 201) {
    } else {}
  }

  Future<void> getDriverProfile() async {
    final profileUrl = "https://taxinetghana.xyz/get_drivers_profile/$driver";
    final myProfile = Uri.parse(profileUrl);
    final response =
    await http.get(myProfile, headers: {"Authorization": "Token $uToken"});

    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      userProfile = json.decode(jsonData);
      for (var i in userProfile) {
       setState(() {
         profilePic = i['driver_profile_pic'];
         carName = i['car_name'];
         carModel = i['car_model'];
         verified = i['verified'];
         licensePlate = i['license_plate'];
         taxinetNumber = i['taxinet_number'];
       });
      }
    } else {
      Get.snackbar("Error", "Unsuccessful getting drivers information,please try again",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red);
    }
  }

  Future<void> getDriverDetails() async {
    final profileUrl = "https://taxinetghana.xyz/get_drivers_details/$driver";
    final myProfile = Uri.parse(profileUrl);
    final response =
    await http.get(myProfile, headers: {"Authorization": "Token $uToken"});

    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      driverDetails = json.decode(jsonData);
      for (var i in driverDetails) {
        setState(() {
          phoneNumber = i['phone_number'];
        });
      }
    } else {
      Get.snackbar("Error", "Unsuccessful getting drivers information,please try again",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red);
    }
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
    getDriverProfile();
    getDriverDetails();
    final appState = Provider.of<AppState>(context, listen: false);
    appState.getBids(rideId, uToken);
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      appState.getBids(rideId, uToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Bid Price"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: RichText(
                text: const TextSpan(
                    text:
                    "Please don't leave this page until the bidding is finalised by you and the driver",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: defaultTextColor2))),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _priceController,
                focusNode: _priceFocusNode,
                cursorColor: defaultTextColor2,
                cursorRadius: const Radius.elliptical(10, 10),
                cursorWidth: 5,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: primaryColor,
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (_priceController.text == "") {
                          Get.snackbar("Sorry", "price field cannot be empty",
                              snackPosition: SnackPosition.TOP,
                              colorText: defaultTextColor1,
                              backgroundColor: Colors.red);
                        } else {
                          bidPrice();
                          _priceController.text = "";
                        }
                      },
                    ),
                    hintText: "Enter price",
                    hintStyle: const TextStyle(
                      color: defaultTextColor2,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(12)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
                keyboardType: TextInputType.text,
              ),
            ),
          ),
          Consumer<AppState>(builder: (context,appState,child){
            return Column(
              children: [
                SizedBox(
                  height: 500,
                  child:  ListView.builder(
                      itemCount: appState.allBids != null
                          ? appState.allBids.length
                          : 0,
                      itemBuilder: (context, index) {
                        items = appState.allBids[index];

                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Card(
                            child: Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                                "${items['username']}'s bid")),
                                        Expanded(
                                          child: items['bid_message'] != null
                                              ? Text("GHS ${items['bid_message']}")
                                              : const Text(""),
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                        padding:
                                        const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          items['bid'],
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                IconButton(
                  onPressed: (){
                    showMaterialModalBottomSheet(
                      context: context,
                      builder: (context) => SingleChildScrollView(
                        controller: ModalScrollController.of(context),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18.0,top: 18.0),
                                    child: CircleAvatar(
                                      backgroundColor: primaryColor,
                                      child: IconButton(
                                        icon: const Icon(Icons.close,color: Colors.white,),
                                        onPressed: () {
                                          Get.back();
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              CircleAvatar(
                                backgroundImage: NetworkImage(profilePic),
                                radius: 50,
                              ),
                              const SizedBox(height: 10,),
                              Center(
                                child: Text(taxinetNumber,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                              ),
                              const SizedBox(height: 10,),
                              Center(
                                child: Text(carName,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                              ),
                              const SizedBox(height: 10,),
                              Center(
                                child: Text(carModel,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                              ),
                              const SizedBox(height: 10,),
                              verified ? Image.asset("assets/images/check.png",width: 70,height: 70,) : Container(),
                              const SizedBox(height: 10,),
                              Center(
                                child: Text("$taxinetNumber is verified",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.info,size: 50,color: Colors.amber,),
                )
                ,
              ],
            );
          },),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: (){
          callDriver("tel:$phoneNumber");
        },
        child: const Icon(Icons.call,color: Colors.white,size: 20,),
      ),
    );
  }
}

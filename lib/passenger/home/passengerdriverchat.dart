import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:taxinet/constants/app_colors.dart';

import '../../g_controller/schedulescontroller.dart';

class PassengerDriverChat extends StatefulWidget {
  String id;
  String name;
  String picture;
  String passenger;
  PassengerDriverChat({Key? key,required this.id,required this.name,required this.picture,required this.passenger}) : super(key: key);

  @override
  State<PassengerDriverChat> createState() => _PassengerDriverChatState(id:this.id,name:this.name,picture:this.picture,passenger:this.passenger);
}

class _PassengerDriverChatState extends State<PassengerDriverChat> {
  String id;
  String name;
  String picture;
  String passenger;
  _PassengerDriverChatState({required this.id,required this.name,required this.picture,required this.passenger});
  final storage = GetStorage();
  late String username = "";
  late String uToken = "";
  var items;
  bool isFieldEmpty = false;
  TextEditingController messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _messageFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  ScheduleController scheduleController = Get.find();
  late Timer _timer;
  bool isLoading = true;
  List allMessages = [];
  bool _needsScroll = false;


  sendMessage() async {
    final depositUrl = "https://taxinetghana.xyz/send_message/$id/";
    final myLink = Uri.parse(depositUrl);
    final res = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    }, body: {
      "ride": id,
      "user": passenger,
      "message": messageController.text,
    });
    if (res.statusCode == 201) {

      setState(() {
        messageController.text = "";
        _needsScroll = true;
      });

    } else {
      if (kDebugMode) {
        print(res.body);
      }
      Get.snackbar("Error", "Something went wrong,please try again later",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5));
    }
  }
  List messages = [];
  scrollToBottom(){
    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds:300), curve: Curves.easeOut);
  }

  Future<void> getDetailScheduleMessages() async {
    final walletUrl = "https://taxinetghana.xyz/get_all_ride_messages/$id/";
    var link = Uri.parse(walletUrl);
    http.Response response = await http.get(link, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    });
    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var data = const Utf8Decoder().convert(codeUnits);
      messages = json.decode(data);
      allMessages.assignAll(messages);

    }
    setState(() {
      isLoading = false;
    });

  }


  @override
  void initState() {
    super.initState();
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    getDetailScheduleMessages();
    // scheduleController.getDetailScheduleMessages(id,uToken);
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      // scheduleController.getDetailScheduleMessages(id,uToken);
      getDetailScheduleMessages();

    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor:primaryColor,
          elevation:0,
        title: Row(
          children: [
             CircleAvatar(
              backgroundImage: NetworkImage(picture),
              radius: 25,
            ),
            const SizedBox(width: 10),
            Text(name)
          ],
        )
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: isLoading ? Center(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator.adaptive(
                      strokeWidth: 5,
                      backgroundColor: Colors.white
                    ),
                    SizedBox(height:10),
                    Center(
                      child: Text("Fetching your messages")
                    )
                  ],
                )
              )  : ListView.builder(
                controller:_scrollController,
                itemCount: allMessages != null ? allMessages.length : 0,
                  itemBuilder: (context,index){
                  items = allMessages[index];
                  if(index == allMessages.length){
                    return Container(
                      height:70
                    );
                  }
                    return SlideInUp(
                      animate: true,
                      child: Row(
                        mainAxisAlignment: items['get_user_type'] == "Passenger" ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          Container(
                              width: 35,
                              height:35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                  image: DecorationImage(
                                      image: NetworkImage(items['get_profile_pic']),
                                      fit: BoxFit.cover
                                  )
                              )
                          ),

                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width:150,
                                  decoration: BoxDecoration(
                                      color: items['get_user_type'] == "Passenger" ? Colors.blue : Colors.green,
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal:20.0,vertical:20.0),
                                  child: Text(items['message'],style:const TextStyle(color:Colors.white))
                              )
                              ,
                              const SizedBox(height:10),
                              Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: Text(items['time_sent'].split('.').first,style:const TextStyle(color:muted)),
                              ),
                              const SizedBox(height:10),
                            ],
                          )
                        ],
                      ),
                    );
                  }
              ),
            ),
          ),

          
          SafeArea(
            child:Row(
              children: [
                Expanded(child: Container(
                    padding: const EdgeInsets.symmetric(horizontal:5.0),
                    height:50,
                    decoration: const BoxDecoration(
                        color:Colors.grey,
                        // borderRadius: BorderRadius.circular(40)
                    ),
                    child: GestureDetector(
                      onTap: () {
                        scrollToBottom();
                      },
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: messageController,
                            focusNode: _messageFocusNode,
                            cursorColor: defaultTextColor2,
                            decoration: InputDecoration(
                              hintText: "Type Message",
                              border:InputBorder.none,
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  color: primaryColor,
                                ),
                                onPressed: () {

                                  if (messageController.text == "") {
                                    Get.snackbar("Sorry", "field cannot be empty",
                                        snackPosition: SnackPosition.TOP,
                                        colorText: defaultTextColor1,
                                        backgroundColor: Colors.red);
                                  } else {
                                    FocusScope.of(context).unfocus();
                                    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds:300), curve: Curves.easeOut);
                                    sendMessage();
                                    messageController.text = "";
                                  }
                                },
                              ),
                            )
                        ),
                      ),
                    )
                )),
              ],
            )
          )
        ],
      ),
    );
  }
}

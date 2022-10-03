import "package:flutter/material.dart";

class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(
                child: Text("Oh no 😱",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30)),
              ),
              Center(
                child: Text("You have no Internet connection",style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              SizedBox(height:10),
              Center(
                child: Text("Please connect to the Internet "),
              ),
              Center(
                child: Text("or wait for your network connection"),
              ),

            ],
          )
      ),
    );
  }
}

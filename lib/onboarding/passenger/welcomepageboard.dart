import "package:flutter/material.dart";

import '../../constants/app_colors.dart';

Widget buildPage(Color color,String image,String title,String subtitle){
  return Container(
      color: color,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image,fit: BoxFit.cover,width:double.infinity),
          const SizedBox(height:20),
          Text(title,style: const TextStyle(fontWeight: FontWeight.bold,fontSize:20)),
          const SizedBox(height:20),
          Container(
              padding: const EdgeInsets.all(20),
              child: Text(subtitle)
          )
        ],
      )
  );
}

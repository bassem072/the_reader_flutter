import 'package:flutter/material.dart';
import 'package:thereader/constant.dart';
import 'package:thereader/Screens/Splash.dart';

void main()async{
  runApp(
    MaterialApp(
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      title: 'The Reader',
      theme: ThemeData(
        //primarySwatch: Colors.blue,
        fontFamily: 'Avenir',
        primaryColor: kBackgroundColor,
        textTheme: TextTheme(bodyText1: TextStyle(color: kTextColor)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    ),
  );
}


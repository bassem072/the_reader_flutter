import 'package:flutter/material.dart';
import 'package:thereader/constant.dart';

Widget loading(){
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: kGradientColors,
        stops: [0.1, 0.4, 0.7, 0.9],
      ),
    ),
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
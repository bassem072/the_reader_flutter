import 'package:flutter/material.dart';
import 'package:thereader/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thereader/Screens/Login.dart';
import 'package:thereader/Screens/Home.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  Future<String> getUser() async{
    print(6);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String apiToken = pref.getString('api_token');
    print(apiToken);
    String url = "https://young-mesa-16194.herokuapp.com/api/user?api_token=$apiToken";
    print(url);
    final http.Response response = await http.get(
      url,
    );
    print(7);
    if(response.statusCode == 200){
      var body = json.decode(response.body);
      print(1);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(user: body,)));
    } else {
      print(4);
      getUser();
    }
    print(5);
    return 'Success';
  }

  isRemember()async{
    Timer(Duration(seconds: 3), () async{
      SharedPreferences pref = await SharedPreferences.getInstance();
      if(pref.containsKey('remember')){
        if(pref.getBool('remember')){
          getUser();
        }else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        }
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isRemember();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: kGradientColors,
            stops: [0.1, 0.4, 0.7, 0.9],
          ),
        ),
        child: Center(
          child: Image.asset('assets/images/splash.png', height: 200, width: 200,),
        ),
      ),
    );
  }
}
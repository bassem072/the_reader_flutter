import 'package:flutter/material.dart';
import 'package:thereader/constant.dart';
import 'package:thereader/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thereader/Screens/Login.dart';

import 'info.dart';

class Body extends StatelessWidget {

  const Body({
    Key key,
    @required this.user,
  }) : super(key: key);
  final Map user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: kGradientColors,
          stops: [0.1, 0.4, 0.7, 0.9],
        ),
      ),
      child: Column(
        children: <Widget>[
          Info(
            image: "assets/images/avatar.png",
            name: "${user['first_name']} ${user['last_name']}",
            email: "${user['email']}",
          ),
          SizedBox(height: SizeConfig.defaultSize * 2), //20
          GestureDetector(
            child: Container(
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white54, fontSize: 18.0),
              ),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0,),
                color: kTextLightColor,
              ),
            ),
            onTap: ()async{
              SharedPreferences pref = await SharedPreferences.getInstance();
              if(pref.containsKey('remember')){
                if(pref.getBool('remember')){
                  pref.setBool('remember', false);
                }
              }
              pref.remove('api_token');
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}

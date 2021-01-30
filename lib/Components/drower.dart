import 'package:flutter/material.dart';
import 'package:thereader/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thereader/Screens/Profile.dart';
import 'package:thereader/Screens/Login.dart';

class CustomDrawer extends StatefulWidget{
  final Function closeDrawer;
  final Map user;

  const CustomDrawer({
    Key key,
    this.closeDrawer,
    @required this.user,
  }) : super(key: key);
  State<StatefulWidget> createState() => _CustomDrawerState(
    closeDrawer: closeDrawer,
    user: user,
  );
}

class _CustomDrawerState extends State<CustomDrawer> {

  final Function closeDrawer;

  _CustomDrawerState({
    this.closeDrawer,
    @required this.user,
  });

  final Map user;
  String message;

  void initState(){
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: kGradientColors,
          stops: [0.1, 0.4, 0.7, 0.9],
        ),
      ),
      width: mediaQuery.size.width * 0.60,
      height: mediaQuery.size.height,
      child: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              height: 200,
              color: kBackgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 10), //10
                    height: 100, //140
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3, //8
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/avatar.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("${user['first_name']} ${user['last_name']}", style: TextStyle(color: Colors.white),)
                ],
              )),
          ListTile(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(
              user: user,
            ))),
            leading: Icon(Icons.person, color: Colors.white,),
            title: Text(
              "Your Profile",
                style: TextStyle(color: Colors.white),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
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
            leading: Icon(Icons.exit_to_app, color: Colors.white,),
            title: Text("Log Out", style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}
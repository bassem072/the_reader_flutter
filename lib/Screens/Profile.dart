import 'package:flutter/material.dart';
import 'package:thereader/size_config.dart';
import 'package:thereader/constant.dart';
import 'package:thereader/Components/Profile/body.dart';
import 'package:thereader/Screens/EditProfile.dart';

class ProfileScreen extends StatefulWidget{

  final Map user;

  ProfileScreen({
    Key key,
    @required this.user,
});

  State<StatefulWidget> createState() => _ProfileScreenState(
    user: user,
  );
}

class _ProfileScreenState extends State<ProfileScreen>{

  final Map user;
  String message;

  _ProfileScreenState({
    @required this.user
  });

  void initState(){
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: buildAppBar(),
      body: Body(user: user,),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kGradientColors[0],
      elevation: 0,
      leading: SizedBox(),
      // On Android it's false by default
      centerTitle: true,
      title: Text("Profile"),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => EditProfileScreen(
                userData: user,
              ))
          ),
          child: Text(
            "Edit",
            style: TextStyle(
              color: Colors.white,
              fontSize: SizeConfig.defaultSize * 1.6, //16
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
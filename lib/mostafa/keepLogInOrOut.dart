
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var email = preferences.getString('email');
  runApp(MaterialApp(home: email==null ? login() : logout(),));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: login(),
    );
  }
}


class login extends StatelessWidget{
  String email = "a@a.com"; //Should come from Text field
  bool valid = true;
  bool boxCheck = true;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Center(
        child: FlatButton(
          color: Colors.blue,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(8.0),
          splashColor: Colors.blueAccent,
          onPressed: () async {
            print('Login Pressed!');
            if(valid && boxCheck){
              SharedPreferences preferences = await SharedPreferences.getInstance();
              preferences.setString('email', email);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> logout()));
            }
          },
          child: Text("Login",),
        ), //write here the order you want to give and run the application
      ),
    );
  }
}

class logout extends StatelessWidget{
  Future logOut( BuildContext context) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('email');
    Navigator.push(context, MaterialPageRoute(builder: (context)=> login(),),);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Logout'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Center(
        child: FlatButton(
          color: Colors.blue,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(8.0),
          splashColor: Colors.blueAccent,
          onPressed: (){
            print('Logout Pressed!');
            logOut(context);
          },
          child: Text("Logout",),
        ), //write here the order you want to give and run the application
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thereader/constant2.dart';
import 'package:thereader/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thereader/models/auth.dart';
import 'dart:convert';
import 'package:thereader/Screens/Home.dart';
import 'package:thereader/Components/errorDialog.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {

  final Map userData;

  EditProfileScreen({
    Key key,
    @required this.userData,
  });

  @override
  State<StatefulWidget> createState() => _EditProfileScreenState(
    userData: userData,
  );
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final Map userData;

  _EditProfileScreenState({
    @required this.userData,
  });

  final first = TextEditingController();
  final last = TextEditingController();
  final password = TextEditingController();
  final password2 = TextEditingController();
  final old = TextEditingController();
  bool _obscureText = true;
  Auth user = Auth();
  String message;
  var body;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  login()async{
    Map<String, String> data = {};
    data['email'] = userData['email'];
    data['password'] = old.text;
    print(data);
    bool isLogin = false;
    String url = "https://young-mesa-16194.herokuapp.com/api/login";
    await user.login(url, data).then((value)async{
      if(value.statusCode == 200) {
        body = json.decode(value.body);
        print(body);
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('api_token', body['token']);
        print(pref.getString('api_token'));
        print(body);
        if (body['status'] == true) {
          isLogin = true;
        }
      }
    });
    return isLogin;
  }

  edit(BuildContext context)async{
    if(old.text.isNotEmpty) {
      bool isLogin = await login();
      print('old is $isLogin');
      if(isLogin){
        if(first.text.isNotEmpty && last.text.isNotEmpty){
          if(password.text.isEmpty){
            password.text = old.text;
            password2.text = old.text;
          }
          if (password.text == password2.text) {
            Map<String, dynamic> data = {};
            data['first'] = first.text;
            data['last'] = last.text;
            data['old'] = old.text;
            data['password'] = password.text;
            data['is_blind'] = '0';
            SharedPreferences pref = await SharedPreferences.getInstance();
            String apiToken = pref.getString('api_token');
            String url = "https://young-mesa-16194.herokuapp.com/api/users/${userData['id']}?api_token=$apiToken";
            print(url);
            final http.Response response = await http.put(
                url,
                body: data
            );
            if (response.statusCode == 200) {
              body = json.decode(response.body);
              print(body);
              if (body['status'] == true) {
                print('success');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen(
                      user: body['user'],
                    )));
              } else {
                print('error');
                setState(() {
                  message = body['messages'].toString();
                  showAlertDialog(context, message, 'Edit Error');
                });
              }
            } else {
              print('Server Error');
              setState(() {
                message = 'Server Error';
                showAlertDialog(context, message, 'Edit Error');
              });
            }
          }else{
            showAlertDialog(context, 'Password and Repeated Password Is Diferant', 'Edit Falid');
          }
        }else{
          showAlertDialog(context, 'First And Last Name Must Be Not Empty', 'Edit Falid');
        }
      }else{
       showAlertDialog(context, 'Old Password Is Wrong', 'Edit Falid');
      }
    }else{
      showAlertDialog(context, 'Old Password Is Empty', 'Edit Falid');
    }
  }

  Widget _buildTF(text, controller, icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          text,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                icon,
                color: Colors.white,
              ),
              hintText: 'Enter your $text',
              hintStyle: kHintTextStyle,
            ),
            controller: controller,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF(text, controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          text,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: _obscureText,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              suffixIcon: GestureDetector(
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: _obscureText ? Colors.white : Colors.blue,
                ),
                onTap: (){
                  _toggle();
                },
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
            controller: controller,
          ),
        ),
      ],
    );
  }

  Widget _buildEditBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => edit(context),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    first.text = userData['first_name'];
    last.text = userData['last_name'];
    password.text = '';
    password2.text = '';
    old.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: kGradientColors,
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 100.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildTF('First Name', first, Icons.person),
                      SizedBox(height: 30.0),
                      _buildTF('Last Name', last, Icons.person),
                      SizedBox(height: 30.0),
                      _buildPasswordTF('Password', password),
                      SizedBox(height: 30.0),
                      _buildPasswordTF('Repeate Password', password2),
                      SizedBox(height: 30.0),
                      _buildPasswordTF('Old Password*', old),
                      SizedBox(height: 30.0),
                      _buildEditBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
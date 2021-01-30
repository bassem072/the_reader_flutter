import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thereader/constant2.dart';
import 'package:thereader/constant.dart';
import 'package:thereader/Screens/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thereader/models/auth.dart';
import 'dart:convert';
import 'package:thereader/Screens/Home.dart';
import 'package:thereader/Components/errorDialog.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final first = TextEditingController();
  final last = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final password2 = TextEditingController();
  bool _obscureText = true;
  Auth user = Auth();
  String message;
  var body;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  isEmpty() {
    if (first.text == null || first.text.isEmpty) {
      return true;
    }
    if (last.text == null || last.text.isEmpty) {
      return true;
    }
    if (email.text == null || email.text.isEmpty) {
      return true;
    }
    if (password.text == null || password.text.isEmpty) {
      return true;
    }
    if (password2.text == null || password2.text.isEmpty) {
      return true;
    }
    return false;
  }

  register(BuildContext context){
    if(isEmpty()){
      showAlertDialog(context, "Must All Feilds Is Not Empty", 'Sign Up Error');
    }else{
      if(password.text == password2.text) {
        Map<String, dynamic> data = {};
        data['first'] = first.text;
        data['last'] = last.text;
        data['email'] = email.text;
        data['password'] = password.text;
        data['is_blind'] = '0';
        String url = "https://young-mesa-16194.herokuapp.com/api/register";
        user.login(url, data).then((value) async {
          if (value.statusCode == 200) {
            body = json.decode(value.body);
            print(body);
            if (body['status'] == true) {
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.setString('api_token', body['token']);
              print(pref.getString('api_token'));
              print('success');
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(
                user: body['user'],
              )));
            } else {
              print('error');
              setState(() {
                message = body['messages'].toString();
                showAlertDialog(context, message, 'Sign Up Error');
              });
            }
          } else {
            print('Server Error');
            setState(() {
              message = 'Server Error';
              showAlertDialog(context, message, 'Sign Up Error');
            });
          }
        });
      }else{
        showAlertDialog(context, "Password And Repeated Password Are Different", 'Sign Up Error');
      }
    }
  }

  Widget _buildTF(text, controller, icon, type) {
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
            keyboardType: type ? TextInputType.emailAddress : TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
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

  Widget _buildSignupBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => register(context),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Sign Up',
          style: TextStyle(
            color: kBackgroundColor,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return GestureDetector(
      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen())),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Do you already have an account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Login',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
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
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildTF('First Name', first, Icons.person, false),
                      SizedBox(height: 30.0),
                      _buildTF('Last Name', last, Icons.person, false),
                      SizedBox(height: 30.0),
                      _buildTF('Email', email, Icons.email, true),
                      SizedBox(height: 30.0),
                      _buildPasswordTF('Password', password),
                      SizedBox(height: 30.0),
                      _buildPasswordTF('Repeate Password', password2),
                      SizedBox(height: 30.0),
                      _buildSignupBtn(),
                      _buildLoginBtn(),
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
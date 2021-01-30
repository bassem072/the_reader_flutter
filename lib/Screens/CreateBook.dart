import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thereader/constant2.dart';
import 'package:thereader/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:thereader/Screens/CreatePage.dart';
import 'package:thereader/Components/errorDialog.dart';

class CreateBookScreen extends StatefulWidget{

  final Map user;

  CreateBookScreen({
    Key key,
    @required this.user,
  });

  @override
  State<StatefulWidget> createState() => _CreateBookScreenState(
    user: user,
  );
}

class _CreateBookScreenState extends State<CreateBookScreen> {

  _CreateBookScreenState({
    @required this.user,
  });

  final name = TextEditingController();
  final author = TextEditingController();
  final description = TextEditingController();
  final publishingHouse = TextEditingController();
  final publishingDate = TextEditingController();
  final noPages = TextEditingController();
  final format = DateFormat("yyyy-MM-dd");
  final Map user;
  Map book;
  String message;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String _status = "public";

  isEmpty() {
    if (name.text == null || name.text.isEmpty) {
      return true;
    }
    if (author.text == null || author.text.isEmpty) {
      return true;
    }
    if (description.text == null || description.text.isEmpty) {
      return true;
    }
    if (publishingHouse.text == null || publishingHouse.text.isEmpty) {
      return true;
    }
    if (publishingDate.text == null || publishingDate.text.isEmpty) {
      return true;
    }
    if (noPages.text == null || noPages.text.isEmpty) {
      return true;
    }
    if (_status == null || _status.isEmpty) {
      return true;
    }
    if(int.parse(noPages.text) > 0){
      return false;
    }else{
      return true;
    }
    return false;
  }

  Future<String> create(BuildContext context) async {
    if(isEmpty()){
      showAlertDialog(context, "Must All Feilds Is Not Empty And Number Of Pages > 0", 'Error');
      return 'Faild';
    }else{
      Map<String, dynamic> data = {};
      data['name'] = name.text;
      data['author'] = author.text;
      data['description'] = description.text;
      data['publishing_house'] = publishingHouse.text;
      data['publishing_date'] = publishingDate.text;
      data['no_pages'] = noPages.text;
      data['status'] = _status;
      data['is_blind'] = 'false';

      print(6);
      SharedPreferences pref = await SharedPreferences.getInstance();
      String apiToken = pref.getString('api_token');
      print(apiToken);
      String url = "https://young-mesa-16194.herokuapp.com/api/books?api_token=$apiToken";
      print(url);
      final http.Response response = await http.post(
          url,
          body: data
      );
      print(7);
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        print(1);
        if (body['status'] == true) {
          print(2);
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => CreatePageScreen(
                bookId: body['book']['id'],
                noPages: int.parse(body['book']['no_pages']),
                user: user,
              )
          ));
        } else {
          print(3);
          message = body['messages'];
          showAlertDialog(context, message, 'Error');
          print(message);
        }
      } else {
        print(4);
        message = 'Server Error';
        showAlertDialog(context, message, 'Error');
      }
      print(5);
      return 'Success';
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
            keyboardType: type ? TextInputType.number : TextInputType.text,
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

  Widget _buildRadioItem(value){
    return Row(
      children: <Widget>[
        Radio(
          value: value,
          groupValue: _status,
          onChanged: (val){
            setState(() {
              _status = val;
            });
            print(_status);
          },
        ),
        SizedBox(width: 10,),
        Text(
          '${value.toString().substring(0, 1).toUpperCase()}${value.toString().substring(1)}',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  _buildDateTF(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Publishing Date',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          padding: EdgeInsets.all(5.0),
          child: DateTimeField(
            format: format,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.date_range,
                color: Colors.white,
              ),
              hintText: 'Enter your Publishing Date',
              hintStyle: kHintTextStyle,
            ),
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime.now());
            },
            controller: publishingDate,
          ),
        ),
      ],
    );
  }

  Widget _buildCreateBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => create(context),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Create',
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

  Widget _buildRadioBtn(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Type',
          style: kLabelStyle,
        ),
        _buildRadioItem("public"),
        _buildRadioItem("private"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                        'Create Book',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildTF('Book Name', name, Icons.book, false),
                      SizedBox(height: 30.0),
                      _buildTF('Auther', author, Icons.person, false),
                      SizedBox(height: 30.0),
                      _buildTF('Description', description, Icons.description, false),
                      SizedBox(height: 30.0),
                      _buildTF('Publishing House', publishingHouse, Icons.home, false),
                      SizedBox(height: 30.0),
                      _buildDateTF(),
                      SizedBox(height: 30.0),
                      _buildTF('Number Of Pages', noPages, Icons.library_books, true),
                      SizedBox(height: 30.0),
                      _buildRadioBtn(),
                      SizedBox(height: 30.0),
                      _buildCreateBtn(),
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
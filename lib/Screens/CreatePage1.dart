import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:thereader/Screens/Home.dart';

class CreatePageScreen extends StatefulWidget{

  const CreatePageScreen({
    Key key,
    @required this.bookId,
    @required this.noPages,
  }): super(key: key);

  final int bookId;
  final int noPages;

  @override
  State<StatefulWidget> createState() => _CreatePageScreenState(
    bookId: bookId,
    noPages: noPages,
  );
}

class _CreatePageScreenState extends State<CreatePageScreen> {

  _CreatePageScreenState({
    @required this.bookId,
    @required this.noPages,
  });
  final int bookId;
  final int noPages;
  final ImagePicker _picker = ImagePicker();
  final textController = TextEditingController();
  PickedFile _storedImage;
  int counter = 1;
  String text = '';
  String message;

  Future<void> _scanPage() async{
    final page = await _picker.getImage(
      source: ImageSource.camera,
      maxWidth: 5000,
      imageQuality: 100,
      maxHeight: 5000,
    );
    //var image = await ImagePicker.pickImage(source: ImageSource.\);

    setState((){
      _storedImage = page;
      text = '';
    });
  }

  Future<void> _getPage() async{
    final page = await _picker.getImage(
      source: ImageSource.gallery,
      maxWidth: 5000,
      imageQuality: 100,
      maxHeight: 5000,
    );

    setState((){
      _storedImage = page;
      text = '';
    });
  }

  Future<void> recognize() async{
    Dio dio = new Dio();
    Response response;
    print(_storedImage.path);
    print(File(_storedImage.path).path);
    final file = File(_storedImage.path);
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(file.path),
    });
    response = await dio.post(
        "http://35.239.83.160:5000",
        data: formData
    );
    if(response.statusCode == 200){
      var body = response.data.toString();
      setState(() {
        text = body;
        textController.text = body;
        print(text);
      });
      print(body);
    } else {
      print(4);
      print('Server Error');
    }
  }

  Future<String> create() async {
    Map<String, dynamic> data = {};
    data['content'] = textController.text;
    data['id'] = bookId.toString();
    data['page_number'] = counter.toString();

    print(6);
    //String apiToken = getAPIToken();
    SharedPreferences pref = await SharedPreferences.getInstance();
    String apiToken = pref.getString('api_token');
    print(apiToken);
    String url = "https://young-mesa-16194.herokuapp.com/api/pages?api_token=$apiToken";
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
        setState(() {
          text = '';
          _storedImage = null;
        });
        if(counter == noPages) {
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => HomeScreen()));
        }else{
          setState(() {
            counter = counter + 1;
          });
        }
      } else {
        print(3);
        message = body['messages'];
        print(message);
      }
    } else {
      print(4);
      message = 'Server Error';
    }
    print(5);
    return 'Success';
  }

  Widget _textArea(){
    return Card(
        color: Color(0xffe5e5e5),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            maxLines: 8,
            controller: textController,
            onChanged: (val){
              setState(() {
                text = val;
              });
            },
          ),
        ),
    );
  }

  Widget _buildImageBtn() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            child: Container(
              child: Icon(Icons.camera, color: Colors.blue,),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 1.0,),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            onTap: (){
              _scanPage();
            },
          ),
          Spacer(),
          GestureDetector(
            child: Container(
              child: Icon(Icons.photo, color: Colors.blue,),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 1.0,),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            onTap: (){
              _getPage();
            },
          ),
        ],
      ),
    );
  }

  Widget _imageBox(){
    return Container(
      width: 300,
      height: 300,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(
              width: 1,
              color: Colors.grey
          )
      ),
      child: _storedImage != null
          ? Image.file(
            File(_storedImage.path),
            fit: BoxFit.cover,
            width: double.infinity,
          )
          : Text(
            'No Page Selected',
            textAlign: TextAlign.center,
          ),
    );
  }

  Widget _box(){
    if(text != null && text.isNotEmpty){
      return _textArea();
    }else{
      return _imageBox();
    }
  }

  Widget _buildCreateBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => text.isNotEmpty ? create() : recognize(),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          text.isNotEmpty ? 'Create' : 'Recognize',
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
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Create page $counter',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildImageBtn(),
                      SizedBox(height: 30.0),
                      _box(),
                      SizedBox(height: 30.0),
                      _buildCreateBtn()
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
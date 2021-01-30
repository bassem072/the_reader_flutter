import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:thereader/Screens/Home.dart';
import 'package:thereader/constant.dart';
import 'package:thereader/Components/errorDialog.dart';

class CreatePageScreen extends StatefulWidget {

  const CreatePageScreen({
    Key key,
    @required this.bookId,
    @required this.noPages,
    @required this.user,
  }): super(key: key);

  final int bookId;
  final int noPages;
  final Map user;

  @override
  State<StatefulWidget> createState() => _CreatePageScreenState(
    bookId: bookId,
    noPages: noPages,
    user: user,
  );
}

class _CreatePageScreenState extends State<CreatePageScreen> {
  FloatingActionButtonLocation buttonLocation = FloatingActionButtonLocation.centerDocked;
  MainAxisAlignment axisAlignment = MainAxisAlignment.spaceBetween;
  Icon icon = Icon(Icons.backup);
  bool animated = true;
  _CreatePageScreenState({
    @required this.bookId,
    @required this.noPages,
    @required this.user,
  });
  final int bookId;
  final int noPages;
  final Map user;
  final ImagePicker _picker = ImagePicker();
  final textController = TextEditingController();
  PickedFile _storedImage;
  int counter = 1;
  String text = '';
  String message;
  bool isUpload = false;
  Color color = Colors.white;

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
      icon = Icon(Icons.backup, color: color,);
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
      icon = Icon(Icons.backup, color: color,);
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
        icon = Icon(Icons.check, color: color,);
        textController.text = body;
        _storedImage = null;
        print(text);
      });
      print(body);
    } else {
      print(4);
      print('Server Error');
    }
    setState(() {
      isUpload = false;
    });
  }

  Future<void> create() async {
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
          icon = Icon(Icons.backup, color: color,);
        });
        if(counter == noPages) {
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => HomeScreen(
                user: user,
              )));
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
    setState(() {
      isUpload = false;
    });
  }

  Widget _textArea(){
    return Card(
      color: Color(0xffe5e5e5),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          maxLines: 10,
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: kGradientColors[3],
      appBar: AppBar(
        title: Text("Create Page $counter"),
        centerTitle: true,
        backgroundColor: kGradientColors[0],
      ),
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
          child: _box(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: (){
          if(!isUpload) {
            if (text.isNotEmpty) {
              setState(() {
                isUpload = true;
              });
              create();
            } else {
              if (_storedImage != null) {
                setState(() {
                  isUpload = true;
                });
                recognize();
              }
            }
          }else{
            showAlertDialog(context, 'Wait Until Proccess Finished', 'Sign Up Error');
          }
        },
        child: icon,
      ), // This trailing comma makes auto-formatting nicer for build methods.,

      floatingActionButtonLocation: buttonLocation,
      bottomNavigationBar: BottomAppBar(
        color: Colors.deepPurple,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: axisAlignment,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.camera_alt, color: color,),
              color: Colors.white,
              onPressed: (){
                if(!isUpload){
                  _scanPage();
                }else{
                  showAlertDialog(context, 'Wait Until Proccess Finished', 'Sign Up Error');
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.insert_photo, color: color,),
              color: Colors.white,
              onPressed: (){
                if(!isUpload){
                  _getPage();
                }else{
                  showAlertDialog(context, 'Wait Until Proccess Finished', 'Sign Up Error');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

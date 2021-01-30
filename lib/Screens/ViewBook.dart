import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thereader/constant.dart';
import 'package:thereader/Helpers/texttospeect.dart';
import 'package:thereader/Components/loading.dart';
import 'package:thereader/models/book.dart';
import 'package:thereader/Components/errorDialog.dart';
import 'package:thereader/Screens/Home.dart';

class ViewBookScreen extends StatefulWidget {

  final int id;
  final Map user;
  final int noPage;
  ViewBookScreen({
    Key key,
    @required this.id,
    @required this.user,
    @required this.noPage,
  }):super(key: key);

  @override
  State<StatefulWidget> createState() => _ViewBookScreenState(
    id: id,
    user: user,
    noPage: noPage,
  );
}

class _ViewBookScreenState extends State<ViewBookScreen> {

  final int id;
  final Map user;
  final int noPage;
  _ViewBookScreenState({
    @required this.id,
    @required this.user,
    @required this.noPage,
  });


  List pages;
  var book;
  var message;
  bool isLoading = true;
  var speech;
  bool isPlay = false;
  int num = 1;
  FloatingActionButtonLocation buttonLocation = FloatingActionButtonLocation.endDocked;
  MainAxisAlignment axisAlignment = MainAxisAlignment.center;
  Icon icon = Icon(Icons.play_arrow);

  void remove(int id) async{
    bool isRemove = await removeBook(id);
    if(isRemove){
      showAlertDialog(context, 'Book Removed', 'Done');
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => HomeScreen(
            user: user,
          )));
    }else{
      showAlertDialog(context, 'Faild To Remove', 'Error');
      Navigator.of(context).pop();
    }
  }

  getPages() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String apiToken = pref.getString('api_token');
    int bookID = id;
    print(apiToken);
    String url = "https://young-mesa-16194.herokuapp.com/api/pages?api_token=$apiToken&id=$bookID";
    print(url);
    final http.Response response = await http.get(
      url,
    );
    print(7);
    if(response.statusCode == 200){
      var body = json.decode(response.body);
      print(1);
      if(body['status'] == true){
        print(2);
        setState(() {
          pages = body['pages'];
          if(pages.length != noPage){
            remove(bookID);
          }
          speech..newVoiceText = pages[0]['content'];
        });
      }else{
        print(3);
        message = body['messages'];
      }
    } else {
      print(4);
      message = 'Server Error';
    }
    print(5);
    setState(() {
      isLoading = false;
    });
    return 'Success';
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.speech=texttospeech(this);
    speech.setVolume(1.0);
    speech.setrate(0.9);
    speech.setpitch(1.0);
    this.getPages();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text("View Page"),
        centerTitle: true,
        backgroundColor: kGradientColors[0],
      ),
      body: isLoading ?
      Center(
        child: loading(),
      )
          :
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: kGradientColors,
            stops: [0.1, 0.4, 0.7, 0.9],
          ),
        ),
        child: PageView.builder(
          itemCount: pages.length,
          onPageChanged: (index){
            speech.stop();
            speech..newVoiceText = pages[index]['content'];
            setState(() {
              isPlay = false;
              num = index + 1;
              icon = Icon(Icons.play_arrow);
            });
          },
          itemBuilder: (context, index) {
            return SingleChildScrollView(
              child:  Container(
                color: Color(0xffe5e5e5),
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    pages[index]['content'],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: (){
          if(isPlay){
            speech.stop();
            setState(() {
              isPlay = false;
              icon = Icon(Icons.play_arrow);
            });
          }else{
            speech.play();
            setState(() {
              isPlay = true;
              icon = Icon(Icons.pause);
            });
          }
        },
        child: icon,
      ),
      floatingActionButtonLocation: buttonLocation,
      bottomNavigationBar: BottomAppBar(
        color: Colors.deepPurple,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: axisAlignment,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle
              ),
              child: Text(num.toString(), style: TextStyle(fontSize: 15),),
            )
          ],
        ),
      ),
    );
  }

  Color get randomColor =>
      Color(0xffe5e5e5);
}
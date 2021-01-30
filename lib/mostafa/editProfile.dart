import 'package:flutter/material.dart';



void main() async{
  runApp(MaterialApp(home: editprofile(),));
}

class editprofile extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('The Reader',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: SingleChildScrollView(
            child: Padding(padding: EdgeInsets.fromLTRB(30,5,30,5),
              child: Column(
                children: <Widget>[
                  //SizedBox(height: 20,),
                  // GestureDetector(
                  // onTap: (){
                  //  print('change Profile Image!');

                  // },
                  // child: Image.asset('assets/images/books-521812297.jpg',width: 100.0,height: 100.0,),

                  //),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(fit: BoxFit.cover ,image: new NetworkImage('https://media.wired.com/photos/5be4cd03db23f3775e466767/125:94/w_2375,h_1786,c_limit/books-521812297.jpg'))
                    ),
                  ),
                  // SizedBox(height: 20,),
                  //CircleAvatar(
                  // radius: 20,
                  // backgroundImage: NetworkImage('https://media.wired.com/photos/5be4cd03db23f3775e466767/125:94/w_2375,h_1786,c_limit/books-521812297.jpg'),
                  //),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.blue,
                              blurRadius: 10.0,
                              offset: Offset(0, 5)
                          )
                        ]
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[100]))
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "First Name",
                                hintStyle: TextStyle(color: Colors.grey[400])
                            ),
                            initialValue: "Mostafa",
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[100]))
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Last Name",
                                hintStyle: TextStyle(color: Colors.grey[400])
                            ),
                            initialValue: "Hossam",
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[100]))
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey[400])
                            ),
                            initialValue: "Mostafa@gmail.com",
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Old Password",
                                hintStyle: TextStyle(color: Colors.grey[400])
                            ),
                            obscureText: true,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "New Password",
                                hintStyle: TextStyle(color: Colors.grey[400])
                            ),
                            obscureText: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Container(
                  //padding: EdgeInsets.all(8.0),
                  //child: Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  //children: <Widget>[

                  //],
                  //),
                  //),
                  SizedBox(height: 20,),
                  FlatButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () async {
                      print('Save Pressed!');
                    },
                    child: Text("Save",),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:thereader/constant.dart';
import 'package:thereader/Screens/ViewBook.dart';

class BookInfoScreen extends StatelessWidget {
  BookInfoScreen({
    @required this.data,
    @required this.user,
  });
  final data;
  final Map user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Hero(
                tag: Image.asset('assets/images/image_1.jpg', fit: BoxFit.cover, ),
                child: Image.asset(
                  'assets/images/image_1.jpg',
                  fit: BoxFit.cover,
                  colorBlendMode: BlendMode.darken,
                  color: Colors.black.withOpacity(0.7),
                ),
                /*child: Image.network(
                  data['image'],
                  fit: BoxFit.cover,
                  colorBlendMode: BlendMode.darken,
                  color: Colors.black54,
                ),*/
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 32.0),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white,
                      ),
                      Spacer(),
                      Container(
                        width: 240.0,
                        child: Text(
                          data['name'],
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                              fontSize: 42.0
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        data['author'],
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Drama',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        child: Text(
                          data['description'],
                          style: TextStyle(color: Colors.white, height: 1.4),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                data['publishing_house'],
                                style:
                                TextStyle(color: Colors.white, fontSize: 28.0,),
                              ),
                              Text(
                                data['publishing_date'],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 32.0,
                      ),
                      GestureDetector(
                        child: Container(
                          child: Text(
                            'Start Reading',
                            style: TextStyle(color: Colors.white54, fontSize: 18.0),
                          ),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1.0,)
                          ),
                        ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ViewBookScreen(
                            id: data['id'],
                            user: user,
                            noPage: data['no_pages'],
                          ),
                        )),
                      ),
                      SizedBox(
                        height: 32.0,
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thereader/constant.dart';
import 'package:flutter_svg/svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:thereader/Components/drower.dart';
import 'package:thereader/Screens/CreateBook.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:thereader/Screens/BookInfo.dart';
import 'package:thereader/models/book.dart' as book;
import 'package:thereader/Components/errorDialog.dart';
import 'package:thereader/Components/loading.dart';

class HomeScreen extends StatefulWidget{

  final Map user;

  HomeScreen({
    Key key,
    @required this.user,
  }):super(key: key);

  State<StatefulWidget> createState() => _HomeScreenState(
    user: user,
  );
}

class _HomeScreenState extends State<HomeScreen>{

  _HomeScreenState({
    @required this.user,
  });

  FSBStatus drawerStatus;
  String first, last;
  List books, privateBooks = [], publicBooks = [], otherBooks = [];
  List<Widget> items;
  String message;
  final Map user;
  String title = 'Others Books';

  Future<String> show() async{
    print(6);
    //String apiToken = getAPIToken();
    SharedPreferences pref = await SharedPreferences.getInstance();
    String apiToken = pref.getString('api_token');
    print(apiToken);
    String url = "https://young-mesa-16194.herokuapp.com/api/books?api_token=$apiToken";
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
          books = body['books'];
          print("----------------------------------------");
          print(books);
          publicBooks = [];
          privateBooks = [];
          otherBooks = [];
          filter();
          print("----------------------------------------");
          print(publicBooks);
          print("----------------------------------------");
          print(privateBooks);
          print("----------------------------------------");
          print(otherBooks);
          if(title == "Public Books"){
            items = imageShow(publicBooks);
          }else{
            if(title == 'Private Books'){
              items = imageShow(privateBooks);
            }else{
              items = imageShow(otherBooks);
            }
          }
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
    return 'Success';
  }

  void remove(int id) async{
    bool isRemove = await book.removeBook(id);
    if(isRemove){
      showAlertDialog(context, 'Book Removed', 'Done');
      show();
    }else{
      showAlertDialog(context, 'Faild To Remove', 'Error');
    }
  }

  void initState(){
    // TODO: implement initState
    super.initState();
    this.show();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kGradientColors[0],
        title: Text(
          'The Reader',
          style: Theme.of(context).textTheme.headline5.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: "Summer",
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset("assets/icons/menu.svg"),
          onPressed: (){
            setState(() {
              drawerStatus = drawerStatus == FSBStatus.FSB_OPEN ? FSBStatus.FSB_CLOSE : FSBStatus.FSB_OPEN;
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (){
              show();
            },
          ),
        ],
      ),
      body: FoldableSidebarBuilder(
        drawerBackgroundColor: kBackgroundColor,
        drawer: CustomDrawer(closeDrawer: (){
          setState(() {
            drawerStatus = FSBStatus.FSB_CLOSE;
          });
        },
          user: user,
        ),
        screenContents: content(height),
        status: drawerStatus,
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateBookScreen())),
        child: Icon(Icons.add),
      ),*/
    );
  }

  Widget content(double height){
    return books == null
        ?
    Center(
      child: loading(),
    ) :
    Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: kGradientColors,
          stops: [0.1, 0.4, 0.7, 0.9],
        ),
      ),
      padding: EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.25,
                    viewportFraction: 0.44,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                    autoPlay: true,
                  ),
                  items: imageSliders(height),
                ),
              ),
              SizedBox(height: 20,),
              Text(
                title,
                style: TextStyle(
                    fontFamily: 'montserrat',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700
                ),
              ),
              SizedBox(height: 20,),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: items,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,

            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 200,
                  height: 50,

                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Colors.grey.shade200.withOpacity(0.3)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[

                      IconButton(
                        icon: Icon(
                          Icons.collections_bookmark,
                          color: Colors.white,
                        ),
                        onPressed: (){
                          if(title != 'Others Books'){
                            setState(() {
                              title = 'Others Books';
                              items = imageShow(otherBooks);
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.book,
                          color: Colors.white,
                        ),
                        onPressed: (){
                          if(title != 'Public Books'){
                            setState(() {
                              title = 'Public Books';
                              items = imageShow(publicBooks);
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.library_books,
                          color: Colors.white,
                        ),
                        onPressed: (){
                          if(title != 'Private Books'){
                            setState(() {
                              title = 'Private Books';
                              items = imageShow(privateBooks);
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateBookScreen(
                          user: user,
                        ))),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*static List<String> imgBook = [
    'assets/images/document.png',
    'assets/images/book.png',
  ];*/

  static List<String> imgList = [
    'assets/images/image_1.jpg',
    'assets/images/image_2.jpg',
    'assets/images/image_3.jpg',
    'assets/images/image_4.jpg',
    'assets/images/image_5.jpg',
    'assets/images/image_6.jpg',
    'assets/images/image_7.jpg',
    'assets/images/image_8.jpg',
  ];

  List<Widget> imageSliders(double height) {
    return imgList.map((item) =>
        Container(
          child: Container(
            margin: EdgeInsets.all(1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: height * 0.25,
                  width: 138.5,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                      image: AssetImage(item),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10),
                    height: 50,
                    width: 50,
                    alignment: Alignment.bottomRight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.grey.shade200.withOpacity(0.5),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: () {

                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    ).toList();
  }

  Container ourBooksWidget(var data, String img, String bookName, String author, String publishingHouse, String status, String noPages){
    return Container(
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (context) => BookInfoScreen(
              data: data,
              user: user,
            )
        )),
        child: Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: '$img',
                child: Container(
                  width: 60,
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    image: DecorationImage(
                      image: AssetImage('$img'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 220,
                    padding: EdgeInsets.all(5),
                    child: Text(
                      '$bookName',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    '$author',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      fontFamily: 'montserrat',
                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    width: 215,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '$publishingHouse',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              '$status',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '($noPages',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Icon(Icons.book, size: 13, color: Colors.white,),
                            Text(
                              ')',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              data['user_id'] == user['id'] ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipOval(
                    child: Material(
                      color: Colors.white, // button color
                      child: InkWell(
                        splashColor: Colors.white, // inkwell color
                        child: SizedBox(width: 25, height: 25, child: Icon(Icons.close)),
                        onTap: () {
                          remove(data['id']);
                        },
                      ),
                    ),
                  )
                ],
              ) :
                  Text(''),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> imageShow(List books){
    List<Widget> items = [];
    for(int i = 0; i < books.length; i++){
      /*int x = 0;
      if(books[i]['status'] == 'public'){
        x = 1;
      }*/
      items.add(
          ourBooksWidget(
            books[i],
            imgList[i % imgList.length],
            books[i]['name'],
            books[i]['author'],
            books[i]['publishing_house'],
            books[i]['status'],
            books[i]['no_pages'].toString(),
          )
      );
    }
    return items;
    /*return books.map((item) {
      ourBooksWidget(
        item,
        imgList[counter % imgList.length],
        item['name'],
        item['author'],
        item['publishing_house'],
        item['status'],
        item['no_pages'].toString(),
      );
      counter += 1;
    }).toList();*/
  }

  void filter(){
    for(int i = 0; i < books.length; i++){
      if(books[i]['status'] == 'public'){
        if(books[i]['user_id'] == user['id']) {
          print("----------------------------------------");
          print(books[i]);
          publicBooks.add(books[i]);
        }else{
          print("----------------------------------------");
          print(books[i]);
          otherBooks.add(books[i]);
        }
      }else{
        print(books[i]['user_id']);
        print(user);
        print(books[i]['user_id'] == user['id']);
        if(books[i]['user_id'] == user['id']){
          privateBooks.add(books[i]);
        }
      }
    }
  }
}
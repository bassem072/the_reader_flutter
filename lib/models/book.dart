import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

List pages = [];
String url;

Future<bool> removeBook(int id) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String apiToken = pref.getString('api_token');
  int bookID = id;
  int pageID;
  print(apiToken);
  url =
  "https://young-mesa-16194.herokuapp.com/api/pages?api_token=$apiToken&id=$bookID";
  print(url);
  final http.Response response = await http.get(
    url,
  );
  print(7);
  print(response.statusCode);
  if (response.statusCode == 200) {
    var body = json.decode(response.body);
    print(1);
    if (body['status'] == true) {
      print(2);
      pages = body['pages'];
      for (int i = 0; i < pages.length; i++) {
        pageID = pages[i]['id'];
        url = "https://young-mesa-16194.herokuapp.com/api/pages/$pageID?api_token=$apiToken";
        print(url);
        final http.Response response1 = await http.delete(
          url,
        );
        if (response1.statusCode == 200) {
          body = json.decode(response.body);
          print(1);
          if (body['status'] == false) {
            return false;
          }
        }else{
          return false;
        }
      }
      url = "https://young-mesa-16194.herokuapp.com/api/books/$bookID?api_token=$apiToken";
      print(url);
      final http.Response response2 = await http.delete(
        url,
      );
      if (response2.statusCode == 200) {
        body = json.decode(response.body);
        print(1);
        if (body['status'] == true) {
          return true;
        }
      }
    }
  }
  return false;
}

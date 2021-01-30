import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Auth{
  Future<dynamic> login(url, data) async{
    print(data);
    final http.Response response = await http.post(
        url,
        body: data
    );

    return response;

  }


  register(url, data) async{
    final http.Response response = await http.post(
        url,
        body: {
          'first': data['first'],
          'last': data['last'],
          'is_blind': data['is_blind'],
          'email': data['email'],
          'password': data['password']
        }
    );

    if(response.statusCode == 200){
      var body = json.decode(response.body);
      if(body['status'] == true){
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('api_token', body['token']);
        pref.setInt('id', body['user']['id']);
        pref.setString('first', body['user']['first_name']);
        pref.setString('last', body['user']['last_name']);
        return pref.getInt('id');
      }else{
        return body['messages'];
      }
    } else {
      throw Exception('Server Error');
    }
  }

  logout() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  getUser(url) async{
    final http.Response response = await http.get(
        url,
    );

    if(response.statusCode == 200){
      var body = json.decode(response.body);
      if(body['status'] == 200) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setInt('id', body['id']);
        pref.setString('first', body['first_name']);
        pref.setString('last', body['last_name']);
        return pref.getInt('id');
      }else{
        return body['messages'];
      }
    } else {
      throw Exception('Server Error');
    }
  }

  getUserByID(url) async{
    final http.Response response = await http.get(
        url,
    );

    if(response.statusCode == 200){
      var body = json.decode(response.body);
      if(body['status'] == true){
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setInt('id', body['user']['id']);
        pref.setString('first', body['user']['first_name']);
        pref.setString('last', body['user']['last_name']);
        return pref.getInt('id').toString();
      }else{
        return body['messages'];
      }
    } else {
      throw Exception('Server Error');
    }
  }

  update(url, data) async{
    final http.Response response = await http.put(
        url,
        body: {
          'first': data['first'],
          'last': data['last'],
          'password': data['password'],
          'old': data['old'],
        }
    );

    if(response.statusCode == 200){
      var body = json.decode(response.body);
      if(body['status'] == true){
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setInt('id', body['user']['id']);
        pref.setString('first', body['user']['first_name']);
        pref.setString('last', body['user']['last_name']);
        return pref.getInt('id').toString();
      }else{
        return body['messages'];
      }
    } else {
      throw Exception('Server Error');
    }
  }

}
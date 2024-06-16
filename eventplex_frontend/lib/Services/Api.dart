import 'dart:ffi';
import 'dart:io';

import 'package:eventplex_frontend/Model/Event.dart';
import 'package:dio/dio.dart';
import 'package:eventplex_frontend/Model/User.dart';

class Api {
  String baseUrl = "https://eventplex.onrender.com";
  // String baseUrl = "http://localhost:3001";
  Future<Event> getEventById(String id) async {
    // print(id);
    var responce = await Dio().get('$baseUrl/event/byid', queryParameters: {"id": id});
    var result = responce.data;
    try {
      // print(result);
      Event e = Event.fromJson(result);
      return e;
    } catch (e) {
      print(e);
    }
    return Event();
  }

  Future<User> getUserById(String id) async {
    var responce = await Dio().get('$baseUrl/user/byid', queryParameters: {"id": id});
    var result = responce.data;
    try {
      // print(result);
      User u = User.fromJson({
        'name': result['name'],
        '_id': result['id'],
        'keywords': result['keywords'],
        'dp': result['dp'],
        'email': result['email'],
      });
      return u;
    } catch (e) {
      print("1"+e.toString());
    }
    return User();
  }
  void uploadImage(File f)async{
    FormData fd = FormData.fromMap({
      'userFile': await MultipartFile.fromFile(f.path, filename: 'image.jpg')
    });
    var responce = await Dio().post('$baseUrl/user/imageUpload', data: fd);
    print(responce);
  }
  // Future<Event> getClubById(String id) async {
  //   // print(id);
  //   var responce = await Dio().get('$baseUrl/club/byid', queryParameters: {"id": id});
  //   var result = responce.data;
  //   try {
  //     // print(result);
  //     Event e = Event.fromJson(result);
  //     return e;
  //   } catch (e) {
  //     print(e);
  //   }
  //   return Event();
  // }
}

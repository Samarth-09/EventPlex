import 'package:eventplex_frontend/Model/Event.dart';
import 'package:dio/dio.dart';
import 'package:eventplex_frontend/Model/User.dart';

class Api {
  String baseUrl = "http://localhost:3001";
  // String baseUrl = "http:// 192.168.0.108:3001/event";
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

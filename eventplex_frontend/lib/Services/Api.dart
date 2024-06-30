import 'package:eventplex_frontend/Model/Club.dart';
import 'package:eventplex_frontend/Model/Event.dart';
import 'package:dio/dio.dart';
import 'package:eventplex_frontend/Model/User.dart';

class Api {
  String baseUrl = "https://eventplex.onrender.com";
  // String baseUrl = "http://localhost:3001";
  Future<Event> getEventById(String id) async {
    // print(id);
    var responce =
        await Dio().get('$baseUrl/event/byid', queryParameters: {"id": id});
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
    var responce =
        await Dio().get('$baseUrl/user/byid', queryParameters: {"id": id});
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
      print("1" + e.toString());
    }
    return User();
  }

  Future<Club> getClubById(String id) async {
    var responce =
        await Dio().get('$baseUrl/club/byid', queryParameters: {"id": id});
    Map<String, dynamic> result = responce.data;
    // print({
    //     'name': result['name'],
    //     '_id': result['id'],
    //     'currentEvents': result['currentEvents'] as List,
    //     'dp': result['dp'],
    //     'email': result['email'],
    //   });
    try {
      print(result);
      Club c = Club.fromJson(
          //   {
          //   'name': result['name'],
          //   '_id': result['_id'],
          //   'currentEvents': result['currentEvents'] ,
          //   'pastEvents': result['pastEvents'],
          //   'dp': result['dp'],
          //   'email': result['email'],
          // }
          result);
      return c;
    } catch (e) {
      print("2" + e.toString());
    }
    return Club();
  }

  Future<void> updateClub(Map<String, dynamic> mp) async {
    try {
      var responce = await Dio().post('$baseUrl/club/update', data: mp);
      // return c;
      print(responce);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateEvent(Map<String, dynamic> mp) async {
    try {
      var responce = await Dio().post('$baseUrl/event/update', data: mp);
      // return c;
      print(responce);
    } catch (e) {
      print(e);
    }
  }

  // void uploadImage(File f) async {
  //   print(f.path);
  //   var m = await MultipartFile.fromFile(f.path, filename: 'e1.jpg');

  //   FormData fd = FormData.fromMap({'userFile': m});
  //   print(fd);
  //   var responce = await Dio().post('$baseUrl/user/imageUpload', data: fd);
  //   print(responce);
  // }
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

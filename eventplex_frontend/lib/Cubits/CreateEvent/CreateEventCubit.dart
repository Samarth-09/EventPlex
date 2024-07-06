import 'dart:io';

import 'package:eventplex_frontend/Cubits/CreateEvent/CreateEventState.dart';
import 'package:eventplex_frontend/Model/Event.dart';
import 'package:eventplex_frontend/Services/Api.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  CreateEventCubit() : super(CreateEventState());
  Api api = Api();

  void submit(Map<String, dynamic> mp) async {
    emit(CreateEventStateLoading());
    List<String>? l =
        (mp['keywords'] == null) ? null : mp['keywords'].split(",");
    mp['keywords'] = l;
    List<String> imgs = [];
    String email = (await SharedPreferences.getInstance()).getString("email")!;
    for (File f in mp['images']) {
      imgs.add(await uploadImageAndGetUrl(email, f));
    }
    mp["images"] = imgs;
    Event event = await api.createEvent(mp);
    emit(CreateEventStateSubmitted(event));
  }

  Future<String> uploadImageAndGetUrl(String email, File img) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageref =
          storageRef.child("$email/images/${img.path.split("/").last}.jpg");
      // /${DateTime.now().microsecondsSinceEpoch}-${img.path.split("/").last}
      // ");
      await imageref.putFile(img);
      print(2);
      return await imageref.getDownloadURL();
    } catch (e) {
      print(e);
      return "";
    }
  }
}


//add loading animation and and reload the dashboard instead off just pop 
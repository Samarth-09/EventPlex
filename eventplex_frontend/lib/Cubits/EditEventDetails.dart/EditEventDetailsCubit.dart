import 'dart:io';

import 'package:eventplex_frontend/Cubits/EditEventDetails.dart/EditEventDetailsState.dart';
import 'package:eventplex_frontend/Model/Event.dart';
import 'package:eventplex_frontend/Services/Api.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditEventDetailsCubit extends Cubit<EditEventDetailsState> {
  EditEventDetailsCubit() : super(EditEventDetailsState());
  Api api = Api();
  void loadDetails(String id) async {
    Event event = await api.getEventById(id);
    emit(EditEventDetailsLoadedState(event));
  }

  void updateData(Map<String, dynamic> mp, Event e) async {
    emit(EditEventDetailsState());
    if (mp['dp'] != null) {
      mp['email'] = (await SharedPreferences.getInstance()).getString("email")!;
      mp['dp'] = await uploadImageAndGetUrl(mp['email'], mp['dp']);
      e.images.add(mp['dp']);
      mp['images'] = e.images;
      print(mp['dp']);
    }
    Map<String, dynamic> x = e.toJson();
    mp.forEach((key, value) {
      if(value == null){
        mp[key] = x[key];
        // print('$key $value');
      }
      
    });
    // print(mp);
    await api.updateEvent(mp);
    emit(EditEventDetailsLoadedState(e));
  }

  Future<String> uploadImageAndGetUrl(String email, File img) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageref = storageRef
          .child("$email/images/${img.path.split("/").last}.jpg");
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

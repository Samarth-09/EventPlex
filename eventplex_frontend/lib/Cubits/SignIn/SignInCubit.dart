import 'dart:io';
import 'package:eventplex_frontend/Cubits/SignIn/SignInState.dart';
import 'package:eventplex_frontend/Model/User.dart';
import 'package:eventplex_frontend/Services/Api.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInState());
  Api api = Api();

  void submit(Map<String, dynamic> mp) async {
    emit(SignInStateLoading());
    List<String>? l = (mp['keywords'] == null || mp['keywords'] == "")
        ? null
        : mp['keywords'].split(",");
    mp['keywords'] = l;
    String email = (await SharedPreferences.getInstance()).getString("email")!;
    if (mp['dp'] != null) {
      mp['dp'] = await uploadImageAndGetUrl(email, File(mp['dp']));
    }
    mp['email'] = email;
    User u = await api.createUser(mp);
    emit(SignInStateSubmitted(u));
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
import 'package:eventplex_frontend/Cubits/Login/LoginState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());
  void loginUsingGoogle(FirebaseAuth auth) {
    try {
      //sha-1 key is required to tell that the request for sign in is comming from legimit source
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      auth.signInWithProvider(googleAuthProvider);
    } catch (e) {
      print(e);
    }
  }

  void selectRole(int i) async {
    String role = "";
    if (i == 0) {
      print(1);
      role = "club";
    } else if (i == 1) {
      role = "user";
    }
    await (await SharedPreferences.getInstance()).setString("role", role);
    emit(LoginRoleSelectedState(i));
  }
}

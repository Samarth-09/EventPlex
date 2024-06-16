import 'package:eventplex_frontend/Cubits/Login/LoginState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(): super(LoginInitialState());
  void loginUsingGoogle(FirebaseAuth auth){
    try {
      //sha-1 key is required to tell that the request for sign in is comming from legimit source
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      auth.signInWithProvider(googleAuthProvider);
    } catch (e) {
      print(e);
    }
  }
}
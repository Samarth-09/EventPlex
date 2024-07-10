import 'package:eventplex_frontend/Model/User.dart';

class SignInState {}

class SignInStateSubmitted extends SignInState {
  User user;
  SignInStateSubmitted(this.user);
}

class SignInStateLoading extends SignInState {}

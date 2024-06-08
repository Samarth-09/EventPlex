import 'package:eventplex_frontend/Model/User.dart';

class UserProfileState {}

class UserProfileLoadedState extends UserProfileState {
  User user;
  UserProfileLoadedState(this.user);
}

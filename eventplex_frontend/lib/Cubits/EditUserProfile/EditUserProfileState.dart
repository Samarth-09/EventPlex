import 'package:eventplex_frontend/Model/User.dart';

class EditUserProfileState {}

class EditUserProfileLoadedState extends EditUserProfileState {
  User user;
  EditUserProfileLoadedState(this.user);
}

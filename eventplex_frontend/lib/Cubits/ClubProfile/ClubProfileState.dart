import 'package:eventplex_frontend/Model/Club.dart';

class ClubProfileState {}

class ClubProfileStateLoadedState extends ClubProfileState {
  Club club;
  ClubProfileStateLoadedState(this.club);
}

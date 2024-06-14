import 'package:eventplex_frontend/Model/Club.dart';

class ClubDetailsState {}

class ClubDetailsStateLoaded extends ClubDetailsState {
  Club club;
  bool following;
  ClubDetailsStateLoaded(this.club, this.following);
}
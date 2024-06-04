import 'package:eventplex_frontend/Model/Club.dart';

class ClubDetailsState {}

class ClubDetailsStateLoaded extends ClubDetailsState {
  Club club;
  ClubDetailsStateLoaded(this.club);
}
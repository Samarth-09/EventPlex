import 'package:eventplex_frontend/Model/Event.dart';

class CreateEventState {}

class CreateEventStateSubmitted extends CreateEventState {
  Event event;
  CreateEventStateSubmitted(this.event);
}

class CreateEventStateLoading extends CreateEventState {}

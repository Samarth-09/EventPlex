import 'package:eventplex_frontend/Model/Event.dart';

class EditEventDetailsState {}

class EditEventDetailsLoadedState extends EditEventDetailsState {
  Event event;
  EditEventDetailsLoadedState(this.event);
}

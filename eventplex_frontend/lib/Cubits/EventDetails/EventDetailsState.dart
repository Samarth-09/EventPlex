import 'package:eventplex_frontend/Model/Event.dart';

class EventDetailsState {}

class EventDetailsStateLoaded extends EventDetailsState {
  List<Map<String, dynamic>> info = [];
  late Event event;
  EventDetailsStateLoaded(this.event) {
    info.add({"Location": event.location});
    info.add({"date": event.date});
    info.add({"time": event.time});
    info.add({"ticketsRemaining": event.ticketsRemaining});
    info.add({"club": event.club});
    info.add({"fees": event.fees});
  }
}

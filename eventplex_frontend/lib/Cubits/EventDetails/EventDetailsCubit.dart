import 'package:eventplex_frontend/Cubits/EventDetails/EventDetailsState.dart';
import 'package:eventplex_frontend/Model/Event.dart';
import 'package:eventplex_frontend/Services/Api.dart';
import 'package:eventplex_frontend/Services/GraphQLService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventDetailsCubit extends Cubit<EventDetailsState> {
  GraphQLService gqs = GraphQLService();
  Api api = Api();
  EventDetailsCubit() : super(EventDetailsState()) {
    // loadEventDetails(id);
  }
  void loadEventDetails(id) async {
    Event e = await api.getEventById(id);
    emit(EventDetailsStateLoaded(e));
  }
}

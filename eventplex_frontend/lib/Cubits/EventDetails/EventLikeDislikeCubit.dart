import 'package:eventplex_frontend/Cubits/EventDetails/EventLikeDislikeState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventLikeDislikeCubit extends Cubit<EventLikeDislikeState> {
  EventLikeDislikeCubit() : super(EventLikeDislikeState()) {
    initLists();
  }
  List<String> eventsLiked = [];
  List<String> eventsDisLiked = [];

  bool findEventForLike(String id) {
    for (String e in eventsLiked) {
      if (e == id) {
        return true;
        // print(e);
        // emit(EventLikedState());
      }
    }
    return false;
  }

  bool findEventForDisLike(String id) {
    for (var e in eventsDisLiked) {
      if (e == id) {
        return true;
        // emit(EventDislikedState());
      }
    }
    return false;
  }

  void initLists() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    eventsLiked = sf.getStringList("eventsliked") ?? [];
    eventsDisLiked = sf.getStringList("eventsdisliked") ?? [];
    if (findEventForLike("665a2845e75985c1d041aae6")) {
      emit(EventLikedState());
    } else if (findEventForDisLike("665a2845e75985c1d041aae6")) {
      emit(EventDislikedState());
    }
  }

  void loadEventsLiked(String id) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    eventsLiked.add(id);
    sf.setStringList("eventsliked", eventsLiked);
    List<String> l = sf.getStringList("eventsdisliked") ?? [];
    l.remove(id);
    eventsDisLiked = l;
    sf.setStringList("eventsdisliked", l);
    emit(EventLikedState());
  }

  void loadEventsDisliked(String id) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    eventsDisLiked.add(id);
    sf.setStringList("eventsdisliked", eventsDisLiked);
    List<String> l = sf.getStringList("eventsliked") ?? [];
    l.remove(id);
    eventsLiked = l;
    sf.setStringList("eventsliked", l);
    emit(EventDislikedState());
  }
}

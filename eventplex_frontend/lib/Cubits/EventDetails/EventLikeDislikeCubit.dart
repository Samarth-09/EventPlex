import 'package:eventplex_frontend/Cubits/EventDetails/EventLikeDislikeState.dart';
import 'package:eventplex_frontend/Services/GraphQLService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventLikeDislikeCubit extends Cubit<EventLikeDislikeState> {
  EventLikeDislikeCubit(String id) : super(EventLikeDislikeState()) {
    initLists(id);
  }
  List<String> eventsLiked = [];
  List<String> eventsDisLiked = [];
  GraphQLService gqs = GraphQLService();

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

  //method to initialize the lists and after that check for the applicable state
  void initLists(String id) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    eventsLiked = sf.getStringList("eventsliked") ?? [];
    eventsDisLiked = sf.getStringList("eventsdisliked") ?? [];
    if (findEventForLike(id)) {
      emit(EventLikedState());
    } else if (findEventForDisLike(id)) {
      emit(EventDislikedState());
    }
  }

  //add event to the local storage , increase the like, if it was in dislike decrease its count and remove from the dislike list
  void loadEventsLiked(String id) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    // if(eventsLiked)
    eventsLiked.add(id);
    sf.setStringList("eventsliked", eventsLiked);

    String query = '''
    mutation(\$data: likeDislikeInput){
     changeLike(data: \$data){
       name
     }
 }''';

    gqs.performMutation(query, {
      "data": {"eid": id, "type": "+"}
    });
    List<String> l = sf.getStringList("eventsdisliked") ?? [];

    if (l.remove(id)) {
      query = '''
    mutation(\$data: likeDislikeInput){
     changeDisLike(data: \$data){
       name
     }
 }''';

      gqs.performMutation(query, {
        "data": {"eid": id, "type": "-"}
      });
      eventsDisLiked = l;
      sf.setStringList("eventsdisliked", l);
    }

    emit(EventLikedState());
  }

  //add event to the dislike list, increase the dislike count , if it is present it like then decrease its count and remove it from the like list
  void loadEventsDisliked(String id) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    eventsDisLiked.add(id);
    sf.setStringList("eventsdisliked", eventsDisLiked);
    String query = '''
    mutation(\$data: likeDislikeInput){
     changeDisLike(data: \$data){
       name
     }
 }''';

    gqs.performMutation(query, {
      "data": {"eid": id, "type": "+"}
    });
    List<String> l = sf.getStringList("eventsliked") ?? [];
    if (l.remove(id)) {
      sf.setStringList("eventsliked", l);
      String query = '''
    mutation(\$data: likeDislikeInput){
     changeLike(data: \$data){
       name
     }
 }''';

      gqs.performMutation(query, {
        "data": {"eid": id, "type": "-"}
      });
      eventsLiked = l;
    }

    emit(EventDislikedState());
  }
}

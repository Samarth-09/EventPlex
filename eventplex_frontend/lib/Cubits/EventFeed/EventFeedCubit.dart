import 'package:eventplex_frontend/Cubits/EventFeed/EventFeedState.dart';
import 'package:eventplex_frontend/Model/Event.dart';
import 'package:eventplex_frontend/Services/GraphQLService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';

class EventFeedCubit extends Cubit<EventFeedState> {
  GraphQLService gqls = GraphQLService();
  EventFeedCubit() : super(EventFeedState()) {
    String query = '''
  query eventCardDetails{
    allEvents {
      _id
      images
      name
      Club{
        _id
        name
      }
      category
      rating
    }
  }
''';
    loadEventList(query, {}, false);
  }
  // void makeAppbarTextVisible() async {
  //   loadEventList(0);
  //   // emit(EventFeedScrolledState(el!));
  // }

  // void makeAppbarTextInVisible() async {
  //   loadEventList(1);
  //   // emit(EventFeedInitialState(el!));
  // }
  void changeAppBar(l, b) {
    emit(EventFeedStateLoaded(eventList: l, isScrolled: b));
  }

  void loadEventList(
      String query, Map<String, dynamic> variables, bool b) async {
    QueryResult result = await gqls.performQuery(query, variables);
    List<Event> el = [], ul = [];
    try {
      el = List.generate(result.data!['allEvents'].length, (index) {
        var d = result.data!['allEvents'][index];
        //we need to convert the list items to the desired one as it is by default object
        // List<String> l =
        //     List.generate(d['images'].length, (i) => d['images'][i].toString());
        // Event e = Event(
        //     images: l,
        //     name: d['name'],
        //     club: d['Club']['name'],
        //     category: d['category'],
        //     rating: d['rating'].toString());
        // print(d);
        // print(1);
        Event e = Event.fromJson(d);
        // print(2);
        return e;
      });

      for (Event e in el) {
        if (DateTime.parse("2024-07-25").isBefore(DateTime.now())) {
          ul.add(e);
        }
      }
      print(ul);
    } catch (e) {
      print(e.toString());
    }
    emit(EventFeedStateLoaded(eventList: el, isScrolled: b));
  }

  void loadFilteredState(String query, String queryname,
      Map<String, dynamic> variables, bool b, int i) async {
    QueryResult result = await gqls.performQuery(query, variables);
    List<Event> fel = [];
    try {
      // print(result.data!['allEventsAccToCategory'].length);
      fel = List.generate(result.data![queryname].length, (index) {
        var d = result.data![queryname][index];
        // //we need to convert the list items to the desired one as it is by default object
        // List<String> l =
        //     List.generate(d['images'].length, (i) => d['images'][i].toString());
        // Event e = Event(
        //     images: l,
        //     name: d['name'],
        //     club: d['Club']['name'],
        //     category: d['category'],
        //     rating: d['rating'].toString());

        Event e = Event.fromJson(d);
        return e;
      });
    } catch (e) {
      print(e);
    }
    emit(EventFeedFilteredStateLoaded(
        filteredEventList: fel, isScrolled: b, currentIndex: i));
  }
}

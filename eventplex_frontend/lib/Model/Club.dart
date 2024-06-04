import 'package:eventplex_frontend/Model/Event.dart';

class Club {
  String name;
  String id;
  List<Event> pastEvents;
  List<Event> currentEvents;
  List<String> followers;
  String dp;

  Club({
    this.name = '',
    this.id = '',
    this.pastEvents = const [],
    this.currentEvents = const [],
    this.followers = const [""],
    this.dp = "",
  });

  // Deserialize JSON to Club object
  factory Club.fromJson(Map<String, dynamic> json) {
    // print(json['pastEvents']);
    return Club(
      name: json['name'] ?? "",
      id: json['_id'] ?? "",
      pastEvents: List.generate(json['pastEvents'].length,
          (index) => Event.fromJson(json['pastEvents'][index])),
      // List<String>.from(json['pastEvents']),
      currentEvents: List.generate(json['currentEvents'].length,
          (index) => Event.fromJson(json['currentEvents'][index])),
      // List<String>.from(json['currentEvents']),
      // followers: List<String>.from(json['followers']),
      dp: json['dp'] ?? "",
    );
  }
  // Serialize Club object to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'pastEvents': pastEvents,
        'currentEvents': currentEvents,
        'followers': followers,
        'dp': dp,
      };
}

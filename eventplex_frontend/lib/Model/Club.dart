import 'package:eventplex_frontend/Model/Event.dart';
import 'package:eventplex_frontend/Model/User.dart';

class Club {
  String name;
  String id;
  List<Event> pastEvents;
  List<Event> currentEvents;
  List<User> followers;
  String dp;
  String email;

  Club(
      {this.name = '',
      this.id = '',
      this.pastEvents = const [],
      this.currentEvents = const [],
      this.followers = const [],
      this.dp = "",
      this.email = ""});

  // Deserialize JSON to Club object
  factory Club.fromJson(Map<String, dynamic> json) {
    // print(json);
    return Club(
        name: json['name'] ?? "",
        id: json['_id'] ?? "",
        pastEvents: (json['pastEvents'] != null)
            ? List.generate(json['pastEvents'].length,
                (index) => Event.fromJson(json['pastEvents'][index]))
            : [],
        // List<String>.from(json['pastEvents']),
        currentEvents: (json['currentEvents'] != null)
            ? List.generate(json['currentEvents'].length,
                (index) => Event.fromJson(json['currentEvents'][index]))
            : [],
        // List<String>.from(json['currentEvents']),
        followers: (json['followers'] != null)
            ? List.generate(json['followers'].length,
                (index) => User.fromJson(json['followers'][index]))
            : [],
        dp: json['dp'] ?? "",
        email: json['email'] ?? "");
  }
  // Serialize Club object to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'pastEvents': pastEvents,
        'currentEvents': currentEvents,
        'followers': followers,
        'dp': dp,
        '_id': id,
        'email': email
      };
}

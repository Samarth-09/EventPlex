import 'package:eventplex_frontend/Model/Club.dart';
import 'package:eventplex_frontend/Model/Event.dart';

class User {
  String name;
  String id;
  List<Event> pastEvents;
  List<Event> currentEvents;
  List<Club> following;
  List<String> keywords;
  String dp;
  String email;

  User({
    this.name = '',
    this.id = '',
    this.pastEvents = const [],
    this.currentEvents = const [],
    this.following = const [],
    this.email = '',
    this.keywords = const [],
    this.dp = "",
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // print(json['name']);
    return User(
      name: json['name'] ?? "",
      id: json['_id'] ?? "",
      email: json['email'] ?? "",
      pastEvents: (json['pastEvents'] != null)
          ? List.generate(json['pastEvents'].length,
              (index) => Event.fromJson(json['pastEvents'][index]))
          : [],
      // List<String>.from(json['pastEvents']),
      currentEvents: (json['currentEvents'] != null)
          ? List.generate(json['currentEvents'].length,
              (index) => Event.fromJson(json['currentEvents'][index]))
          : [],
      keywords: (json['keywords'] != null)
          ? List.generate(json['keywords'].length,
              (index) => json['keywords'][index].toString())
          : [],
      // List<String>.from(json['currentEvents']),
      following: (json['following'] != null)
          ? List.generate(json['following'].length,
              (index) => Club.fromJson(json['following'][index]))
          : [],
      dp: json['dp'] ?? "",
    );
  }
  // Serialize Club object to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'pastEvents': pastEvents,
        'currentEvents': currentEvents,
        'following': following,
        'dp': dp,
        'keywords': keywords,
        'email': email,
        '_id': id
      };
}

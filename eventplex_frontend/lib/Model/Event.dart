class Event {
  String id;
  String name;
  String location;
  String date;
  String time;
  int fees;
  String category;
  int totalTickets;
  int ticketsRemaining;
  int likes;
  int dislikes;
  List<String> comments;
  List<String> keywords;
  String club; // Assuming clubId is a String
  String clubId;
  List<String> images;
  String rating;
  String desciption;

  Event(
      {this.id = '',
      this.name = '',
      this.location = '',
      this.date = '',
      this.time = '',
      this.fees = 0,
      this.category = '',
      this.totalTickets = 0,
      this.ticketsRemaining = 0,
      this.likes = 0,
      this.dislikes = 0,
      this.comments = const [""],
      this.keywords = const [""],
      this.club = '',
      this.clubId = '',
      this.images = const [""],
      this.rating = '0',
      this.desciption = ''});

  factory Event.fromJson(Map<String, dynamic> json) {
    // print(json['comments']);
    // print(1);
    // print(json);
    String clubName;
    if (json['Club'] == null) {
      clubName = "";
    } else {
      clubName = json['Club']['name'];
    }
    if (json['_doc'] != null) {
      json = json['_doc'];
      // print(json['Club']);
    }
    // print(json['name'] ?? 1);
    

    // if (json['_doc'] != null) {
    //   json = json['_doc'];
    //   // print(json['Club']);
    // }
    return Event(
        id: json['_id'] ?? "",
        name: json['name'] ?? "",
        location: json['location'] ?? "",
        date: json['date'] ?? "",
        time: json['time'] ?? "",
        fees: json['fees'] ?? 0,
        category: json['category'] ?? "",
        totalTickets: json['totalTickets'] ?? 0,
        ticketsRemaining: json['ticketsRemaining'] ?? 0,
        likes: json['likes'] ?? 0,
        dislikes: json['dislikes'] ?? 0,
        comments:
            // json['comments'],
            List.generate(
                (json['comments'] == null) ? 0 : json['comments'].length,
                (index) => json['comments'][index]
                    .toString()), //List<String>.from(json['comments']),
        keywords:
            // json['keywords'],
            List.generate(
                (json['keywords'] == null) ? 0 : json['keywords'].length,
                (index) => json['keywords'][index]
                    .toString()), //List<String>.from(json['keywords']),
        club: clubName ?? "",
        clubId: json['club']??"",
        images:
            // json['images'],
            List.generate(
                (json['images'] == null) ? 0 : json['images'].length,
                (index) => json['images'][index]
                    .toString()), //List<String>.from(json['images']),
        rating: json['rating'].toString(),
        desciption: json['desciption'] ??
            "This is an Event Full of enjoyment, exploration, networking and learning. Must participte!!");
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'location': location,
      'date': date,
      'time': time,
      'fees': fees,
      'category': category,
      'totalTickets': totalTickets,
      'ticketsRemaining': ticketsRemaining,
      'likes': likes,
      'dislikes': dislikes,
      'comments': comments,
      'keywords': keywords,
      'club': club,
      'images': images,
      'rating': rating,
      'desciption': desciption
    };
  }
}

import 'package:eventplex_frontend/Model/Category.dart';
import 'package:eventplex_frontend/Model/Event.dart';

class EventFeedState {}

class EventFeedStateLoaded extends EventFeedState {
  bool isScrolled = false;
  int currentIndex = -1;
  List<Category> categories = [
    Category(
        image:
            "https://img.icons8.com/external-others-pike-picture/100/000000/external-Hackathon-fintech-others-pike-picture-2.png",
        name: "Category 1"),
    Category(
        image:
            "https://img.icons8.com/external-outline-juicy-fish/60/000000/external-seminar-human-figures-outline-outline-juicy-fish.png",
        name: "Category 2"),
    Category(
        image:
            "https://img.icons8.com/external-others-pike-picture/100/000000/external-Hackathon-fintech-others-pike-picture-2.png",
        name: "Hackathon"),
    Category(
        image:
            "https://img.icons8.com/external-outline-juicy-fish/60/000000/external-seminar-human-figures-outline-outline-juicy-fish.png",
        name: "Seminar")
  ];
  Event featuredEvent = Event(
    id: "",
      images: ["assets/images/e2.jpg"],
      name: "DotSlash 7.0",
      club: "Svnit",
      category: "Hackathon",
      rating: "3.5");
  List<Event> eventList;
  EventFeedStateLoaded({required this.eventList, required this.isScrolled});
}

class EventFeedInitialState extends EventFeedState {
  bool isScrolled = false;
  EventFeedInitialState(this.isScrolled);
}

class EventFeedFilteredStateLoaded extends EventFeedState {
  List<Category> categories = [
    Category(
        image:
            "https://img.icons8.com/external-others-pike-picture/100/000000/external-Hackathon-fintech-others-pike-picture-2.png",
        name: "Category 1"),
    Category(
        image:
            "https://img.icons8.com/external-outline-juicy-fish/60/000000/external-seminar-human-figures-outline-outline-juicy-fish.png",
        name: "Category 2"),
    Category(
        image:
            "https://img.icons8.com/external-others-pike-picture/100/000000/external-Hackathon-fintech-others-pike-picture-2.png",
        name: "Hackathon"),
    Category(
        image:
            "https://img.icons8.com/external-outline-juicy-fish/60/000000/external-seminar-human-figures-outline-outline-juicy-fish.png",
        name: "Seminar")
  ];

  int currentIndex = -1;
  List<Event> filteredEventList = [];
  bool isScrolled = false;
  EventFeedFilteredStateLoaded(
      {required this.filteredEventList,
      required this.isScrolled,
      required this.currentIndex});
}

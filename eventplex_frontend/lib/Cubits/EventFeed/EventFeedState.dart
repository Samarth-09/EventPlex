import 'package:eventplex_frontend/Model/Category.dart';
import 'package:eventplex_frontend/Model/Event.dart';

class EventFeedState {}

class EventFeedStateLoaded extends EventFeedState {
  bool isScrolled = false;
  int currentIndex = -1;
  List<Category> categories = [
    Category(
        image: "https://img.icons8.com/dotty/80/people-working-together.png",
        name: "Community"),
    Category(
        image: "https://img.icons8.com/material/24/crown-of-thorns.png",
        name: "Cultural"),
    Category(
        image: "https://img.icons8.com/material/24/olympic-rings.png",
        name: "Sports"),
    Category(
        image: "https://img.icons8.com/ios/50/education.png",
        name: "Educational"),
    Category(
        image: "https://img.icons8.com/material/24/virtual-reality.png",
        name: "Entertainment"),
    Category(
        image: "https://img.icons8.com/material/24/video-conference--v1.png",
        name: "Virtual")
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
        image: "https://img.icons8.com/dotty/80/people-working-together.png",
        name: "Community"),
    Category(
        image: "https://img.icons8.com/material/24/crown-of-thorns.png",
        name: "Cultural"),
    Category(
        image: "https://img.icons8.com/material/24/olympic-rings.png",
        name: "Sports"),
    Category(
        image: "https://img.icons8.com/ios/50/education.png",
        name: "Educational"),
    Category(
        image: "https://img.icons8.com/material/24/virtual-reality.png",
        name: "Entertainment"),
    Category(
        image: "https://img.icons8.com/material/24/video-conference--v1.png",
        name: "Virtual")
  ];

  int currentIndex = -1;
  List<Event> filteredEventList = [];
  bool isScrolled = false;
  EventFeedFilteredStateLoaded(
      {required this.filteredEventList,
      required this.isScrolled,
      required this.currentIndex});
}

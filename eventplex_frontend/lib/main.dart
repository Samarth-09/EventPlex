import 'package:eventplex_frontend/Routes.dart';
import 'package:eventplex_frontend/screens/ClubDetails.dart';
import 'package:eventplex_frontend/screens/EditUserProfile.dart';
import 'package:eventplex_frontend/screens/EventDetails.dart';
import 'package:eventplex_frontend/screens/EventFeed.dart';
import 'package:eventplex_frontend/screens/UserProfile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const EventFeed(),
      routes: {
        Routes.eventFeed: (context) => const EventFeed(),
        Routes.eventDetailFeed: (context) => EventDetails(id: ""),
        Routes.clubDetailFeed: (context) => ClubDetails(id: ""),
        Routes.userProfile: (context) => const UserProfile(),
        Routes.editUserProfile:(context) => EditUserProfile(id: "")
      },
    );
  }
}

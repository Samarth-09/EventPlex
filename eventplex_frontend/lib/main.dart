import 'package:eventplex_frontend/Routes.dart';
import 'package:eventplex_frontend/firebase_options.dart';
import 'package:eventplex_frontend/screens/ClubDetails.dart';
import 'package:eventplex_frontend/screens/ClubProfile.dart';
import 'package:eventplex_frontend/screens/EditUserProfile.dart';
import 'package:eventplex_frontend/screens/EventDetails.dart';
import 'package:eventplex_frontend/screens/EventFeed.dart';
import 'package:eventplex_frontend/screens/UserProfile.dart';
import 'package:eventplex_frontend/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey =
      "pk_test_51PRwQIRr4jj2botnGBzoTaeaUYoYTOGv5lzI4HxxPNK2XYBxqa56qFFBtNf0fmWQM8tvgPxOXiQhMeY607RV5tXS00XVhRWn4k";

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Login(),
      routes: {
        Routes.eventFeed: (context) => const EventFeed(),
        Routes.eventDetailFeed: (context) => EventDetails(id: ""),
        Routes.clubDetailFeed: (context) => ClubDetails(id: ""),
        Routes.userProfile: (context) => const UserProfile(),
        Routes.editUserProfile: (context) => EditUserProfile(id: ""),
        Routes.Login: (context) => const Login(),
        Routes.ClubProfile: (context) => const ClubProfile()
      },
    );
  }
}

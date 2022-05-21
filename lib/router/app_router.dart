import 'package:driver/constants/strings.dart';
import 'package:driver/data/models/trip_details.dart';
import 'package:driver/presentation/screens/registration_screen.dart';
import 'package:driver/presentation/screens/vehicle_info_screen.dart';
import 'package:flutter/material.dart';

import '../presentation/screens/login_screen.dart';
import '../presentation/screens/main_screen.dart';
import '../presentation/screens/trip_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case loginScreen:
        return MaterialPageRoute(builder: (context) => const LoginScreen());

      case registrationScreen:
        return MaterialPageRoute(
            builder: (context) => const RegistrationScreen());

      case vehicleInfoScreen:
        return MaterialPageRoute(
            builder: (context) => const VehicleInfoScreen());

      case mainScreen:
        return MaterialPageRoute(builder: (context) => const MainScreen());

      case tripScreen:
        final args = routeSettings.arguments as TripDetails;
        return MaterialPageRoute(
            builder: (context) => TripScreen(tripDetails: args));

      default:
        return null;
    }
  }
}

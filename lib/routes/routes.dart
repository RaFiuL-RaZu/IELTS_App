import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import '../featcher/view/authentication/onboard_screen.dart';
import '../featcher/view/authentication/splash_screeen.dart';
import '../test_screen.dart';

class AppRoutes {
  static const String testScreen = "/testScreen.dart";
  static const String splashScreen = "/splashScreen.dart";
  static const String onboard = "/onboard.dart";

  static List<GetPage> routes = [

    GetPage(
      name: testScreen,
      page: () => TestScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: splashScreen,
      page: () => SplashScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: onboard,
      page: () => OnboardingScreen(),
      transition: Transition.fade,
    ),


  ];
}
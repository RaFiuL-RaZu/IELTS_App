import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import '../featcher/view/authentication/candidate_setup_screen.dart';
import '../featcher/view/authentication/navber_screen.dart';
import '../featcher/view/authentication/onboard_screen.dart';
import '../featcher/view/authentication/splash_screeen.dart';

class AppRoutes {
  static const String splash = "/splash";
  static const String onboard = "/onboard";
  static const String candidateSetup = "/candidate-setup";
  static const String navBer = "/navBer";

  static List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: onboard,
      page: () => const OnboardingScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: candidateSetup,
      page: () => const CandidateSetupScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: navBer,
      page: () => const NavBarScreen(),
      transition: Transition.fade,
    ),
  ];
}
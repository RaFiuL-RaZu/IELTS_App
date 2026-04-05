import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:justtsham/featcher/view/authentication/create_account.dart';
import 'package:justtsham/featcher/view/authentication/verify_email.dart';
import 'package:justtsham/featcher/view/authentication/verify_otp.dart';
import '../featcher/view/authentication/Login_screen.dart';
import '../featcher/view/authentication/forgot_password.dart';
import '../featcher/view/authentication/onboard_screen.dart';
import '../featcher/view/authentication/splash_screeen.dart';
import '../test_screen.dart';

class AppRoutes {
  static const String test = "/test";
  static const String splash = "/splash";
  static const String onboard = "/onboard";
  static const String signup = "/signup";
  static const String verifyOtp = "/verify-otp";
  static const String forgotPass = "/forgot-password";
  static const String verifyEmail = "/verify-email";
  static const String login = "/login";

  static List<GetPage> routes = [
    GetPage(
      name: test,
      page: () => TestScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: splash,
      page: () => SplashScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: onboard,
      page: () => OnboardingScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: signup,
      page: () => CreateAccount(),
      transition: Transition.fade,
    ),
    GetPage(
      name: verifyOtp,
      page: () => VerifyOtp(),
      transition: Transition.fade,
    ),
    GetPage(
      name: forgotPass,
      page: () => ForgotPassword(),
      transition: Transition.fade,
    ),
    GetPage(
      name: verifyEmail,
      page: () => VerifyEmail(),
      transition: Transition.fade,
    ),
    GetPage(
      name: login,
      page: () => LoginScreen(),
      transition: Transition.fade,
    ),
  ];
}
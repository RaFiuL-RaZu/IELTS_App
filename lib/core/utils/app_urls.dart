

class AppUrl{


  static const String baseUrl = "http://10.10.10.31:8888/api/v1";
  static const String imageUrl = "http://10.10.10.31:8888";
  static const String socketUrl = "http://10.10.10.119:4010/api/v1";




  static const String createAccount ="$baseUrl/users/create";
  static const String verifyEmail ="$baseUrl/users/create-user-verify-otp";
  static const String completeProfile ="$baseUrl/users/complete-my-profile";
  static const String login ="$baseUrl/auth/login";
  static const String myProfile ="$baseUrl/users/get-user-profile";
  static const String updateProfile ="$baseUrl/users/update-my-profile";
  static const String forgotPassword ="$baseUrl/auth/forgot-password-otpByEmail";
  static const String verifyOtp ="$baseUrl/auth/forgot-password-otp-match";
  static const String resetPassword ="$baseUrl/auth/forgot-password-reset";
  static  String getHomeAudition ="$baseUrl/auditions/home-auditions";
  static  String getActivity ="$baseUrl/auditions/activity";
  static  String createAudition ="$baseUrl/auditions/create";
  static  String getMyHistory ="$baseUrl/auditions/my-auditions";
  static  String postComment({required String id}) =>"$baseUrl/comments/create/$id";
  static  String createLike({required String id}) =>"$baseUrl/likes/audition-toggle-like/$id";


}
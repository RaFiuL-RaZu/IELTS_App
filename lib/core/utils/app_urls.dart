

class AppUrl{
   //Live url//
  // static const String baseUrl = "http://13.48.207.202:8888/api/v1";
  // static const String imageUrl = "http://13.48.207.202:8888";
  // static const String socketUrl = "http://10.10.5.47:8888/api/v1";


   //Local url//

  static const String baseUrl = "http://10.10.10.31:8899/api/v1";
  static const String imageUrl = "http://10.10.10.31:8899";
  static const String socketUrl = "http://10.10.5.47:8888/api/v1";


  static const String createAccount ="$baseUrl/users/create";
  static const String verifyEmail ="$baseUrl/users/create-user-verify-otp";
  static const String completeProfile ="$baseUrl/users/complete-my-profile";
  static const String login ="$baseUrl/auth/login";
  static const String googleLogin ="$baseUrl/auth/create-or-login-google-user";
  static const String myProfile ="$baseUrl/users/get-user-profile";
  static const String resentOtp ="$baseUrl/otp/resend-email-otp?purpose=create";
  static const String updateProfile ="$baseUrl/users/update-my-profile";
  static const String forgotPassword ="$baseUrl/auth/forgot-password-otpByEmail";
  static const String verifyOtp ="$baseUrl/auth/forgot-password-otp-match";
  static const String resetPassword ="$baseUrl/auth/forgot-password-reset";
  static const String changePassword ="$baseUrl/auth/change-password";
  static  String getHomeAudition ="$baseUrl/auditions/home-auditions";
  static  String getCommunityData ="$baseUrl/community";
  static  String getFavourites ="$baseUrl/favorites/my-favorites";
  static  String getActivity ="$baseUrl/auditions/activity";
  static  String createAudition ="$baseUrl/auditions/create";
  static  String practiceScript ="$baseUrl/practice-scripts/create";
  static  String createCommunity ="$baseUrl/community/create-community";
  static  String getMyHistory ="$baseUrl/auditions/my-auditions";
  static  String getScript ="$baseUrl/scripts/user-get-admin-scripts";
  static  String weeklyScript ="$baseUrl/scripts/weekly-scripts";
  static  String createScript ="$baseUrl/openai/script-generator";
  static  String subscription ="$baseUrl/subscriptions/plans";
  static  String getMyPlan ="$baseUrl/subscriptions/my-subscriptions";
  static  String getHelp ="$baseUrl/setting/help-center";
  static  String getNotify ="$baseUrl/notifications/my-notifications";
  static  String createFav ="$baseUrl/favorites/add";
  static  String deleteFav ="$baseUrl/favorites/delete";
  static  String getPayment ="$baseUrl/stripe/create-subscription-session";
  static  String postComment({required String id}) =>"$baseUrl/comments/create/$id";
  static  String createLike({required String id}) =>"$baseUrl/likes/audition-toggle-like/$id";
  static  String getComment({required String id}) =>"$baseUrl/comments/all-comment/$id";


}
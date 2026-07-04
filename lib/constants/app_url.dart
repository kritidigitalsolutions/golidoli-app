class AppUrl {
  static const String baseUrl = 'http://192.168.1.24:5000';
  static const String sendOtp = '$baseUrl/api/auth/send-otp';
  static const String verifyOtp = "$baseUrl/api/auth/verify-otp";
  static const String logout = "$baseUrl/api/auth/logout";
  static const String completeProfile = "$baseUrl/api/user/complete-profile";
  static const String fetchProfile = "$baseUrl/api/user/profile";
  static const String updateProfile = "$baseUrl/api/user/update-profile";
}

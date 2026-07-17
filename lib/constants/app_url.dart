class AppUrl {
  static const String baseUrl = 'http://192.168.1.17:5000';
  static const String sendOtp = '$baseUrl/api/auth/send-otp';
  static const String verifyOtp = "$baseUrl/api/auth/verify-otp";
  static const String logout = "$baseUrl/api/auth/logout";
  static const String completeProfile = "$baseUrl/api/user/complete-profile";
  static const String fetchProfile = "$baseUrl/api/user/profile";
  static const String updateProfile = "$baseUrl/api/user/update-profile";
  static const String allMovies = "$baseUrl/api/movies";
  static String detailMovie(String id) => "$baseUrl/api/movies/$id";
  static const String allSeries = "$baseUrl/api/series";
  static String seriesDetail(String id) => "$baseUrl/api/series/$id";
  static String episodes(String id) => "$baseUrl/api/series/episodes/$id";
  static String helpApi="$baseUrl/api/help";
  static String singleEpisode({required String id})=>"$baseUrl/api/episodes/$id";
  static String legalApi= "$baseUrl/api/legal";
  static String singleLegalApi({required String id})=>"$baseUrl/api/legal/$id";
}

class AppUrl {
  // static const String baseUrl = 'http://192.168.1.21:5000';
  static const String baseUrl = 'https://goli-doli-ott-backend.vercel.app';
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
  static String helpApi = "$baseUrl/api/help";
  static String singleEpisode({required String id}) =>
      "$baseUrl/api/episodes/$id";
  static String legalApi = "$baseUrl/api/legal";
  static String singleLegalApi({required String id}) =>
      "$baseUrl/api/legal/$id";
  static String allMicroDramaApis = "$baseUrl/api/microdramas";
  static String singleMicroDrama({required String id}) =>
      "$baseUrl/api/microdramas/$id";
  static String allCategories = "$baseUrl/api/categories";
  static String categoryDetail({required String id, int? page, int? size}) =>
      "$baseUrl/api/categories/$id?page=$page&size=$size";
  static String microDramaEpisodeDetail({required String id}) =>
      "$baseUrl/api/microdramas-episodes/$id";
  static String plan({required String name}) => "$baseUrl/api/plan/$name";
  static String allContentApi = "$baseUrl/api/content";
  static String searchContent({required String query}) =>
      "$baseUrl/api/content/?search=$query";

  static String createOrder = "$baseUrl/api/payment/create-order";
  static String verifyPayment = "$baseUrl/api/payment/verify";
  static const String subscriptionStatus = "$baseUrl/api/subscription/status";

  // Home Banners & Intro Screens
  static const String homeBanners = "$baseUrl/api/home-banners";
  static const String introScreens = "$baseUrl/api/intro-screens";

  // Watchlist APIs
  static const String watchlist = "$baseUrl/api/watchlist";
  static String deleteWatchlist(String id) => "$baseUrl/api/watchlist/$id";

  // Notification APIs
  static const String fcmToken = "$baseUrl/api/notifications/fcm-token";
  static const String notifications = "$baseUrl/api/notifications";
  static const String unreadNotificationsCount =
      "$baseUrl/api/notifications/unread-count";
  static String markNotificationRead(String id) =>
      "$baseUrl/api/notifications/$id/read";
  static const String markAllNotificationsRead =
      "$baseUrl/api/notifications/read-all";
  static String deleteNotification(String id) =>
      "$baseUrl/api/notifications/$id";
  static const String notificationSettings =
      "$baseUrl/api/notification-settings";

  // Continue Watching APIs
  static const String saveWatchProgress =
      "$baseUrl/api/continue-watching/progress";
  static const String continueWatchingList = "$baseUrl/api/continue-watching";
  static String watchProgressForContent(String contentId) =>
      "$baseUrl/api/continue-watching/progress/$contentId";
  static String markWatchCompleted(String progressId) =>
      "$baseUrl/api/continue-watching/complete/$progressId";
  static String deleteWatchProgress(String progressId) =>
      "$baseUrl/api/continue-watching/$progressId";
}

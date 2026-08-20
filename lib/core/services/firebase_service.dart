import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:path_provider/path_provider.dart';

import 'package:golidoli_app/core/services/storage_service.dart';
import 'package:golidoli_app/routes/app_routes.dart';
import 'package:golidoli_app/features/web_series/views/web_series_detail_screen.dart';
import 'package:golidoli_app/features/micro_drama/views/micro_drama_detail_screen.dart';
import 'package:golidoli_app/features/profile/repositories/notification_repository.dart';

class NotificationService extends GetxController {
  static NotificationService get to => Get.find();

  final NotificationRepository _repository = NotificationRepository();

  FirebaseMessaging get _firebaseMessaging => FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final RxList<Map<String, dynamic>> notifications =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt unreadCount = 0.obs;

  String? _currentToken;

  Future<void> init() async {
    if (GetPlatform.isWeb) {
      print("🌐 Notifications skipped on Web for now.");
      return;
    }
    print("🚀 NotificationService INIT STARTED");
    tz.initializeTimeZones();

    // Initialize Firebase
    await Firebase.initializeApp();

    /// 🔐 Request Permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("🔔 Permission Status: ${settings.authorizationStatus}");

    // Get FCM Token
    _currentToken = await _firebaseMessaging.getToken();
    print("FCM Token: $_currentToken");

    if (_currentToken != null) {
      uploadToken();
    }

    // Listen for token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      _currentToken = newToken;
      uploadToken();
    });

    /// 🔔 Initialize Local Notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("Notification clicked: ${response.payload}");
        if (response.payload != null) {
          try {
            final Map<String, dynamic> data = jsonDecode(response.payload!);
            handleNotificationClick(data);
          } catch (e) {
            print("Error parsing notification payload: $e");
          }
        }
      },
    );

    /// 📩 Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Foreground Message Received: ${message.notification?.title}");
      _handleMessage(message);
      _showLocalNotification(message);
    });

    /// 📲 Notification Click (App in background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
        "📲 Notification Clicked (Background): ${message.notification?.title}",
      );
      _handleMessage(message);
      handleNotificationClick(message.data);
    });

    /// 🚀 Check if app was opened from a notification (App was terminated)
    RemoteMessage? initialMessage = await _firebaseMessaging
        .getInitialMessage();
    if (initialMessage != null) {
      print("🚀 App opened from terminated state via notification");
      handleNotificationClick(initialMessage.data);
    }

    _loadNotifications();
    fetchNotifications(); // Fetch notifications & unread count from server
    print("🚀 NotificationService INIT COMPLETED");
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    if (scheduledDate.isBefore(DateTime.now())) return;

    await _localNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'golidoli_reminders',
          'Golidoli Reminders',
          channelDescription: 'Reminders for upcoming movies and series',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _localNotificationsPlugin.cancel(id);
  }

  /// 📡 Upload FCM Token to Backend
  Future<void> uploadToken() async {
    if (GetPlatform.isWeb) return;
    try {
      final token = await StorageService.getToken();
      if (token == null || token.isEmpty) {
        print("⏭️ FCM Token upload skipped: User not logged in");
        return;
      }

      _currentToken ??= await _firebaseMessaging.getToken();

      if (_currentToken == null) {
        print("⚠️ FCM Token is NULL. Cannot upload.");
        return;
      }

      print("📡 Uploading FCM Token to Backend: $_currentToken");
      final response = await _repository.uploadFcmToken(_currentToken!);
      print("✅ FCM Token Synced Successfully: $response");
    } catch (e) {
      print("⚠️ FCM Token Sync Failed: $e");
    }
  }

  /// 📥 Fetch Notifications and Unread Count from Backend
  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final response = await _repository.fetchNotifications();

      List fetchedList = [];
      if (response is List) {
        fetchedList = response;
      } else if (response is Map && response['success'] == true) {
        fetchedList = response['notifications'] ?? [];
      }

      notifications.assignAll(
        fetchedList.map((e) {
          return {
            'id': e['_id'] ?? '',
            'title': e['title'] ?? '',
            'body': e['message'] ?? e['body'] ?? '',
            'subtitle': e['message'] ?? e['body'] ?? '',
            'image': e['image'] ?? e['imageUrl'] ?? '',
            'time': e['sentAt'] ?? e['createdAt'] ?? DateTime.now().toString(),
            'isRead': e['isRead'] ?? false,
            'type': e['type'] ?? '',
          };
        }).toList(),
      );
      _saveNotifications();
      print("✅ Fetched ${notifications.length} notifications from server");

      // Fetch unread count
      await fetchUnreadCount();
    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 📥 Fetch Unread Notifications Count from Backend
  Future<void> fetchUnreadCount() async {
    try {
      final response = await _repository.fetchUnreadCount();
      if (response != null && response['success'] == true) {
        unreadCount.value = response['unreadCount'] ?? 0;
      } else if (response is Map && response['count'] != null) {
        unreadCount.value = response['count'] ?? 0;
      }
    } catch (e) {
      print("Error fetching unread notifications count: $e");
    }
  }

  /// ✅ Mark Single Notification as Read
  Future<void> markAsRead(int index) async {
    if (index >= notifications.length) return;
    if (notifications[index]['isRead'] == true) return;

    final String? id = notifications[index]['id'];
    if (id == null || id.isEmpty) {
      notifications[index]['isRead'] = true;
      notifications.refresh();
      _saveNotifications();
      return;
    }

    try {
      final response = await _repository.markNotificationRead(id);

      if (response != null && response['success'] == true) {
        notifications[index]['isRead'] = true;
        notifications.refresh();
        _saveNotifications();
        if (unreadCount.value > 0) {
          unreadCount.value--;
        }
      }
    } catch (e) {
      print("Error marking notification read: $e");
    }
  }

  /// ✅ Mark All Notifications as Read
  Future<void> markAllAsRead() async {
    try {
      final response = await _repository.markAllNotificationsRead();

      if (response != null && response['success'] == true) {
        for (var n in notifications) {
          n['isRead'] = true;
        }
        notifications.refresh();
        _saveNotifications();
        unreadCount.value = 0;
      }
    } catch (e) {
      print("Error marking all read: $e");
    }
  }

  /// ❌ Delete Single Notification
  Future<void> deleteSingleNotification(int index) async {
    if (index >= notifications.length) return;

    final String? id = notifications[index]['id'];
    final bool wasUnread = notifications[index]['isRead'] == false;

    if (id == null || id.isEmpty) {
      notifications.removeAt(index);
      _saveNotifications();
      return;
    }

    try {
      final response = await _repository.deleteNotification(id);

      if (response != null && response['success'] == true) {
        notifications.removeAt(index);
        _saveNotifications();
        if (wasUnread && unreadCount.value > 0) {
          unreadCount.value--;
        }
      }
    } catch (e) {
      print("Error deleting notification: $e");
      notifications.removeAt(index);
      _saveNotifications();
    }
  }

  /// 🧹 Clear All Notifications (Local + Backend)
  Future<void> clearNotifications() async {
    try {
      isLoading.value = true;
      final ids = notifications
          .map((e) => e['id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toList();

      if (ids.isNotEmpty) {
        await Future.wait(
          ids.map((id) => _repository.deleteNotification(id)),
        );
      }
    } catch (e) {
      print("Error clearing notifications from backend: $e");
    } finally {
      notifications.clear();
      unreadCount.value = 0;
      _saveNotifications();
      isLoading.value = false;
    }
  }

  void _handleMessage(RemoteMessage message) {
    print("--- FULL NOTIFICATION CONTENT ---");
    print("Message ID: ${message.messageId}");
    print("From: ${message.from}");
    print("Sent Time: ${message.sentTime}");

    if (message.notification != null) {
      print("Notification Title: ${message.notification?.title}");
      print("Notification Body: ${message.notification?.body}");
      print(
        "Notification Android Image: ${message.notification?.android?.imageUrl}",
      );
    }

    print("Data Payload: ${message.data}");
    print("----------------------------------");

    if (message.notification != null) {
      fetchNotifications();
    }
  }

  void handleNotificationClick(Map<String, dynamic> data) {
    print("🎯 Handling Notification Click with data: $data");

    String? contentType = data['contentType']?.toString().toLowerCase();
    String? contentId = data['contentId']?.toString();
    String? actionUrl = data['actionUrl']?.toString();

    if (contentType == null || contentId == null) {
      if (actionUrl != null && actionUrl.contains("://")) {
        final parts = actionUrl
            .substring(actionUrl.indexOf("://") + 3)
            .split("/");
        if (parts.length >= 3 && parts[1] == "id") {
          contentType = parts[0].toLowerCase();
          contentId = parts[2];
        }
      }
    }

    if (contentType == 'plan' ||
        contentType == 'plans' ||
        contentType == 'subscription') {
      print("🚀 Navigating to Subscription page");
      Get.toNamed(AppRoutes.subscription);
      return;
    }

    if (contentId != null && contentId.isNotEmpty) {
      if (contentType == 'movie') {
        print("🚀 Navigating to Movie Details: $contentId");
        Get.toNamed(AppRoutes.movieDetails, arguments: contentId);
      } else if (contentType == 'series' ||
          contentType == 'web_series' ||
          contentType == 'webseries') {
        print("🚀 Navigating to Web Series Details: $contentId");
        Get.to(() => WebSeriesDetailScreen(id: contentId ?? ''));
      } else if (contentType == 'micro_drama' || contentType == 'microdrama') {
        print("🚀 Navigating to Micro Drama Details: $contentId");
        Get.to(() => MicroDramaDetailScreen(id: contentId ?? ''));
      }
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    if (message.notification == null) return;

    String? imageUrl =
        message.notification?.android?.imageUrl ??
        message.notification?.apple?.imageUrl ??
        message.data['image'] ??
        message.data['imageUrl'];

    BigPictureStyleInformation? bigPictureStyleInformation;
    String? largeIconPath;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final String fileName =
            'notification_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String imagePath = await _downloadAndSaveFile(imageUrl, fileName);
        largeIconPath = imagePath;
        bigPictureStyleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(imagePath),
          contentTitle: message.notification?.title,
          summaryText: message.notification?.body,
          htmlFormatContentTitle: true,
          htmlFormatSummaryText: true,
        );
      } catch (e) {
        print("⚠️ Error downloading notification image: $e");
      }
    }

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'golidoli_ott_channel',
      'Golidoli OTT Notifications',
      channelDescription: 'Important notifications from Golidoli OTT',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
      largeIcon: largeIconPath != null
          ? FilePathAndroidBitmap(largeIconPath)
          : null,
      styleInformation: bigPictureStyleInformation,
    );

    NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        attachments: largeIconPath != null
            ? [DarwinNotificationAttachment(largeIconPath)]
            : null,
      ),
    );

    await _localNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformDetails,
      payload: jsonEncode(message.data),
    );
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  void _loadNotifications() {
    try {
      var box = Hive.box('appBox');
      List? saved = box.get('notifications');
      if (saved != null) {
        final List<Map<String, dynamic>> convertedList = saved.map((item) {
          return Map<String, dynamic>.from(item as Map);
        }).toList();

        notifications.assignAll(convertedList);
        print("✅ Loaded ${notifications.length} saved notifications");
      }
    } catch (e) {
      print("❌ Error loading notifications from Hive: $e");
    }
  }

  void _saveNotifications() {
    try {
      var box = Hive.box('appBox');
      box.put('notifications', notifications.toList());
    } catch (e) {
      print("❌ Error saving notifications to Hive: $e");
    }
  }
}

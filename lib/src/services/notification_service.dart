import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shop/src/providers/auth_provider.dart';
import 'package:shop/src/repositories/user_repository.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();
  final _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;
  final AuthProvider authProvider = AuthProvider();

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    getToken();
    // request permission
    await _requestPermission();

    // setup message handler
    await _setupMessageHandlers();

    // setup flutter notifications
    await setupFlutterNotifications();

    // subscribe to all devices/broadcast
    subscribeToTopic('all_devices');
  }

  // get token
  Future<String?> getToken() async {
    final token = await _messaging.getToken();
    if (authProvider.isLoggedIn) {
      // store token in the backend
      await UserRepository().storeFcmToken(token!);
    }
    return token;
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: false,
        carPlay: false,
        criticalAlert: false);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    // android setup
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications',
      importance: Importance.high,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/notification_icon');

    // ios setup
    const initializationSettingsDarwing = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwing,
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        _handleNotificationClick(details.payload);
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      await _localNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@drawable/notification_icon',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data['type'],
      );
    }
  }

  Future<void> _setupMessageHandlers() async {
    // foreground
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    // background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotificationClick(message.data['type']);
    });

    // opened app
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationClick(initialMessage.data['type']);
    }
  }

  void _handleNotificationClick(String? payload) {
    print(payload);
    // if (payload == 'announcement') {
    //   navigatorKey.currentState?.push(
    //     MaterialPageRoute(
    //       builder: (context) => const Announcements(),
    //     ),
    //   );
    // } else if (payload == 'live') {
    //   navigatorKey.currentState?.push(
    //     MaterialPageRoute(
    //       builder: (context) => const LiveScreen(),
    //     ),
    //   );
    // } else {
    //   // Handle other payloads or default action
    // }
  }

  Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }
}

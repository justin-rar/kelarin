import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static const String channelId = 'kelarin_channel_v2';
  static const String soundResourceName = 'kelarinnotificationsound';

  static const AndroidNotificationChannel _defaultChannel = AndroidNotificationChannel(
    channelId,
    'Kelarin Notifications',
    description: 'Pengingat tugas dan absensi Kelarin',
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound(soundResourceName),
    enableVibration: true,
  );

  Future<NotificationService> init() async {
    try {
      // 1. Inisialisasi timezone
      tzdata.initializeTimeZones();
      try {
        final String timeZoneName = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(timeZoneName));
      } catch (e) {
        try {
          tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
        } catch (_) {}
      }

      // 2. Inisialisasi pengaturan platform
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
        macOS: iosSettings,
      );

      await _plugin.initialize(initSettings);

      // 3. Buat Notification Channel untuk Android 8.0+ dengan suara custom
      final androidImplementation = _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        try {
          // Hapus channel versi lama agar pengaturan suara custom langsung berlaku
          await androidImplementation.deleteNotificationChannel('kelarin_channel');
        } catch (_) {}

        await androidImplementation.createNotificationChannel(_defaultChannel);
        await androidImplementation.requestNotificationsPermission();
        await androidImplementation.requestExactAlarmsPermission();
      }
    } catch (e) {
      debugPrint('NotificationService init error: $e');
    }
    return this;
  }

  Future<void> requestPermissions() async {
    try {
      final androidImplementation = _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
        await androidImplementation.requestExactAlarmsPermission();
      }
    } catch (e) {
      debugPrint('Error requesting notification permissions: $e');
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        channelId,
        'Kelarin Notifications',
        channelDescription: 'Pengingat tugas dan absensi Kelarin',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(soundResourceName),
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        sound: 'kelarinnotificationsound.mp3',
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
        macOS: iosDetails,
      );

      await _plugin.show(id, title, body, details);
    } catch (e) {
      Get.snackbar(title, body, snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    try {
      final now = DateTime.now();

      // Jika waktu sudah lewat lebih dari 30 detik yang lalu, jangan jadwalkan
      if (scheduledDate.isBefore(now.subtract(const Duration(seconds: 30)))) {
        debugPrint('Waktu notifikasi sudah lewat: $scheduledDate');
        return;
      }

      // Jika waktu penjadwalan tepat saat ini atau dalam 5 detik ke depan,
      // langsung munculkan notifikasi agar user langsung melihatnya
      if (scheduledDate.isBefore(now.add(const Duration(seconds: 5)))) {
        await showNotification(id: id, title: title, body: body);
        return;
      }

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        channelId,
        'Kelarin Notifications',
        channelDescription: 'Pengingat tugas dan absensi Kelarin',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(soundResourceName),
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        sound: 'kelarinnotificationsound.mp3',
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
        macOS: iosDetails,
      );

      final tzScheduledDate = tz.TZDateTime(
        tz.local,
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        scheduledDate.hour,
        scheduledDate.minute,
        scheduledDate.second,
      );

      final tzNow = tz.TZDateTime.now(tz.local);
      if (!tzScheduledDate.isAfter(tzNow)) {
        // Jika selisih waktu sudah sangat dekat atau terlewat beberapa detik, langsung tampilkan
        await showNotification(id: id, title: title, body: body);
        return;
      }

      try {
        await _plugin.zonedSchedule(
          id,
          title,
          body,
          tzScheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      } catch (e) {
        // Fallback jika exact alarm belum diizinkan user di sistem Android
        await _plugin.zonedSchedule(
          id,
          title,
          body,
          tzScheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _plugin.cancel(id);
    } catch (e) {
      debugPrint('Error canceling notification: $e');
    }
  }
}

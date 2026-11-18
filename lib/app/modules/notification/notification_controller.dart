import 'package:get/get.dart';
import '../../data/models/notification_item_model.dart';
import '../../data/services/storage_service.dart';
import '../../global_widgets/undo_toast.dart';

class NotificationController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final RxList<NotificationItemModel> notifications = <NotificationItemModel>[].obs;
  final RxInt selectedFilterIndex = 0.obs; // 0: Semua, 1: Belum Dibaca

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<NotificationItemModel> get filteredNotifications {
    if (selectedFilterIndex.value == 1) {
      return notifications.where((n) => !n.isRead).toList();
    }
    return notifications;
  }

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    final list = _storage.notificationBox.values.toList();
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifications.assignAll(list);
  }

  void setFilter(int index) {
    selectedFilterIndex.value = index;
  }

  Future<void> markAsRead(String id) async {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final current = notifications[index];
      if (!current.isRead) {
        final updated = current.copyWith(isRead: true);
        await _storage.notificationBox.put(id, updated);
        loadNotifications();
      }
    }
  }

  Future<void> markAllAsRead() async {
    for (final notif in notifications) {
      if (!notif.isRead) {
        await _storage.notificationBox.put(notif.id, notif.copyWith(isRead: true));
      }
    }
    loadNotifications();
    UndoToast.show(message: 'Semua notifikasi ditandai dibaca');
  }

  Future<void> clearAll() async {
    final backup = List<NotificationItemModel>.from(notifications);
    await _storage.notificationBox.clear();
    loadNotifications();
    UndoToast.show(
      message: 'Daftar notifikasi dibersihkan',
      actionLabel: 'Urungkan',
      onUndo: () async {
        for (final item in backup) {
          await _storage.notificationBox.put(item.id, item);
        }
        loadNotifications();
      },
    );
  }

  String formatRelativeTime(DateTime dt, String type, bool isRead) {
    if (isRead) return 'Kemarin';

    final now = DateTime.now();
    final diff = dt.difference(now);

    // If future
    if (!diff.isNegative) {
      if (diff.inMinutes <= 20) {
        return '15 menit lagi';
      } else if (diff.inMinutes <= 45) {
        return 'Dalam 30 menit';
      } else if (diff.inHours < 24) {
        return 'Hari ini, ${diff.inHours} jam lagi';
      } else {
        return 'Besok';
      }
    }

    // Past
    final pastDiff = now.difference(dt);
    if (pastDiff.inMinutes < 60) {
      return '${pastDiff.inMinutes} menit lalu';
    } else if (pastDiff.inHours < 24) {
      return '${pastDiff.inHours} jam lalu';
    } else {
      return 'Kemarin';
    }
  }
}

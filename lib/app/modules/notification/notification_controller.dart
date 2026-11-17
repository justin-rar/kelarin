import 'package:get/get.dart';
import '../../data/models/notification_item_model.dart';
import '../../data/services/storage_service.dart';
import '../../global_widgets/undo_toast.dart';

class NotificationController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final RxList<NotificationItemModel> notifications = <NotificationItemModel>[].obs;

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

  Future<void> markAsRead(String id) async {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final current = notifications[index];
      final updated = current.copyWith(isRead: true);
      await _storage.notificationBox.put(id, updated);
      loadNotifications();
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
    await _storage.notificationBox.clear();
    loadNotifications();
    UndoToast.show(message: 'Daftar notifikasi dibersihkan');
  }
}


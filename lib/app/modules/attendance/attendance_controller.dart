import 'package:get/get.dart';
import '../../data/models/attendance_model.dart';
import '../../data/models/notification_item_model.dart';
import '../../data/services/notification_service.dart';
import '../../data/services/storage_service.dart';
import '../../global_widgets/undo_toast.dart';

class AttendanceController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  NotificationService get _notifications => Get.find<NotificationService>();

  final RxList<AttendanceModel> attendances = <AttendanceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAttendances();
  }

  @override
  void onReady() {
    super.onReady();
    // Reload ulang setiap kali controller siap (misalnya setelah kembali dari halaman add)
    loadAttendances();
  }

  void loadAttendances() {
    attendances.assignAll(_storage.attendanceBox.values.toList());
  }

  int _baseNotifId(String attId) {
    return (attId.hashCode & 0x7FFFFFFF) % 10000000;
  }

  Future<void> _scheduleReminders({
    required AttendanceModel model,
    required DateTime scheduledTime,
    bool notifyAtStart = true,
    bool notify15Min = false,
    bool notify30Min = false,
  }) async {
    final baseId = _baseNotifId(model.id);

    // 1. Saat kuliah dimulai
    if (notifyAtStart) {
      await _notifications.scheduleNotification(
        id: baseId,
        title: 'Jadwal Kuliah: ${model.subjectName}',
        body: 'Mata kuliah ${model.subjectName} (${model.room}) dimulai sekarang. Waktunya presensi!',
        scheduledDate: scheduledTime,
      );
    }

    // 2. 15 menit sebelum
    if (notify15Min) {
      final time15 = scheduledTime.subtract(const Duration(minutes: 15));
      await _notifications.scheduleNotification(
        id: baseId + 1,
        title: 'Pengingat Presensi: 15 Menit Lagi',
        body: 'Kuliah ${model.subjectName} di ${model.room} akan dimulai dalam 15 menit.',
        scheduledDate: time15,
      );
    }

    // 3. 30 menit sebelum
    if (notify30Min) {
      final time30 = scheduledTime.subtract(const Duration(minutes: 30));
      await _notifications.scheduleNotification(
        id: baseId + 2,
        title: 'Pengingat Presensi: 30 Menit Lagi',
        body: 'Kuliah ${model.subjectName} di ${model.room} akan dimulai dalam 30 menit.',
        scheduledDate: time30,
      );
    }

    // Simpan item notifikasi ke riwayat notifikasi lokal
    final notifItem = NotificationItemModel(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Jadwal Presensi: ${model.subjectName}',
      message: 'Pengingat jadwal kuliah ${model.subjectName} (${model.time}) di ${model.room} aktif.',
      timestamp: DateTime.now(),
      isRead: false,
      type: 'PRESENSI',
    );
    await _storage.notificationBox.put(notifItem.id, notifItem);
  }

  Future<void> _cancelReminders(String attId) async {
    final baseId = _baseNotifId(attId);
    await _notifications.cancelNotification(baseId);
    await _notifications.cancelNotification(baseId + 1);
    await _notifications.cancelNotification(baseId + 2);
  }

  Future<void> addAttendance(
    AttendanceModel model, {
    bool notifyAtStart = true,
    bool notify15Min = false,
    bool notify30Min = false,
  }) async {
    await _storage.attendanceBox.put(model.id, model);
    loadAttendances();

    if (model.reminderActive && model.scheduledEpoch != null) {
      final scheduledTime = DateTime.fromMillisecondsSinceEpoch(model.scheduledEpoch!);
      await _scheduleReminders(
        model: model,
        scheduledTime: scheduledTime,
        notifyAtStart: notifyAtStart,
        notify15Min: notify15Min,
        notify30Min: notify30Min,
      );
    }

    UndoToast.show(message: 'Jadwal presensi berhasil ditambahkan');
  }

  Future<void> updateAttendance(AttendanceModel model) async {
    await _storage.attendanceBox.put(model.id, model);
    loadAttendances();

    await _cancelReminders(model.id);
    if (model.reminderActive && model.scheduledEpoch != null) {
      final scheduledTime = DateTime.fromMillisecondsSinceEpoch(model.scheduledEpoch!);
      await _scheduleReminders(
        model: model,
        scheduledTime: scheduledTime,
      );
    }

    UndoToast.show(message: 'Jadwal presensi diperbarui');
  }

  Future<void> deleteAttendance(String id) async {
    await _cancelReminders(id);
    await _storage.attendanceBox.delete(id);
    loadAttendances();
    UndoToast.show(message: 'Jadwal presensi dihapus');
  }

  Future<void> toggleReminder(String id) async {
    final index = attendances.indexWhere((a) => a.id == id);
    if (index != -1) {
      final current = attendances[index];
      final newStatus = !current.reminderActive;
      final updated = current.copyWith(reminderActive: newStatus);
      await _storage.attendanceBox.put(id, updated);
      loadAttendances();

      if (!newStatus) {
        await _cancelReminders(id);
      } else if (current.scheduledEpoch != null) {
        var scheduledTime =
            DateTime.fromMillisecondsSinceEpoch(current.scheduledEpoch!);
        final now = DateTime.now();
        while (scheduledTime.isBefore(now)) {
          scheduledTime = scheduledTime.add(const Duration(days: 7));
        }
        await _scheduleReminders(
          model: updated,
          scheduledTime: scheduledTime,
        );
      }
    }
  }

  Future<void> incrementAttendance(String id) async {
    final index = attendances.indexWhere((a) => a.id == id);
    if (index != -1) {
      final current = attendances[index];
      if (current.attendedMeetings < current.totalMeetings) {
        final updated = current.copyWith(
          attendedMeetings: current.attendedMeetings + 1,
        );
        await _storage.attendanceBox.put(id, updated);
        loadAttendances();
        UndoToast.show(message: 'Kehadiran ${current.subjectName} dicatat');
      }
    }
  }
}


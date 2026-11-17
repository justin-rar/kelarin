import 'package:get/get.dart';
import '../../data/models/attendance_model.dart';
import '../../data/services/storage_service.dart';
import '../../global_widgets/undo_toast.dart';

class AttendanceController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final RxList<AttendanceModel> attendances = <AttendanceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAttendances();
  }

  void loadAttendances() {
    attendances.assignAll(_storage.attendanceBox.values.toList());
  }

  Future<void> addAttendance(AttendanceModel model) async {
    await _storage.attendanceBox.put(model.id, model);
    loadAttendances();
    UndoToast.show(message: 'Jadwal presensi berhasil ditambahkan');
  }

  Future<void> updateAttendance(AttendanceModel model) async {
    await _storage.attendanceBox.put(model.id, model);
    loadAttendances();
    UndoToast.show(message: 'Jadwal presensi diperbarui');
  }

  Future<void> deleteAttendance(String id) async {
    await _storage.attendanceBox.delete(id);
    loadAttendances();
    UndoToast.show(message: 'Jadwal presensi dihapus');
  }

  Future<void> toggleReminder(String id) async {
    final index = attendances.indexWhere((a) => a.id == id);
    if (index != -1) {
      final current = attendances[index];
      final updated = current.copyWith(reminderActive: !current.reminderActive);
      await _storage.attendanceBox.put(id, updated);
      loadAttendances();
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


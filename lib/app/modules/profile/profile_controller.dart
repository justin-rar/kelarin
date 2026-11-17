import 'package:get/get.dart';
import '../../data/services/storage_service.dart';
import '../../global_widgets/undo_toast.dart';
import '../../routes/app_routes.dart';
import '../task/task_controller.dart';

class ProfileController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final TaskController _taskController = Get.find<TaskController>();

  final RxString name = ''.obs;
  final RxString nim = ''.obs;
  final RxString email = ''.obs;
  final RxString major = ''.obs;
  final RxString semester = ''.obs;
  final RxBool isPinEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  void loadProfile() {
    name.value = _storage.userName;
    nim.value = _storage.userNim;
    email.value = _storage.userEmail;
    major.value = _storage.userMajor;
    semester.value = _storage.userSemester;
    isPinEnabled.value = _storage.isPinEnabled;
  }

  int get completedTasksCount => _taskController.completedTasks.length;
  int get activeTasksCount => _taskController.activeTasks.length;

  Future<void> updateProfile({
    required String newName,
    required String newNim,
    required String newEmail,
    required String newMajor,
    required String newSemester,
  }) async {
    await _storage.setProfile(
      name: newName,
      nim: newNim,
      email: newEmail,
      major: newMajor,
      semester: newSemester,
    );
    loadProfile();
    UndoToast.show(message: 'Profil berhasil diperbarui');
  }

  Future<void> togglePinEnabled(bool enabled) async {
    if (enabled) {
      // Go to PIN Setup
      final result = await Get.toNamed(AppRoutes.pin, arguments: {'isAuth': false});
      if (result == true) {
        isPinEnabled.value = true;
      }
    } else {
      await _storage.setPinEnabled(false);
      isPinEnabled.value = false;
      UndoToast.show(message: 'Kunci PIN keamanan dinonaktifkan');
    }
  }

  void changePin() {
    Get.toNamed(AppRoutes.pin, arguments: {'isAuth': false});
  }

  Future<void> clearAllData() async {
    await _storage.taskBox.clear();
    await _storage.attendanceBox.clear();
    await _storage.noteBox.clear();
    await _storage.notificationBox.clear();
    _taskController.loadTasks();
    loadProfile();
    UndoToast.show(message: 'Seluruh data lokal berhasil dibersihkan');
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/services/storage_service.dart';
import '../../global_widgets/confirmation_dialog.dart';
import '../../global_widgets/undo_toast.dart';
import '../../routes/app_routes.dart';
import '../task/task_controller.dart';

class ProfileController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  TaskController get _taskController => Get.isRegistered<TaskController>()
      ? Get.find<TaskController>()
      : Get.put(TaskController(), permanent: true);

  final RxString name = ''.obs;
  final RxString nim = ''.obs;
  final RxString email = ''.obs;
  final RxString major = ''.obs;
  final RxString semester = ''.obs;
  final RxBool isPinEnabled = false.obs;
  final RxBool isNotificationsEnabled = true.obs;
  final Rx<String?> profileImagePath = Rx<String?>(null);
  final RxString securityQuestion = ''.obs;
  final RxString securityAnswer = ''.obs;

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
    profileImagePath.value = _storage.profileImagePath;
    securityQuestion.value = _storage.securityQuestion;
    securityAnswer.value = _storage.securityAnswer;
  }

  int get completedTasksCount => _taskController.completedTasks.length;
  int get activeTasksCount => _taskController.activeTasks.length;

  Future<void> updateProfile({
    required String newName,
    String? newSecurityQuestion,
    String? newSecurityAnswer,
    String? newNim,
    String? newEmail,
    String? newMajor,
    String? newSemester,
  }) async {
    await _storage.setProfile(
      name: newName,
      nim: newNim ?? nim.value,
      email: newEmail ?? email.value,
      major: newMajor ?? major.value,
      semester: newSemester ?? semester.value,
    );
    if (newSecurityQuestion != null && newSecurityAnswer != null) {
      await _storage.setSecurityInfo(newSecurityQuestion, newSecurityAnswer);
    }
    loadProfile();
    UndoToast.show(message: 'Profil berhasil diperbarui');
  }

  Future<void> pickProfileImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (picked != null) {
        profileImagePath.value = picked.path;
        await _storage.setProfileImagePath(picked.path);
        UndoToast.show(message: 'Foto profil berhasil diperbarui');
      }
    } catch (_) {
      UndoToast.show(message: 'Gagal memilih foto profil');
    }
  }

  Future<void> removeProfileImage() async {
    profileImagePath.value = null;
    await _storage.setProfileImagePath(null);
    UndoToast.show(message: 'Foto profil dihapus');
  }

  void showAvatarPickerSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.statDark,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Ganti Foto Profil',
              style: AppTypography.cardTitle.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Pilih sumber foto profil Anda',
              style: AppTypography.bodyDefault.copyWith(
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 20),
            _buildAvatarOption(
              icon: Icons.camera_alt_outlined,
              label: 'Ambil dari Kamera',
              onTap: () {
                Get.back();
                pickProfileImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: 10),
            _buildAvatarOption(
              icon: Icons.photo_library_outlined,
              label: 'Pilih dari Galeri',
              onTap: () {
                Get.back();
                pickProfileImage(ImageSource.gallery);
              },
            ),
            if (profileImagePath.value != null) ...[
              const SizedBox(height: 10),
              _buildAvatarOption(
                icon: Icons.delete_outline_rounded,
                label: 'Hapus Foto Profil',
                onTap: () {
                  Get.back();
                  removeProfileImage();
                },
              ),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildAvatarOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.fill1,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: AppTypography.buttonText.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Toggle PIN Lock with full security checks
  Future<void> togglePinEnabled(bool enabled) async {
    if (enabled) {
      // 1. Enable PIN: requires entering new PIN + 1x confirmation
      final result = await Get.toNamed(
        AppRoutes.pin,
        arguments: {'mode': 'setup', 'isAuth': false},
      );
      if (result == true) {
        isPinEnabled.value = true;
      }
    } else {
      // 3. Disable PIN: requires user confirmation dialog AND inputting current PIN
      _showDisablePinConfirmation();
    }
  }

  void _showDisablePinConfirmation() {
    ConfirmationDialog.show(
      title: 'Nonaktifkan Kunci PIN?',
      message: 'Aplikasi tidak akan lagi meminta PIN saat dibuka. Untuk alasan keamanan, Anda harus mengonfirmasi PIN saat ini.',
      icon: Icons.lock_open_rounded,
      confirmText: 'Lanjutkan',
      cancelText: 'Batal',
      onConfirm: () async {
        Get.back(); // close confirmation dialog
        // Navigate to PIN verification to disable
        final result = await Get.toNamed(
          AppRoutes.pin,
          arguments: {'mode': 'disableConfirm'},
        );
        if (result == true) {
          isPinEnabled.value = false;
        }
      },
    );
  }

  /// 2. Change PIN: requires old PIN -> new PIN (not in history) -> confirm new PIN
  Future<void> changePin() async {
    await Get.toNamed(
      AppRoutes.pin,
      arguments: {'mode': 'change'},
    );
    loadProfile();
  }

  void toggleNotificationsEnabled(bool enabled) {
    isNotificationsEnabled.value = enabled;
    UndoToast.show(
      message: enabled
          ? 'Notifikasi & pengingat diaktifkan'
          : 'Notifikasi & pengingat dinonaktifkan',
    );
  }

  Future<void> clearCompletedTasks() async {
    final completed = List.from(_taskController.completedTasks);
    if (completed.isEmpty) {
      UndoToast.show(message: 'Tidak ada tugas selesai untuk dibersihkan');
      return;
    }

    ConfirmationDialog.show(
      title: 'Bersihkan Riwayat?',
      message: 'Apakah Anda yakin ingin membersihkan ${completed.length} tugas yang telah selesai?',
      icon: Icons.cleaning_services_rounded,
      confirmText: 'Bersihkan',
      cancelText: 'Batal',
      isDestructive: true,
      onConfirm: () async {
        Get.back();
        for (final task in completed) {
          await _storage.taskBox.delete(task.id);
        }
        _taskController.loadTasks();

        UndoToast.show(
          message: '${completed.length} Tugas selesai dibersihkan',
          actionLabel: 'Urungkan',
          onUndo: () async {
            for (final task in completed) {
              await _storage.taskBox.put(task.id, task);
            }
            _taskController.loadTasks();
          },
        );
      },
    );
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

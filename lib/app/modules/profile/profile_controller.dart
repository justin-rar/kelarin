import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/services/storage_service.dart';
import '../../data/models/task_model.dart';
import '../../data/models/attendance_model.dart';
import '../../data/models/note_model.dart';
import '../../data/models/notification_item_model.dart';
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
      XFile? picked;
      try {
        picked = await picker.pickImage(
          source: source,
          maxWidth: 800,
          maxHeight: 800,
          imageQuality: 85,
        );
      } catch (innerError) {
        // If camera is unsupported or denied (e.g. on emulator/desktop), fallback to gallery
        if (source == ImageSource.camera) {
          picked = await picker.pickImage(
            source: ImageSource.gallery,
            maxWidth: 800,
            maxHeight: 800,
            imageQuality: 85,
          );
        } else {
          rethrow;
        }
      }

      if (picked != null) {
        profileImagePath.value = picked.path;
        await _storage.setProfileImagePath(picked.path);
        UndoToast.show(message: 'Foto profil berhasil diperbarui');
      }
    } catch (e) {
      Get.rawSnackbar(
        message: 'Gagal memilih foto: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
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
      final hasExistingPin = _storage.appPin.isNotEmpty;
      if (hasExistingPin) {
        // PIN sudah pernah dibuat sebelumnya → langsung aktifkan saja
        await _storage.setPinEnabled(true);
        isPinEnabled.value = true;
        UndoToast.show(message: 'Kunci PIN diaktifkan');
      } else {
        // Belum pernah set PIN sama sekali → setup PIN baru
        final result = await Get.toNamed(
          AppRoutes.pin,
          arguments: {'mode': 'setup', 'isAuth': false},
        );
        if (result == true) {
          isPinEnabled.value = true;
        }
      }
    } else {
      // Nonaktifkan PIN: langsung minta konfirmasi PIN lama, tidak perlu dialog dulu
      final result = await Get.toNamed(
        AppRoutes.pin,
        arguments: {'mode': 'disableConfirm'},
      );
      if (result == true) {
        isPinEnabled.value = false;
      }
    }
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

  Future<void> logoutAndReset() async {
    await _storage.taskBox.clear();
    await _storage.attendanceBox.clear();
    await _storage.noteBox.clear();
    await _storage.notificationBox.clear();
    await _storage.prefs.setBool('is_profile_setup_done', false);
    await _storage.prefs.setBool('is_pin_enabled', false);
    await _storage.prefs.setString('app_pin', '');
    await _storage.prefs.setString('user_name', '');
    await _storage.prefs.setString('user_nim', '');
    await _storage.prefs.setString('user_email', '');
    await _storage.prefs.setString('user_major', '');
    await _storage.prefs.setString('user_semester', '');
    await _storage.prefs.remove('profile_image_path');
    loadProfile();
  }

  // ---------------------------------------------------------------------------
  // Backup & Restore
  // ---------------------------------------------------------------------------

  /// Serializes all Hive boxes + profile prefs into a JSON map.
  Map<String, dynamic> _buildBackupPayload() {
    final tasks = _storage.taskBox.values.map((e) => e.toMap()).toList();
    final attendances = _storage.attendanceBox.values.map((e) => e.toMap()).toList();
    final notes = _storage.noteBox.values.map((e) => e.toMap()).toList();
    final notifications = _storage.notificationBox.values.map((e) => e.toMap()).toList();

    return {
      'version': 1,
      'created_at': DateTime.now().toIso8601String(),
      'tasks': tasks,
      'attendances': attendances,
      'notes': notes,
      'notifications': notifications,
      'profile': {
        'user_name': _storage.userName,
        'user_nim': _storage.userNim,
        'user_email': _storage.userEmail,
        'user_major': _storage.userMajor,
        'user_semester': _storage.userSemester,
        'is_pin_enabled': _storage.isPinEnabled,
        'profile_image_path': _storage.profileImagePath,
        'security_question': _storage.securityQuestion,
        'security_answer': _storage.securityAnswer,
      },
    };
  }

  /// Creates a JSON backup file and opens the native Android share sheet
  /// so the user can save it to Google Drive, WhatsApp, email, etc.
  final RxBool isBackingUp = false.obs;

  Future<void> backupData() async {
    if (isBackingUp.value) return;
    isBackingUp.value = true;
    try {
      final payload = _buildBackupPayload();
      final jsonString = const JsonEncoder.withIndent('  ').convert(payload);
      final dir = await getTemporaryDirectory();
      final stamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
      final file = File('${dir.path}/kelarin_backup_$stamp.json');
      await file.writeAsString(jsonString);

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/json')],
        text: 'Backup Kelarin – gunakan "Pulihkan Data" di aplikasi untuk mengimpor kembali.',
      );
    } catch (e) {
      Get.rawSnackbar(
        message: 'Gagal melakukan backup: $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isBackingUp.value = false;
    }
  }

  /// Opens a file picker, reads the selected JSON backup, validates it,
  /// then replaces all local data with the backup contents.
  final RxBool isRestoring = false.obs;

  Future<void> restoreData() async {
    if (isRestoring.value) return;
    isRestoring.value = true;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) {
        isRestoring.value = false;
        return;
      }

      final bytes = result.files.first.bytes ??
          await File(result.files.first.path!).readAsBytes();
      final map = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;

      // Validate
      if (!map.containsKey('tasks') || !map.containsKey('profile')) {
        throw FormatException('Berkas backup tidak valid atau tidak lengkap.');
      }

      // Count items for preview
      final taskCount = (map['tasks'] as List).length;
      final attCount = (map['attendances'] as List?)?.length ?? 0;
      final noteCount = (map['notes'] as List?)?.length ?? 0;
      final createdAt = map['created_at'] ?? 'tidak diketahui';

      // Show confirmation
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.restore, color: AppColors.primary),
              const SizedBox(width: 10),
              Text('Pulihkan Data', style: AppTypography.cardTitle.copyWith(fontWeight: FontWeight.w800)),
            ],
          ),
          content: Text(
            'Backup dari: $createdAt\n\n'
            'Ditemukan:\n'
            '• $taskCount Tugas\n'
            '• $attCount Jadwal / Presensi\n'
            '• $noteCount Catatan\n\n'
            'Data saat ini akan diganti. Lanjutkan?',
            style: AppTypography.bodyDefault.copyWith(color: AppColors.secondary, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('Batal', style: AppTypography.buttonText.copyWith(color: AppColors.outline)),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Pulihkan', style: AppTypography.buttonText.copyWith(color: AppColors.onPrimary)),
            ),
          ],
        ),
      );

      if (confirmed != true) {
        isRestoring.value = false;
        return;
      }

      // Clear existing data
      await _storage.taskBox.clear();
      await _storage.attendanceBox.clear();
      await _storage.noteBox.clear();
      await _storage.notificationBox.clear();

      // Restore tasks
      for (final item in (map['tasks'] as List)) {
        final model = TaskModel.fromMap(item as Map<dynamic, dynamic>);
        await _storage.taskBox.put(model.id, model);
      }
      // Restore attendances
      for (final item in (map['attendances'] as List? ?? [])) {
        final model = AttendanceModel.fromMap(item as Map<dynamic, dynamic>);
        await _storage.attendanceBox.put(model.id, model);
      }
      // Restore notes
      for (final item in (map['notes'] as List? ?? [])) {
        final model = NoteModel.fromMap(item as Map<dynamic, dynamic>);
        await _storage.noteBox.put(model.id, model);
      }
      // Restore notifications
      for (final item in (map['notifications'] as List? ?? [])) {
        final model = NotificationItemModel.fromMap(item as Map<dynamic, dynamic>);
        await _storage.notificationBox.put(model.id, model);
      }

      // Restore profile prefs
      final profile = map['profile'] as Map<String, dynamic>;
      await _storage.setProfile(
        name: profile['user_name'] ?? '',
        nim: profile['user_nim'] ?? '',
        email: profile['user_email'] ?? '',
        major: profile['user_major'] ?? '',
        semester: profile['user_semester'] ?? '',
      );
      await _storage.setSecurityInfo(
        profile['security_question'] ?? '',
        profile['security_answer'] ?? '',
      );
      if (profile['profile_image_path'] != null) {
        await _storage.setProfileImagePath(profile['profile_image_path'] as String);
      }
      await _storage.prefs.setBool('is_pin_enabled', profile['is_pin_enabled'] ?? false);

      // Reload UI
      loadProfile();
      if (Get.isRegistered<TaskController>()) {
        Get.find<TaskController>().loadTasks();
      }

      UndoToast.show(message: 'Data berhasil dipulihkan dari backup');
    } catch (e) {
      Get.rawSnackbar(
        message: 'Gagal memulihkan data: $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isRestoring.value = false;
    }
  }
}

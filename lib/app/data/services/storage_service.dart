import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import '../models/attendance_model.dart';
import '../models/note_model.dart';
import '../models/notification_item_model.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;
  late Box<TaskModel> _taskBox;
  late Box<AttendanceModel> _attendanceBox;
  late Box<NoteModel> _noteBox;
  late Box<NotificationItemModel> _notificationBox;

  Box<TaskModel> get taskBox => _taskBox;
  Box<AttendanceModel> get attendanceBox => _attendanceBox;
  Box<NoteModel> get noteBox => _noteBox;
  Box<NotificationItemModel> get notificationBox => _notificationBox;
  SharedPreferences get prefs => _prefs;

  Future<StorageService> init() async {
    // 1. Initialize Hive
    await Hive.initFlutter();

    // 2. Register Adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(AttendanceModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(NoteModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(NotificationItemModelAdapter());
    }

    // 3. Open Hive Boxes
    _taskBox = await Hive.openBox<TaskModel>('tasks');
    _attendanceBox = await Hive.openBox<AttendanceModel>('attendances');
    _noteBox = await Hive.openBox<NoteModel>('notes');
    _notificationBox = await Hive.openBox<NotificationItemModel>('notifications');

    // 4. Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();

    // 5. Bersihkan residu data dummy lama agar state aplikasi benar-benar kosong murni
    final isLegacyCleared = _prefs.getBool('is_legacy_dummy_cleared_v2') ?? false;
    if (!isLegacyCleared) {
      await _taskBox.clear();
      await _attendanceBox.clear();
      await _noteBox.clear();
      await _notificationBox.clear();
      await _prefs.setBool('is_legacy_dummy_cleared_v2', true);
    }

    // 6. Setup state awal jika belum pernah dibuka
    final isInitialized = _prefs.getBool('is_app_initialized') ?? false;
    if (!isInitialized) {
      await _seedInitialData();
      await _prefs.setBool('is_app_initialized', true);
    }

    return this;
  }

  Future<void> _seedInitialData() async {
    // State awal kosong — tidak ada dummy data
    // Boxes dibuka kosong, user akan mengisi data sendiri

    // Default Profile Data (kosong, akan diisi saat onboarding)
    if (!_prefs.containsKey('user_name')) {
      await _prefs.setString('user_name', '');
      await _prefs.setBool('is_pin_enabled', false);
      await _prefs.setString('app_pin', '');
      await _prefs.setString('security_question', '');
      await _prefs.setString('security_answer', '');
      await _prefs.setBool('is_profile_setup_done', false);
      await _prefs.setStringList('pin_history', []);
    }
  }

  // Profile & PIN helpers
  String get userName => _prefs.getString('user_name') ?? '';
  String get userNim => _prefs.getString('user_nim') ?? '';
  String get userEmail => _prefs.getString('user_email') ?? '';
  String get userMajor => _prefs.getString('user_major') ?? '';
  String get userSemester => _prefs.getString('user_semester') ?? '';
  bool get isPinEnabled => _prefs.getBool('is_pin_enabled') ?? false;
  String get appPin => _prefs.getString('app_pin') ?? '';
  bool get isProfileSetupDone => _prefs.getBool('is_profile_setup_done') ?? false;
  String get securityQuestion => _prefs.getString('security_question') ?? '';
  String get securityAnswer => _prefs.getString('security_answer') ?? '';
  List<String> get pinHistory => _prefs.getStringList('pin_history') ?? [];
  String? get profileImagePath => _prefs.getString('profile_image_path');

  Future<void> setProfileImagePath(String? path) async {
    if (path == null || path.isEmpty) {
      await _prefs.remove('profile_image_path');
    } else {
      await _prefs.setString('profile_image_path', path);
    }
  }

  Future<void> setProfile({
    required String name,
    required String nim,
    required String email,
    required String major,
    required String semester,
  }) async {
    await _prefs.setString('user_name', name);
    await _prefs.setString('user_nim', nim);
    await _prefs.setString('user_email', email);
    await _prefs.setString('user_major', major);
    await _prefs.setString('user_semester', semester);
  }

  Future<void> setProfileSetupDone(bool done) async {
    await _prefs.setBool('is_profile_setup_done', done);
  }

  Future<void> setSecurityInfo(String question, String answer) async {
    await _prefs.setString('security_question', question);
    await _prefs.setString('security_answer', answer.trim().toLowerCase());
  }

  Future<void> setPinEnabled(bool enabled) async {
    await _prefs.setBool('is_pin_enabled', enabled);
  }

  Future<void> setAppPin(String newPin) async {
    final currentPin = _prefs.getString('app_pin') ?? '';
    final history = List<String>.from(pinHistory);
    if (currentPin.isNotEmpty && !history.contains(currentPin)) {
      history.add(currentPin);
      await _prefs.setStringList('pin_history', history);
    }
    await _prefs.setString('app_pin', newPin);
  }

  /// Hanya cek apakah PIN baru sama dengan PIN yang sedang aktif.
  /// PIN lama yang sudah tidak dipakai boleh digunakan kembali.
  bool isPinSameAsCurrent(String candidate) {
    return candidate == appPin;
  }

  /// Deprecated alias — tidak dipakai lagi, gunakan isPinSameAsCurrent
  bool isPinInHistory(String candidate) => isPinSameAsCurrent(candidate);
}

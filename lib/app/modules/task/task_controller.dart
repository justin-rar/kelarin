import 'package:get/get.dart';
import '../../data/models/task_model.dart';
import '../../data/services/notification_service.dart';
import '../../data/services/storage_service.dart';
import '../../global_widgets/undo_toast.dart';

class TaskController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  NotificationService get _notifications => Get.find<NotificationService>();

  final RxList<TaskModel> allTasks = <TaskModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'Semua'.obs;
  final RxString selectedTimeFilter = 'Minggu Ini'.obs;
  final RxString completedSearchQuery = ''.obs;
  final RxString completedCategory = 'Semua'.obs;

  // Filter Bulan & Tahun untuk halaman Rekap
  late final RxInt completedFilterMonth;
  late final RxInt completedFilterYear;

  // Undo deletion memory
  TaskModel? _lastDeletedTask;

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    completedFilterMonth = now.month.obs;
    final defaultYear = (now.year >= 2026 && now.year <= 2045) ? now.year : 2026;
    completedFilterYear = defaultYear.obs;
    loadTasks();
  }

  void loadTasks() {
    final box = _storage.taskBox;
    allTasks.assignAll(box.values.toList());
  }

  // Active / Incomplete Tasks
  List<TaskModel> get activeTasks {
    return allTasks.where((t) => !t.isCompleted).where((t) {
      // Category filter
      if (selectedCategory.value != 'Semua') {
        if (selectedCategory.value == 'Hari Ini') {
          final now = DateTime.now();
          final isToday = t.dateTime.year == now.year &&
              t.dateTime.month == now.month &&
              t.dateTime.day == now.day;
          if (!isToday) return false;
        } else if (t.category.toLowerCase() != selectedCategory.value.toLowerCase()) {
          return false;
        }
      }

      // Search filter
      if (searchQuery.value.trim().isNotEmpty) {
        final query = searchQuery.value.trim().toLowerCase();
        final matchTitle = t.title.toLowerCase().contains(query);
        final matchLocation = t.location.toLowerCase().contains(query);
        final matchCategory = t.category.toLowerCase().contains(query);
        final matchNote = (t.note ?? '').toLowerCase().contains(query);
        if (!matchTitle && !matchLocation && !matchCategory && !matchNote) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // Section 1: Prioritas Utama (! Tinggi)
  List<TaskModel> get highPriorityActiveTasks {
    return activeTasks.where((t) => t.priority == '! Tinggi').toList();
  }

  // Section 2: Akan Datang (= Sedang & — Rendah)
  List<TaskModel> get upcomingActiveTasks {
    return activeTasks.where((t) => t.priority != '! Tinggi').toList();
  }

  // Completed Tasks (for Tab 2: Selesai Rekap)
  List<TaskModel> get completedTasks {
    final list = allTasks.where((t) => t.isCompleted).toList();
    list.sort((a, b) => (b.completedAt ?? b.dateTime).compareTo(a.completedAt ?? a.dateTime));
    return list;
  }

  // Filtered Completed Tasks by bulan & tahun + search
  List<TaskModel> get filteredCompletedTasks {
    return completedTasks.where((t) {
      // Filter bulan & tahun
      final date = t.completedAt ?? t.dateTime;
      if (date.year != completedFilterYear.value) {
        return false;
      }
      if (completedFilterMonth.value != 0 &&
          date.month != completedFilterMonth.value) {
        return false;
      }

      // Search query
      if (completedSearchQuery.value.trim().isNotEmpty) {
        final q = completedSearchQuery.value.trim().toLowerCase();
        final matchTitle = t.title.toLowerCase().contains(q);
        final matchLocation = t.location.toLowerCase().contains(q);
        final matchCategory = t.category.toLowerCase().contains(q);
        final matchNote = (t.note ?? '').toLowerCase().contains(q);
        if (!matchTitle && !matchLocation && !matchCategory && !matchNote) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  List<TaskModel> get todayCompletedTasks {
    final now = DateTime.now();
    return filteredCompletedTasks.where((t) {
      final date = t.completedAt ?? t.dateTime;
      return date.year == now.year && date.month == now.month && date.day == now.day;
    }).toList();
  }

  List<TaskModel> get earlierCompletedTasks {
    final now = DateTime.now();
    return filteredCompletedTasks.where((t) {
      final date = t.completedAt ?? t.dateTime;
      return !(date.year == now.year && date.month == now.month && date.day == now.day);
    }).toList();
  }

  int get todayCompletedCount {
    final now = DateTime.now();
    return completedTasks.where((t) {
      final date = t.completedAt ?? t.dateTime;
      return date.year == now.year && date.month == now.month && date.day == now.day;
    }).length;
  }

  int get monthCompletedCount {
    final now = DateTime.now();
    return completedTasks.where((t) {
      final date = t.completedAt ?? t.dateTime;
      return date.year == now.year && date.month == now.month;
    }).length;
  }

  int get onTimeRate {
    if (completedTasks.isEmpty) return 92;
    final onTimeCount = completedTasks.where((t) {
      if (t.completedAt == null) return true;
      return !t.completedAt!.isAfter(t.dateTime.add(const Duration(hours: 1)));
    }).length;
    final rate = ((onTimeCount / completedTasks.length) * 100).round();
    return rate > 0 ? rate : 92;
  }

  // Dashboard Metrics
  int get todayCount {
    final now = DateTime.now();
    return allTasks.where((t) => !t.isCompleted &&
        t.dateTime.year == now.year &&
        t.dateTime.month == now.month &&
        t.dateTime.day == now.day).length;
  }

  int get scheduledCount {
    final now = DateTime.now();
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return allTasks.where((t) => !t.isCompleted && t.dateTime.isAfter(todayEnd)).length;
  }

  int get priorityCount {
    return allTasks.where((t) => !t.isCompleted && t.priority == '! Tinggi').length;
  }

  int get allCount {
    return allTasks.where((t) => !t.isCompleted).length;
  }

  int get totalCount {
    return allTasks.length;
  }

  int get completedCount {
    return completedTasks.length;
  }

  // Filter category counts
  int getCategoryCount(String category) {
    if (category == 'Semua') {
      return allCount;
    }
    if (category == 'Hari Ini') {
      return todayCount;
    }
    return allTasks.where((t) => !t.isCompleted && t.category.toLowerCase() == category.toLowerCase()).length;
  }

  int _taskNotifId(String taskId) {
    return (taskId.hashCode & 0x7FFFFFFF) % 10000000;
  }

  // CRUD Operations
  Future<void> addTask(
    TaskModel task, {
    bool remind1Day = false,
    bool remind12Hours = false,
    bool remind6Hours = false,
    bool remind3Hours = false,
    bool remind1Hour = false,
  }) async {
    await _storage.taskBox.put(task.id, task);
    loadTasks();

    final now = DateTime.now();
    final baseId = _taskNotifId(task.id);

    // 1. Notifikasi tenggat tugas
    if (task.dateTime.isAfter(now)) {
      try {
        await _notifications.scheduleNotification(
          id: baseId,
          title: 'Tenggat Tugas: ${task.title}',
          body: 'Tugas "${task.title}" (${task.category}) sudah jatuh tempo.',
          scheduledDate: task.dateTime,
        );
      } catch (_) {}
    }

    // 2. Pengingat bertingkat sebelum deadline
    if (remind1Hour) {
      final t = task.dateTime.subtract(const Duration(hours: 1));
      if (t.isAfter(now)) {
        try {
          await _notifications.scheduleNotification(
            id: baseId + 1,
            title: 'Pengingat Tugas: 1 Jam Lagi',
            body: 'Tugas "${task.title}" akan jatuh tempo dalam 1 jam.',
            scheduledDate: t,
          );
        } catch (_) {}
      }
    }

    if (remind3Hours) {
      final t = task.dateTime.subtract(const Duration(hours: 3));
      if (t.isAfter(now)) {
        try {
          await _notifications.scheduleNotification(
            id: baseId + 2,
            title: 'Pengingat Tugas: 3 Jam Lagi',
            body: 'Tugas "${task.title}" akan jatuh tempo dalam 3 jam.',
            scheduledDate: t,
          );
        } catch (_) {}
      }
    }

    if (remind6Hours) {
      final t = task.dateTime.subtract(const Duration(hours: 6));
      if (t.isAfter(now)) {
        try {
          await _notifications.scheduleNotification(
            id: baseId + 3,
            title: 'Pengingat Tugas: 6 Jam Lagi',
            body: 'Tugas "${task.title}" akan jatuh tempo dalam 6 jam.',
            scheduledDate: t,
          );
        } catch (_) {}
      }
    }

    if (remind12Hours) {
      final t = task.dateTime.subtract(const Duration(hours: 12));
      if (t.isAfter(now)) {
        try {
          await _notifications.scheduleNotification(
            id: baseId + 4,
            title: 'Pengingat Tugas: 12 Jam Lagi',
            body: 'Tugas "${task.title}" akan jatuh tempo dalam 12 jam.',
            scheduledDate: t,
          );
        } catch (_) {}
      }
    }

    if (remind1Day) {
      final t = task.dateTime.subtract(const Duration(days: 1));
      if (t.isAfter(now)) {
        try {
          await _notifications.scheduleNotification(
            id: baseId + 5,
            title: 'Pengingat Tugas: 1 Hari Lagi',
            body: 'Tugas "${task.title}" akan jatuh tempo besok.',
            scheduledDate: t,
          );
        } catch (_) {}
      }
    }

    UndoToast.show(message: 'Tugas berhasil ditambahkan');
  }

  Future<void> updateTask(
    TaskModel task, {
    bool remind1Day = false,
    bool remind12Hours = false,
    bool remind6Hours = false,
    bool remind3Hours = false,
    bool remind1Hour = false,
  }) async {
    await _storage.taskBox.put(task.id, task);
    loadTasks();

    final baseId = _taskNotifId(task.id);
    for (int i = 0; i <= 5; i++) {
      try {
        await _notifications.cancelNotification(baseId + i);
      } catch (_) {}
    }

    final now = DateTime.now();
    if (!task.isCompleted) {
      if (task.dateTime.isAfter(now)) {
        try {
          await _notifications.scheduleNotification(
            id: baseId,
            title: 'Tenggat Tugas: ${task.title}',
            body: 'Tugas "${task.title}" (${task.category}) sudah jatuh tempo.',
            scheduledDate: task.dateTime,
          );
        } catch (_) {}
      }

      if (remind1Hour) {
        final t = task.dateTime.subtract(const Duration(hours: 1));
        if (t.isAfter(now)) {
          try {
            await _notifications.scheduleNotification(
              id: baseId + 1,
              title: 'Pengingat Tugas: 1 Jam Lagi',
              body: 'Tugas "${task.title}" akan jatuh tempo dalam 1 jam.',
              scheduledDate: t,
            );
          } catch (_) {}
        }
      }

      if (remind3Hours) {
        final t = task.dateTime.subtract(const Duration(hours: 3));
        if (t.isAfter(now)) {
          try {
            await _notifications.scheduleNotification(
              id: baseId + 2,
              title: 'Pengingat Tugas: 3 Jam Lagi',
              body: 'Tugas "${task.title}" akan jatuh tempo dalam 3 jam.',
              scheduledDate: t,
            );
          } catch (_) {}
        }
      }

      if (remind6Hours) {
        final t = task.dateTime.subtract(const Duration(hours: 6));
        if (t.isAfter(now)) {
          try {
            await _notifications.scheduleNotification(
              id: baseId + 3,
              title: 'Pengingat Tugas: 6 Jam Lagi',
              body: 'Tugas "${task.title}" akan jatuh tempo dalam 6 jam.',
              scheduledDate: t,
            );
          } catch (_) {}
        }
      }

      if (remind12Hours) {
        final t = task.dateTime.subtract(const Duration(hours: 12));
        if (t.isAfter(now)) {
          try {
            await _notifications.scheduleNotification(
              id: baseId + 4,
              title: 'Pengingat Tugas: 12 Jam Lagi',
              body: 'Tugas "${task.title}" akan jatuh tempo dalam 12 jam.',
              scheduledDate: t,
            );
          } catch (_) {}
        }
      }

      if (remind1Day) {
        final t = task.dateTime.subtract(const Duration(days: 1));
        if (t.isAfter(now)) {
          try {
            await _notifications.scheduleNotification(
              id: baseId + 5,
              title: 'Pengingat Tugas: 1 Hari Lagi',
              body: 'Tugas "${task.title}" akan jatuh tempo besok.',
              scheduledDate: t,
            );
          } catch (_) {}
        }
      }
    }

    UndoToast.show(message: 'Perubahan tugas disimpan');
  }

  Future<void> toggleTaskComplete(String taskId) async {
    final index = allTasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = allTasks[index];
      final newStatus = !task.isCompleted;
      final updated = task.copyWith(
        isCompleted: newStatus,
        completedAt: newStatus ? DateTime.now() : null,
      );
      await _storage.taskBox.put(taskId, updated);
      loadTasks();

      if (newStatus) {
        final baseId = _taskNotifId(taskId);
        for (int i = 0; i <= 5; i++) {
          try {
            await _notifications.cancelNotification(baseId + i);
          } catch (_) {}
        }

        UndoToast.show(
          message: 'Tugas ditandai selesai',
          actionLabel: 'Urungkan',
          onUndo: () => toggleTaskComplete(taskId),
        );
      }
    }
  }

  Future<void> deleteTask(String taskId) async {
    final index = allTasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _lastDeletedTask = allTasks[index];
      final baseId = _taskNotifId(taskId);
      for (int i = 0; i <= 5; i++) {
        try {
          await _notifications.cancelNotification(baseId + i);
        } catch (_) {}
      }
      await _storage.taskBox.delete(taskId);
      loadTasks();

      UndoToast.show(
        message: 'Tugas berhasil dihapus',
        actionLabel: 'Urungkan',
        onUndo: undoDelete,
      );
    }
  }

  Future<void> undoDelete() async {
    if (_lastDeletedTask != null) {
      await _storage.taskBox.put(_lastDeletedTask!.id, _lastDeletedTask!);
      _lastDeletedTask = null;
      loadTasks();
    }
  }

  Future<void> clearCompletedTasks() async {
    final completed = allTasks.where((t) => t.isCompleted).toList();
    for (final t in completed) {
      await _storage.taskBox.delete(t.id);
    }
    loadTasks();
    UndoToast.show(message: 'Riwayat tugas selesai dibersihkan');
  }
}


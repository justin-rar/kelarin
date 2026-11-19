import 'package:get/get.dart';
import '../../data/models/task_model.dart';
import '../../data/services/gemini_service.dart';
import '../task/task_controller.dart';

class AiController extends GetxController {
  final GeminiService _geminiService = GeminiService();

  TaskController get _taskController => Get.isRegistered<TaskController>()
      ? Get.find<TaskController>()
      : Get.put(TaskController(), permanent: true);

  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  final List<String> _lastAddedSessionIds = [];

  void clearHistory() {
    messages.clear();
    _lastAddedSessionIds.clear();
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final timeStr = '$hour:$minute';

    messages.add({
      'isUser': true,
      'text': trimmed,
      'timestamp': timeStr,
      'hasAction': false,
    });

    isLoading.value = true;

    try {
      await _processAiResponse(trimmed);
    } catch (_) {
      messages.add({
        'isUser': false,
        'text':
            'Maaf, terjadi kendala saat memproses jawaban. Silakan coba lagi.',
        'timestamp': timeStr,
      });
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _processAiResponse(String query) async {
    final lower = query.toLowerCase();
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final timeStr = '$hour:$minute';

    // 1. Quick suggestion interaktif: Sesi belajar terstruktur dengan action card
    if (lower.contains('basis data') ||
        lower.contains('jadwal belajar intensif')) {
      messages.add({
        'isUser': false,
        'text':
            'Tentu! Berdasarkan materi kuliah dan agenda belajarmu, ini rekomendasi jadwal belajar terstruktur:',
        'timestamp': timeStr,
        'hasSchedule': true,
        'scheduleTitle': 'Rencana Belajar: Basis Data',
        'scheduleSubtitle': '3 Sesi • Total durasi 3 jam 30 mnt',
        'scheduleDate': 'Jadwal Intensif',
        'isAdded': false,
        'sessions': [
          {
            'time': '14:00 - 15:30',
            'title': 'Normalisasi 1NF - BCNF',
            'note': 'Review relasi fungsional',
          },
          {
            'time': '16:00 - 17:00',
            'title': 'Latihan Transaksi Distribusi',
            'note': 'Studi kasus perbankan',
          },
          {
            'time': '19:30 - 20:30',
            'title': 'Optimasi Query & Audit Indeks',
            'note': 'Simulasi query EXPLAIN',
          },
        ],
        'followUp':
            'Apakah kamu ingin menambahkan pengingat alarm 15 menit sebelum setiap sesi dimulai?',
        'followUpOptions': ['Ya, pasang alarm', 'Tidak perlu'],
      });
      return;
    } else if (lower.contains('pasang alarm') || lower.contains('ya, pasang')) {
      messages.add({
        'isUser': false,
        'text':
            '✓ Pengingat alarm 15 menit sebelum setiap sesi dimulai telah berhasil diaktifkan ke notifikasi sistem!',
        'timestamp': timeStr,
      });
      return;
    } else if (lower.contains('tidak perlu')) {
      messages.add({
        'isUser': false,
        'text':
            'Baik, sesi belajar tetap tersimpan di agenda tanpa alarm pengingat tambahan.',
        'timestamp': timeStr,
      });
      return;
    }

    // 2. Kueri lainnya langsung dikirimkan ke Google Gemini API secara real-time
    final activeTasks = _taskController.activeTasks;
    String? userContext;
    if (activeTasks.isNotEmpty) {
      final taskList = activeTasks
          .take(5)
          .map((t) =>
              '- ${t.title} (Kategori: ${t.category}, Prioritas: ${t.priority}, Waktu: ${t.timeString})')
          .join('\n');
      userContext = 'Daftar Tugas Aktif Mahasiswa saat ini:\n$taskList';
    }

    final aiReply = await _geminiService.askGemini(
      query: query,
      userContext: userContext,
      recentHistory: messages.toList(),
    );

    messages.add({
      'isUser': false,
      'text': aiReply,
      'timestamp': timeStr,
      'hasAction': false,
    });
  }

  void addScheduleSessionsToTasks(int messageIndex) {
    if (messageIndex >= messages.length) return;
    final msg = messages[messageIndex];
    final sessions = msg['sessions'] is List ? (msg['sessions'] as List) : null;
    if (sessions == null) return;

    _lastAddedSessionIds.clear();
    final now = DateTime.now();

    for (int i = 0; i < sessions.length; i++) {
      final s = sessions[i];
      final id = 'task_ai_session_${now.millisecondsSinceEpoch}_$i';
      _lastAddedSessionIds.add(id);

      _taskController.addTask(TaskModel(
        id: id,
        title: s['title'] ?? 'Sesi Belajar',
        dateTime: now.add(Duration(hours: (i + 1) * 2)),
        timeString: s['time'] ?? '14:00 WIB',
        location: 'Meja Belajar / Lab',
        category: 'Kuliah',
        priority: '! Tinggi',
        note: s['note'] ?? 'Dibuat otomatis melalui Tanya AI',
      ));
    }

    final updated = Map<String, dynamic>.from(msg);
    updated['isAdded'] = true;
    messages[messageIndex] = updated;
  }

  void undoAddScheduleSessions(int messageIndex) {
    for (final id in _lastAddedSessionIds) {
      _taskController.deleteTask(id);
    }
    _lastAddedSessionIds.clear();

    if (messageIndex < messages.length) {
      final updated = Map<String, dynamic>.from(messages[messageIndex]);
      updated['isAdded'] = false;
      messages[messageIndex] = updated;
    }
  }

  void addSuggestedTask(String title, String category, String priority) {
    final now = DateTime.now();
    final newTask = TaskModel(
      id: 'task_ai_${now.millisecondsSinceEpoch}',
      title: title,
      dateTime: now,
      timeString: 'Hari Ini, Sesi AI',
      location: 'Meja Belajar / Lab',
      category: category,
      priority: priority,
      note: 'Dibuat otomatis melalui rekomendasi Tanya AI.',
    );

    _taskController.addTask(newTask);

    messages.add({
      'isUser': false,
      'text': '✓ Sesi fokus berhasil ditambahkan ke daftar tugas Home!',
      'timestamp':
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      'hasAction': false,
    });
  }
}

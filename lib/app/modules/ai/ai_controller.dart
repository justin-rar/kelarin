import 'package:get/get.dart';
import '../../data/models/task_model.dart';
import '../task/task_controller.dart';

class AiController extends GetxController {
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

  void sendMessage(String text) {
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

    Future.delayed(const Duration(milliseconds: 600), () {
      _processAiResponse(trimmed);
      isLoading.value = false;
    });
  }

  void _processAiResponse(String query) {
    final lower = query.toLowerCase();
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final timeStr = '$hour:$minute';

    if (lower.contains('basis data') ||
        lower.contains('rencana belajar') ||
        lower.contains('jadwal belajar intensif')) {
      messages.add({
        'isUser': false,
        'text':
            'Tentu Titut! Berdasarkan materi normalisasi & indeks pada catatanmu, ini rekomendasi jadwal belajar terstruktur:',
        'timestamp': timeStr,
        'hasSchedule': true,
        'scheduleTitle': 'Rencana Belajar: Basis Data',
        'scheduleSubtitle': '3 Sesi • Total durasi 3 jam 30 mnt',
        'scheduleDate': 'Kamis, 26 Okt',
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
    } else if (lower.contains('pasang alarm') || lower.contains('ya, pasang')) {
      messages.add({
        'isUser': false,
        'text':
            '✓ Pengingat alarm 15 menit sebelum setiap sesi dimulai telah berhasil diaktifkan ke notifikasi sistem!',
        'timestamp': timeStr,
      });
    } else if (lower.contains('tidak perlu')) {
      messages.add({
        'isUser': false,
        'text':
            'Baik Titut, sesi belajar tetap tersimpan di agenda tanpa alarm pengingat tambahan.',
        'timestamp': timeStr,
      });
    } else if (lower.contains('kuliah & tugas') ||
        lower.contains('jadwal') ||
        lower.contains('hari ini')) {
      final active = _taskController.activeTasks;
      if (active.isEmpty) {
        messages.add({
          'isUser': false,
          'text':
              'Hebat! Saat ini tidak ada tugas aktif yang menumpuk hari ini. Kamu bisa memanfaatkan waktu luang untuk membaca materi kuliah atau beristirahat.',
          'timestamp': timeStr,
        });
      } else {
        final listStr = active
            .take(3)
            .map((t) => '• ${t.title} (${t.timeString}) [${t.priority}]')
            .join('\n');
        messages.add({
          'isUser': false,
          'text':
              'Berikut agenda tugas aktifmu untuk hari ini:\n\n$listStr\n\nPastikan untuk menyelesaikan prioritas utama tepat waktu!',
          'timestamp': timeStr,
        });
      }
    } else if (lower.contains('rangkum') || lower.contains('catatan')) {
      messages.add({
        'isUser': false,
        'text':
            'Berikut rangkuman inti catatan kuliah terakhirmu mengenai Arsitektur Mobile & GetX State Management:\n\n'
            '1. Pemisahan Layer: GetX memisahkan UI (View), Business Logic (Controller), dan Dependency Injection (Binding).\n'
            '2. Reaktivitas: Menggunakan tipe .obs dan widget Obx() untuk render ulang presisi tanpa setState.\n'
            '3. Persistensi: Integrasi Hive Box & SharedPreferences menyimpan data aman secara offline.\n'
            '4. Navigation: Navigasi deklaratif Get.toNamed() mempermudah routing antar-halaman.',
        'timestamp': timeStr,
      });
    } else if (lower.contains('prioritas') || lower.contains('menumpuk')) {
      final highPriority = _taskController.highPriorityActiveTasks;
      if (highPriority.isNotEmpty) {
        final taskNames =
            highPriority.map((t) => '• ${t.title} (${t.timeString})').join('\n');
        messages.add({
          'isUser': false,
          'text':
              'Tugas prioritas utama yang harus kamu selesaikan terlebih dahulu:\n\n$taskNames\n\n'
              'Fokus selesaikan tugas-tugas di atas sebelum tenggat waktu mendekat!',
          'timestamp': timeStr,
        });
      } else {
        messages.add({
          'isUser': false,
          'text':
              'Saat ini semua tugas prioritas tinggi telah terselesaikan. Kamu berada di jalur yang sangat aman!',
          'timestamp': timeStr,
        });
      }
    } else {
      messages.add({
        'isUser': false,
        'text':
            'Saya siap membantu! Kamu bisa meminta saya menyusun jadwal belajar intensif, merangkum materi catatan kuliah, atau menyaring prioritas tugas harian.',
        'timestamp': timeStr,
      });
    }
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

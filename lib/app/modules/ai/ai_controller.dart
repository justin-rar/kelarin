import 'package:get/get.dart';
import '../../data/models/task_model.dart';
import '../task/task_controller.dart';

class AiController extends GetxController {
  final TaskController _taskController = Get.find<TaskController>();

  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Default initial greeting if empty
    if (messages.isEmpty) {
      messages.add({
        'isUser': false,
        'text':
            'Halo Titut! Saya asisten studi cerdas TaskFlow. Ada yang bisa saya bantu untuk mengorganisir jadwal kuliah, tugas, atau persiapan ujianmu hari ini?',
        'hasAction': false,
      });
    }
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    messages.add({
      'isUser': true,
      'text': text,
      'hasAction': false,
    });

    isLoading.value = true;

    Future.delayed(const Duration(milliseconds: 600), () {
      _processAiResponse(text);
      isLoading.value = false;
    });
  }

  void _processAiResponse(String query) {
    final lower = query.toLowerCase();

    if (lower.contains('jadwal') || lower.contains('belajar') || lower.contains('plan')) {
      final active = _taskController.activeTasks;
      if (active.isEmpty) {
        messages.add({
          'isUser': false,
          'text':
              'Hebat! Saat ini tidak ada tugas aktif yang menumpuk. Kamu bisa memanfaatkan waktu untuk membaca materi kuliah berikutnya atau beristirahat.',
          'hasAction': false,
        });
      } else {
        final topTask = active.first;
        messages.add({
          'isUser': false,
          'text':
              'Berdasarkan daftar tugasmu, berikut rekomendasi sesi belajar efektif hari ini:\n\n'
              '• 09:00 - 10:30 WIB: Sesi Fokus "${topTask.title}" (Gunakan teknik Pomodoro 25m fokus, 5m istirahat).\n'
              '• 13:30 - 15:00 WIB: Review materi & latihan praktikum.\n\n'
              'Mau saya tambahkan sesi fokus belajar ini langsung ke daftar tugasmu?',
          'hasAction': true,
          'actionTitle': 'Sesi Fokus Belajar Mandiri',
          'actionCategory': 'Kuliah',
          'actionPriority': '! Tinggi',
        });
      }
    } else if (lower.contains('prioritas') || lower.contains('tenggat') || lower.contains('deadline')) {
      final highPriority = _taskController.highPriorityActiveTasks;
      if (highPriority.isNotEmpty) {
        final taskNames = highPriority.map((t) => '• ${t.title} (${t.timeString})').join('\n');
        messages.add({
          'isUser': false,
          'text':
              'Tugas prioritas utama yang harus diselesaikan terlebih dahulu:\n\n$taskNames\n\n'
              'Fokus selesaikan tugas ini sebelum beralih ke aktivitas lain agar tidak menumpuk mendekati tenggat!',
          'hasAction': false,
        });
      } else {
        messages.add({
          'isUser': false,
          'text':
              'Saat ini tidak ada tugas berstatus "! Tinggi". Kamu berada di jalur yang aman!',
          'hasAction': false,
        });
      }
    } else if (lower.contains('responsi') || lower.contains('pam') || lower.contains('ujian')) {
      messages.add({
        'isUser': false,
        'text':
            'Tips Sukses Praktikum Pemrograman Mobile (PAM):\n\n'
            '1. Kuasai arsitektur GetX (Controller, Rx, Obx, Binding).\n'
            '2. Pahami penyimpanan lokal Hive Box & SharedPreferences.\n'
            '3. Pastikan exception handling dan validasi form selalu diterapkan.\n'
            '4. Jaga kode tetap modular dan pisahkan widget agar mudah di-debug.',
        'hasAction': false,
      });
    } else {
      messages.add({
        'isUser': false,
        'text':
            'Saya siap membantu! Kamu bisa meminta saya membuatkan jadwal belajar harian, menyaring prioritas tugas, atau memberikan checklist persiapan responsi.',
        'hasAction': false,
      });
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
      'hasAction': false,
    });
  }
}


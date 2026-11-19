import '../models/task_model.dart';
import '../models/attendance_model.dart';
import '../models/note_model.dart';
import '../models/notification_item_model.dart';

class DummyDataService {
  DummyDataService._();

  static List<TaskModel> get initialTasks {
    final now = DateTime.now();
    return [
      TaskModel(
        id: 'task-1',
        title: 'Review proposal desain UI',
        dateTime: now,
        timeString: '10:00 WIB',
        location: 'Lab Komputer 3',
        category: 'Kuliah',
        priority: '! Tinggi',
        isCompleted: false,
        note: 'Pastikan warna monokrom dan font Plus Jakarta Sans sudah sesuai brief.',
      ),
      TaskModel(
        id: 'task-2',
        title: 'Meeting evaluasi sprint',
        dateTime: now,
        timeString: 'Hari Ini, 14:00',
        location: 'Ruang Rapat Tim Dev 4',
        category: 'Pekerjaan',
        priority: '= Sedang',
        isCompleted: false,
        note: 'Bahas backlog fitur Tanya AI dan integrasi GetX.',
      ),
      TaskModel(
        id: 'task-3',
        title: 'Beli bahan makanan & vitamin',
        dateTime: now.add(const Duration(days: 1)),
        timeString: 'Besok, 08:00',
        location: 'Supermarket Indah',
        category: 'Pribadi',
        priority: '— Rendah',
        isCompleted: false,
      ),
      TaskModel(
        id: 'task-4',
        title: 'Olahraga kardio 30 menit',
        dateTime: now.add(const Duration(days: 2)),
        timeString: 'Jumat, 16:30',
        location: 'Gym Kampus',
        category: 'Lainnya',
        priority: '= Sedang',
        isCompleted: false,
      ),
      TaskModel(
        id: 'task-5',
        title: 'Analisis kebutuhan sistem PAM',
        dateTime: now.subtract(const Duration(days: 1)),
        timeString: 'Kemarin, 15:00 WIB',
        location: 'Lab Komputer 2',
        category: 'Kuliah',
        priority: '! Tinggi',
        isCompleted: true,
        completedAt: now.subtract(const Duration(days: 1)),
        note: 'Dokumen functional requirement sudah rampung.',
      ),
      TaskModel(
        id: 'task-6',
        title: 'Setup repositori GitHub Kelarin',
        dateTime: now.subtract(const Duration(days: 2)),
        timeString: '2 hari lalu',
        location: 'Online',
        category: 'Kuliah',
        priority: '= Sedang',
        isCompleted: true,
        completedAt: now.subtract(const Duration(days: 2)),
      ),
    ];
  }

  static List<AttendanceModel> get initialAttendances {
    return [
      AttendanceModel(
        id: 'att-1',
        subjectName: 'Praktikum Pemrograman Mobile',
        type: 'Praktikum',
        day: 'Kamis',
        time: '08:00 - 10:00 WIB',
        room: 'Lab Komputer 3',
        reminderActive: true,
        attendedMeetings: 10,
        totalMeetings: 14,
      ),
      AttendanceModel(
        id: 'att-2',
        subjectName: 'Rekayasa Perangkat Lunak',
        type: 'Teori',
        day: 'Selasa',
        time: '10:30 - 12:30 WIB',
        room: 'Ruang Teori 3.2',
        reminderActive: true,
        attendedMeetings: 11,
        totalMeetings: 14,
      ),
      AttendanceModel(
        id: 'att-3',
        subjectName: 'Kecerdasan Buatan',
        type: 'Teori',
        day: 'Rabu',
        time: '13:00 - 15:00 WIB',
        room: 'Ruang Teori 2.1',
        reminderActive: false,
        attendedMeetings: 12,
        totalMeetings: 14,
      ),
    ];
  }

  static List<NoteModel> get initialNotes {
    final now = DateTime.now();
    return [
      NoteModel(
        id: 'note-1',
        title: 'Sprint Planning 4: Arsitektur GetX & Hive',
        content: '''## Catatan Arsitektur
- Gunakan GetMaterialApp pada main.dart
- Pisahkan Controller dengan GetxController
- Penyimpanan lokal data menggunakan Hive Box
- Sesi dan PIN disimpan pada SharedPreferences
- UI mengacu pada standar Google Stitch monokrom''',
        updatedAt: now.subtract(const Duration(hours: 3)),
        category: 'Proyek',
        isPinned: true,
      ),
      NoteModel(
        id: 'note-2',
        title: 'Poin Penting Latihan Responsi PAM',
        content: '''## Checklist Responsi:
1. Pastikan model data lengkap
2. Exception handling pada koneksi/data
3. Filter chip realtime aktif
4. Fitur pencarian tanpa lag
5. Notifikasi lokal aktif untuk reminder''',
        updatedAt: now.subtract(const Duration(days: 1)),
        category: 'Kuliah',
        isPinned: true,
      ),
      NoteModel(
        id: 'note-3',
        title: 'Daftar Referensi Desain Monokromatis',
        content: '''- Primary: #0A0A0A (Ink)
- Background: #F6F6F7
- Surface Card: #FFFFFF (Soft Shadow)
- Radius card: 24px
- Font: Plus Jakarta Sans''',
        updatedAt: now.subtract(const Duration(days: 2)),
        category: 'Kuliah',
        isPinned: false,
      ),
    ];
  }

  static List<NotificationItemModel> get initialNotifications {
    final now = DateTime.now();
    return [
      NotificationItemModel(
        id: 'notif-1',
        title: 'Pengingat Tugas Prioritas',
        message: 'Tugas "Review proposal desain UI" memiliki tenggat hari ini pukul 10:00 WIB!',
        timestamp: now.subtract(const Duration(minutes: 45)),
        isRead: false,
        type: 'TUGAS',
      ),
      NotificationItemModel(
        id: 'notif-2',
        title: 'Jadwal Presensi Kelas',
        message: 'Besok ada jadwal Praktikum Pemrograman Mobile pukul 08:00 WIB di Lab 3.',
        timestamp: now.subtract(const Duration(hours: 4)),
        isRead: false,
        type: 'PRESENSI',
      ),
      NotificationItemModel(
        id: 'notif-3',
        title: 'Kelarin Siap Digunakan',
        message: 'Selamat datang di Kelarin! Sinkronisasi modul GetX dan Hive berhasil.',
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
        type: 'SISTEM',
      ),
    ];
  }
}


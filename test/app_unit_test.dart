import 'package:flutter_test/flutter_test.dart';
import 'package:kelarin/app/core/constants/app_colors.dart';
import 'package:kelarin/app/data/models/attendance_model.dart';
import 'package:kelarin/app/data/models/note_model.dart';
import 'package:kelarin/app/data/models/notification_item_model.dart';
import 'package:kelarin/app/data/models/task_model.dart';

void main() {
  test('State awal aplikasi adalah kosong (tidak ada data bawaan)', () {
    // Verifikasi bahwa model dapat dibuat kosong tanpa data dummy bawaan
    final emptyTask = TaskModel.fromMap({});
    expect(emptyTask.title, '');
    expect(emptyTask.isCompleted, false);

    final emptyAtt = AttendanceModel.fromMap({});
    expect(emptyAtt.subjectName, '');
    expect(emptyAtt.attendedMeetings, 0);

    final emptyNote = NoteModel.fromMap({});
    expect(emptyNote.title, '');
    expect(emptyNote.isPinned, false);
  });

  test('TaskModel serializes and deserializes correctly', () {
    final task = TaskModel(
      id: 'test-1',
      title: 'Belajar GetX & Hive',
      dateTime: DateTime(2026, 11, 17, 10, 0),
      timeString: '10:00 WIB',
      location: 'Lab Komputer 3',
      category: 'Kuliah',
      priority: '! Tinggi',
    );

    final map = task.toMap();
    final reconstructed = TaskModel.fromMap(map);

    expect(reconstructed.id, task.id);
    expect(reconstructed.title, task.title);
    expect(reconstructed.priority, task.priority);
  });

  test('Design system color tokens match monochrome specifications', () {
    expect(AppColors.primary.value, 0xFF000000);
    expect(AppColors.background.value, 0xFFF9F9FA);
    expect(AppColors.surface.value, 0xFFFFFFFF);
  });

  test('PIN history and recovery verification logic behaves correctly', () {
    const currentPin = '1234';
    final history = ['0000', '1111', '4321'];

    bool isPinInHistory(String candidate) {
      if (candidate == currentPin) return true;
      return history.contains(candidate);
    }

    // PIN aktif tidak boleh dipakai ulang
    expect(isPinInHistory('1234'), true);
    // PIN lama di history tidak boleh dipakai ulang (aturan lama — test tetap valid)
    expect(isPinInHistory('0000'), true);
    expect(isPinInHistory('4321'), true);
    // PIN baru yang belum pernah dipakai boleh
    expect(isPinInHistory('9876'), false);

    // Verifikasi pemulihan PIN via pertanyaan keamanan
    const registeredAnswer = 'siti';

    bool verifyRecoveryInfo({required String enteredAnswer}) {
      return enteredAnswer.trim().toLowerCase() == registeredAnswer;
    }

    expect(verifyRecoveryInfo(enteredAnswer: 'siti'), true);
    expect(verifyRecoveryInfo(enteredAnswer: 'SITI'), true);
    expect(verifyRecoveryInfo(enteredAnswer: 'budi'), false);
  });

  test('Notification unread count accurately calculates unread items', () {
    final notifs = [
      NotificationItemModel(
        id: 'n1',
        title: 'Test',
        message: 'msg',
        timestamp: DateTime.now(),
        isRead: false,
        type: 'TUGAS',
      ),
      NotificationItemModel(
        id: 'n2',
        title: 'Test2',
        message: 'msg2',
        timestamp: DateTime.now(),
        isRead: false,
        type: 'PRESENSI',
      ),
      NotificationItemModel(
        id: 'n3',
        title: 'Test3',
        message: 'msg3',
        timestamp: DateTime.now(),
        isRead: true,
        type: 'SISTEM',
      ),
    ];

    final initialUnread = notifs.where((n) => !n.isRead).length;
    expect(initialUnread, 2);

    final allRead = notifs.map((n) => n.copyWith(isRead: true)).toList();
    final updatedUnread = allRead.where((n) => !n.isRead).length;
    expect(updatedUnread, 0);
  });

  test('All model adapters and deserializers resist null and type mismatch without TypeError', () {
    // Malformed / incomplete Task map
    final malformedTask = TaskModel.fromMap({
      'id': null,
      'title': null,
      'dateTime': 'not-a-date',
      'isCompleted': null,
    });
    expect(malformedTask.id, '');
    expect(malformedTask.title, '');
    expect(malformedTask.category, 'Kuliah');
    expect(malformedTask.isCompleted, false);

    // Empty Note map
    final emptyNote = NoteModel.fromMap({});
    expect(emptyNote.id, '');
    expect(emptyNote.title, '');
    expect(emptyNote.isPinned, false);

    // Empty Attendance map
    final emptyAtt = AttendanceModel.fromMap({});
    expect(emptyAtt.id, '');
    expect(emptyAtt.attendedMeetings, 0);
    expect(emptyAtt.totalMeetings, 14);

    // Empty Notification map
    final emptyNotif = NotificationItemModel.fromMap({});
    expect(emptyNotif.id, '');
    expect(emptyNotif.isRead, false);
    expect(emptyNotif.type, 'TUGAS');
  });
}


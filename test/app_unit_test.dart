import 'package:flutter_test/flutter_test.dart';
import 'package:kelarin/app/core/constants/app_colors.dart';
import 'package:kelarin/app/data/models/task_model.dart';
import 'package:kelarin/app/data/services/dummy_data_service.dart';

void main() {
  test('DummyDataService provides initial tasks matching Stitch specs', () {
    final tasks = DummyDataService.initialTasks;
    expect(tasks.isNotEmpty, true);

    final firstTask = tasks.first;
    expect(firstTask.title, 'Review proposal desain UI');
    expect(firstTask.priority, '! Tinggi');
    expect(firstTask.category, 'Kuliah');
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
    expect(AppColors.primary.toARGB32(), 0xFF0A0A0A);
    expect(AppColors.background.toARGB32(), 0xFFF6F6F7);
    expect(AppColors.surface.toARGB32(), 0xFFFFFFFF);
  });
}

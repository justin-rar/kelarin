import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class TaskModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  final String timeString;

  @HiveField(4)
  final String location;

  @HiveField(5)
  final String category;

  @HiveField(6)
  final String priority; // "! Tinggi", "= Sedang", "— Rendah"

  @HiveField(7)
  final bool isCompleted;

  @HiveField(8)
  final DateTime? completedAt;

  @HiveField(9)
  final String? note;

  TaskModel({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.timeString,
    required this.location,
    required this.category,
    required this.priority,
    this.isCompleted = false,
    this.completedAt,
    this.note,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    DateTime? dateTime,
    String? timeString,
    String? location,
    String? category,
    String? priority,
    bool? isCompleted,
    DateTime? completedAt,
    String? note,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      timeString: timeString ?? this.timeString,
      location: location ?? this.location,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime.toIso8601String(),
      'timeString': timeString,
      'location': location,
      'category': category,
      'priority': priority,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'note': note,
    };
  }

  factory TaskModel.fromMap(Map<dynamic, dynamic> map) {
    return TaskModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      dateTime: map['dateTime'] != null
          ? (DateTime.tryParse(map['dateTime'].toString()) ?? DateTime.now())
          : DateTime.now(),
      timeString: map['timeString']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      category: map['category']?.toString() ?? 'Kuliah',
      priority: map['priority']?.toString() ?? '= Sedang',
      isCompleted: map['isCompleted'] == true,
      completedAt: map['completedAt'] != null
          ? DateTime.tryParse(map['completedAt'].toString())
          : null,
      note: map['note']?.toString(),
    );
  }
}

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 0;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      id: fields[0]?.toString() ?? '',
      title: fields[1]?.toString() ?? '',
      dateTime: fields[2] is DateTime
          ? fields[2] as DateTime
          : (fields[2] != null
              ? (DateTime.tryParse(fields[2].toString()) ?? DateTime.now())
              : DateTime.now()),
      timeString: fields[3]?.toString() ?? '',
      location: fields[4]?.toString() ?? '',
      category: fields[5]?.toString() ?? 'Kuliah',
      priority: fields[6]?.toString() ?? '= Sedang',
      isCompleted: fields[7] == true,
      completedAt: fields[8] is DateTime
          ? fields[8] as DateTime
          : (fields[8] != null
              ? DateTime.tryParse(fields[8].toString())
              : null),
      note: fields[9]?.toString(),
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.timeString)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.priority)
      ..writeByte(7)
      ..write(obj.isCompleted)
      ..writeByte(8)
      ..write(obj.completedAt)
      ..writeByte(9)
      ..write(obj.note);
  }
}


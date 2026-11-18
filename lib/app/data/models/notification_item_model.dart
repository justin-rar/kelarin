import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class NotificationItemModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String message;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final bool isRead;

  @HiveField(5)
  final String type; // "TUGAS", "PRESENSI", "SISTEM"

  NotificationItemModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.type = 'TUGAS',
  });

  NotificationItemModel copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    String? type,
  }) {
    return NotificationItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'type': type,
    };
  }

  factory NotificationItemModel.fromMap(Map<dynamic, dynamic> map) {
    return NotificationItemModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      message: map['message']?.toString() ?? '',
      timestamp: map['timestamp'] != null
          ? (DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now())
          : DateTime.now(),
      isRead: map['isRead'] == true,
      type: map['type']?.toString() ?? 'TUGAS',
    );
  }
}

class NotificationItemModelAdapter extends TypeAdapter<NotificationItemModel> {
  @override
  final int typeId = 3;

  @override
  NotificationItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationItemModel(
      id: fields[0]?.toString() ?? '',
      title: fields[1]?.toString() ?? '',
      message: fields[2]?.toString() ?? '',
      timestamp: fields[3] is DateTime
          ? fields[3] as DateTime
          : (fields[3] != null
              ? (DateTime.tryParse(fields[3].toString()) ?? DateTime.now())
              : DateTime.now()),
      isRead: fields[4] == true,
      type: fields[5]?.toString() ?? 'TUGAS',
    );
  }

  @override
  void write(BinaryWriter writer, NotificationItemModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.isRead)
      ..writeByte(5)
      ..write(obj.type);
  }
}


import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class AttendanceModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String subjectName;

  @HiveField(2)
  final String type; // "Praktikum" or "Teori"

  @HiveField(3)
  final String day; // "Senin", "Selasa", etc.

  @HiveField(4)
  final String time; // "08:00 - 10:00 WIB"

  @HiveField(5)
  final String room; // "Lab Komputer 3"

  @HiveField(6)
  final bool reminderActive;

  @HiveField(7)
  final int attendedMeetings;

  @HiveField(8)
  final int totalMeetings;

  AttendanceModel({
    required this.id,
    required this.subjectName,
    required this.type,
    required this.day,
    required this.time,
    required this.room,
    this.reminderActive = true,
    this.attendedMeetings = 0,
    this.totalMeetings = 14,
  });

  AttendanceModel copyWith({
    String? id,
    String? subjectName,
    String? type,
    String? day,
    String? time,
    String? room,
    bool? reminderActive,
    int? attendedMeetings,
    int? totalMeetings,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      subjectName: subjectName ?? this.subjectName,
      type: type ?? this.type,
      day: day ?? this.day,
      time: time ?? this.time,
      room: room ?? this.room,
      reminderActive: reminderActive ?? this.reminderActive,
      attendedMeetings: attendedMeetings ?? this.attendedMeetings,
      totalMeetings: totalMeetings ?? this.totalMeetings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subjectName': subjectName,
      'type': type,
      'day': day,
      'time': time,
      'room': room,
      'reminderActive': reminderActive,
      'attendedMeetings': attendedMeetings,
      'totalMeetings': totalMeetings,
    };
  }

  factory AttendanceModel.fromMap(Map<dynamic, dynamic> map) {
    return AttendanceModel(
      id: map['id']?.toString() ?? '',
      subjectName: map['subjectName']?.toString() ?? '',
      type: map['type']?.toString() ?? 'Teori',
      day: map['day']?.toString() ?? 'Senin',
      time: map['time']?.toString() ?? '',
      room: map['room']?.toString() ?? '',
      reminderActive: map['reminderActive'] != false,
      attendedMeetings: map['attendedMeetings'] is int
          ? map['attendedMeetings']
          : (int.tryParse(map['attendedMeetings']?.toString() ?? '0') ?? 0),
      totalMeetings: map['totalMeetings'] is int
          ? map['totalMeetings']
          : (int.tryParse(map['totalMeetings']?.toString() ?? '14') ?? 14),
    );
  }
}

class AttendanceModelAdapter extends TypeAdapter<AttendanceModel> {
  @override
  final int typeId = 1;

  @override
  AttendanceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendanceModel(
      id: fields[0]?.toString() ?? '',
      subjectName: fields[1]?.toString() ?? '',
      type: fields[2]?.toString() ?? 'Teori',
      day: fields[3]?.toString() ?? 'Senin',
      time: fields[4]?.toString() ?? '',
      room: fields[5]?.toString() ?? '',
      reminderActive: fields[6] != false,
      attendedMeetings: fields[7] is int
          ? fields[7] as int
          : (int.tryParse(fields[7]?.toString() ?? '0') ?? 0),
      totalMeetings: fields[8] is int
          ? fields[8] as int
          : (int.tryParse(fields[8]?.toString() ?? '14') ?? 14),
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.subjectName)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.day)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.room)
      ..writeByte(6)
      ..write(obj.reminderActive)
      ..writeByte(7)
      ..write(obj.attendedMeetings)
      ..writeByte(8)
      ..write(obj.totalMeetings);
  }
}


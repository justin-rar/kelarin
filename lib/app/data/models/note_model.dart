import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class NoteModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime updatedAt;

  @HiveField(4)
  final String category; // "Kuliah", "Proyek", "Pribadi"

  @HiveField(5)
  final bool isPinned;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
    this.category = 'Kuliah',
    this.isPinned = false,
  });

  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? updatedAt,
    String? category,
    bool? isPinned,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'updatedAt': updatedAt.toIso8601String(),
      'category': category,
      'isPinned': isPinned,
    };
  }

  factory NoteModel.fromMap(Map<dynamic, dynamic> map) {
    return NoteModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      content: map['content']?.toString() ?? '',
      updatedAt: map['updatedAt'] != null
          ? (DateTime.tryParse(map['updatedAt'].toString()) ?? DateTime.now())
          : DateTime.now(),
      category: map['category']?.toString() ?? 'Kuliah',
      isPinned: map['isPinned'] == true,
    );
  }
}

class NoteModelAdapter extends TypeAdapter<NoteModel> {
  @override
  final int typeId = 2;

  @override
  NoteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteModel(
      id: fields[0]?.toString() ?? '',
      title: fields[1]?.toString() ?? '',
      content: fields[2]?.toString() ?? '',
      updatedAt: fields[3] is DateTime
          ? fields[3] as DateTime
          : (fields[3] != null
              ? (DateTime.tryParse(fields[3].toString()) ?? DateTime.now())
              : DateTime.now()),
      category: fields[4]?.toString() ?? 'Kuliah',
      isPinned: fields[5] == true,
    );
  }

  @override
  void write(BinaryWriter writer, NoteModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.isPinned);
  }
}


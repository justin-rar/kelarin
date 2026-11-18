import 'package:get/get.dart';
import '../../data/models/note_model.dart';
import '../../data/services/storage_service.dart';
import '../../global_widgets/undo_toast.dart';

class NoteController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final RxList<NoteModel> notes = <NoteModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'Semua'.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  void loadNotes() {
    notes.assignAll(_storage.noteBox.values.toList());
  }

  List<NoteModel> get filteredNotes {
    return notes.where((n) {
      if (searchQuery.value.trim().isNotEmpty) {
        final q = searchQuery.value.trim().toLowerCase();
        final matchTitle = n.title.toLowerCase().contains(q);
        final matchContent = n.content.toLowerCase().contains(q);
        if (!matchTitle && !matchContent) return false;
      }
      return true;
    }).toList();
  }

  List<NoteModel> get pinnedNotes => filteredNotes.where((n) => n.isPinned).toList();
  List<NoteModel> get otherNotes => filteredNotes.where((n) => !n.isPinned).toList();

  List<NoteModel> get todayNotes {
    final now = DateTime.now();
    return filteredNotes.where((n) {
      return n.isPinned ||
          (n.updatedAt.year == now.year &&
              n.updatedAt.month == now.month &&
              n.updatedAt.day == now.day);
    }).toList();
  }

  List<NoteModel> get past7DaysNotes {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sevenDaysAgo = today.subtract(const Duration(days: 7));
    return filteredNotes.where((n) {
      if (n.isPinned) return false;
      final d = DateTime(n.updatedAt.year, n.updatedAt.month, n.updatedAt.day);
      return d.isBefore(today) && (d.isAfter(sevenDaysAgo) || d.isAtSameMomentAs(sevenDaysAgo));
    }).toList();
  }

  List<NoteModel> get past30DaysNotes {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sevenDaysAgo = today.subtract(const Duration(days: 7));
    final thirtyDaysAgo = today.subtract(const Duration(days: 30));
    return filteredNotes.where((n) {
      if (n.isPinned) return false;
      final d = DateTime(n.updatedAt.year, n.updatedAt.month, n.updatedAt.day);
      return d.isBefore(sevenDaysAgo) && (d.isAfter(thirtyDaysAgo) || d.isAtSameMomentAs(thirtyDaysAgo));
    }).toList();
  }

  List<NoteModel> get olderNotes {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thirtyDaysAgo = today.subtract(const Duration(days: 30));
    return filteredNotes.where((n) {
      if (n.isPinned) return false;
      final d = DateTime(n.updatedAt.year, n.updatedAt.month, n.updatedAt.day);
      return d.isBefore(thirtyDaysAgo);
    }).toList();
  }

  Future<void> addNote(NoteModel model) async {
    await _storage.noteBox.put(model.id, model);
    loadNotes();
    UndoToast.show(message: 'Catatan berhasil disimpan');
  }

  Future<void> updateNote(NoteModel model) async {
    await _storage.noteBox.put(model.id, model);
    loadNotes();
    UndoToast.show(message: 'Perubahan catatan disimpan');
  }

  Future<void> deleteNote(String id) async {
    await _storage.noteBox.delete(id);
    loadNotes();
    UndoToast.show(message: 'Catatan dihapus');
  }

  Future<void> togglePin(String id) async {
    final index = notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      final current = notes[index];
      final updated = current.copyWith(isPinned: !current.isPinned);
      await _storage.noteBox.put(id, updated);
      loadNotes();
      UndoToast.show(
        message: updated.isPinned ? 'Catatan disematkan ke atas' : 'Sematkan catatan dilepas',
      );
    }
  }

  // Predefined Academic Note Templates
  static const Map<String, String> noteTemplates = {
    'Ringkasan Materi Kuliah': '''## Materi Kuliah
**Topik Pembahasan:** 
**Dosen Pengampu:** 

### Poin Utama:
1. 
2. 
3. 

### Pertanyaan / Hal yang Perlu Diingat:
- ''',

    'Instruksi Tugas Kuliah': '''## Spesifikasi Tugas
**Mata Kuliah:** 
**Tenggat Waktu:** 

### Kebutuhan & Requirement:
- [ ] Analisis dan perancangan
- [ ] Implementasi kode
- [ ] Pengujian / Testing
- [ ] Laporan akhir dan link GitHub''',

    'Catatan Lab & Praktikum': '''## Praktikum Lab
**Modul ke-:** 
**Tools / Library yang digunakan:** 

### Snippet Kode Penting:
```dart
// Tuliskan potongan kode di sini
```

### Kendala & Solusi (Troubleshooting):
- Error: 
- Solusi: ''',
  };
}


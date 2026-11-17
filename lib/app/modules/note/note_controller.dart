import 'package:get/get.dart';
import '../../data/models/note_model.dart';
import '../../data/services/storage_service.dart';
import '../../global_widgets/undo_toast.dart';

class NoteController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final RxList<NoteModel> notes = <NoteModel>[].obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  void loadNotes() {
    notes.assignAll(_storage.noteBox.values.toList());
  }

  List<NoteModel> get filteredNotes {
    if (searchQuery.value.trim().isEmpty) return notes;
    final q = searchQuery.value.trim().toLowerCase();
    return notes.where((n) =>
        n.title.toLowerCase().contains(q) ||
        n.content.toLowerCase().contains(q) ||
        n.category.toLowerCase().contains(q)).toList();
  }

  List<NoteModel> get pinnedNotes => filteredNotes.where((n) => n.isPinned).toList();
  List<NoteModel> get otherNotes => filteredNotes.where((n) => !n.isPinned).toList();

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


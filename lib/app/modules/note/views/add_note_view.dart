import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../data/models/note_model.dart';
import '../note_controller.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({super.key});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  final NoteController controller = Get.find<NoteController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  String selectedCategory = 'Kuliah';
  bool isPinned = false;

  final List<String> categories = ['Kuliah', 'Proyek', 'Pribadi'];

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Judul catatan wajib diisi!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.error,
        colorText: AppColors.onError,
      );
      return;
    }

    final newNote = NoteModel(
      id: 'note_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      content: content,
      updatedAt: DateTime.now(),
      category: selectedCategory,
      isPinned: isPinned,
    );

    controller.addNote(newNote);
    Get.back();
  }

  void _chooseTemplate() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(AppDimens.margin),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.fill1,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pilih Template Akademik',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            ...NoteController.noteTemplates.entries.map((entry) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.secondary),
                onTap: () {
                  if (titleController.text.isEmpty) {
                    titleController.text = entry.key;
                  }
                  contentController.text = entry.value;
                  Get.back();
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                boxShadow: const [AppColors.cardShadow],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.primary),
                onPressed: () => Get.back(),
              ),
            ),
          ),
        ),
        title: const Text(
          'Catatan Baru',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: _chooseTemplate,
              icon: const Icon(Icons.auto_stories_rounded, size: 16, color: AppColors.primary),
              label: const Text(
                'Template',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.fill1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppDimens.margin),
                children: [
                  // Judul Catatan
                  _buildLabel('JUDUL CATATAN *'),
                  Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppDimens.radiusInput),
                      boxShadow: const [AppColors.cardShadow],
                    ),
                    child: TextField(
                      controller: titleController,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      decoration: const InputDecoration(
                        hintText: 'Judul rangkuman atau topik...',
                        hintStyle: TextStyle(color: AppColors.tertiary, fontSize: 13),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Kategori & Pin
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('KATEGORI'),
                          Wrap(
                            spacing: 8,
                            children: categories.map((cat) {
                              final isSelected = selectedCategory == cat;
                              return ChoiceChip(
                                label: Text(cat),
                                selected: isSelected,
                                selectedColor: AppColors.primary,
                                backgroundColor: AppColors.fill1,
                                labelStyle: TextStyle(
                                  color: isSelected ? AppColors.onPrimary : AppColors.secondary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                                  side: BorderSide.none,
                                ),
                                showCheckmark: false,
                                onSelected: (_) => setState(() => selectedCategory = cat),
                              );
                            }).toList(),
                          ),
                        ],
                      ),

                      // Sematkan toggle
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildLabel('SEMATKAN'),
                          IconButton(
                            icon: Icon(
                              isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
                              color: isPinned ? AppColors.primary : AppColors.tertiary,
                            ),
                            onPressed: () => setState(() => isPinned = !isPinned),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Isi Catatan
                  _buildLabel('ISI CATATAN'),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppDimens.radiusInput),
                      boxShadow: const [AppColors.cardShadow],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: contentController,
                      maxLines: 14,
                      style: const TextStyle(fontSize: 14, height: 1.5, fontWeight: FontWeight.w500),
                      decoration: const InputDecoration(
                        hintText: 'Tuliskan catatan lengkap di sini (mendukung format Markdown ringkas)...',
                        hintStyle: TextStyle(color: AppColors.tertiary, fontSize: 13),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Action
            Container(
              padding: const EdgeInsets.all(AppDimens.margin),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _saveNote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  ),
                ),
                child: const Text(
                  'Simpan Catatan',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.secondary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}


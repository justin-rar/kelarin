import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../data/models/note_model.dart';
import '../note_controller.dart';

class EditNoteView extends StatefulWidget {
  const EditNoteView({super.key});

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  final NoteController controller = Get.find<NoteController>();
  late NoteModel note;

  late TextEditingController titleController;
  late TextEditingController contentController;

  late String selectedCategory;
  late bool isPinned;

  final List<String> categories = ['Kuliah', 'Proyek', 'Pribadi'];

  @override
  void initState() {
    super.initState();
    note = Get.arguments as NoteModel;
    titleController = TextEditingController(text: note.title);
    contentController = TextEditingController(text: note.content);
    selectedCategory = categories.contains(note.category) ? note.category : 'Kuliah';
    isPinned = note.isPinned;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _updateNote() {
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

    final updated = note.copyWith(
      title: title,
      content: content,
      updatedAt: DateTime.now(),
      category: selectedCategory,
      isPinned: isPinned,
    );

    controller.updateNote(updated);
    Get.back();
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
          'Edit Catatan',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
            onPressed: () {
              controller.deleteNote(note.id);
              Get.back();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppDimens.margin),
                children: [
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
                        hintText: 'Judul rangkuman...',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

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
                        hintText: 'Tuliskan catatan lengkap di sini...',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),

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
                onPressed: _updateNote,
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
                  'Simpan Perubahan',
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


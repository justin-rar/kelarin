import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/note_model.dart';
import '../../../global_widgets/form_top_bar.dart';
import '../note_controller.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({super.key});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  late final NoteController controller;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  bool isPinned = false;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<NoteController>()
        ? Get.find<NoteController>()
        : Get.put(NoteController(), permanent: true);
    contentController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  int get wordCount {
    final text = contentController.text.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;
  }

  void _saveNote() {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Judul catatan wajib diisi!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.primary,
        colorText: AppColors.onPrimary,
      );
      return;
    }

    final newNote = NoteModel(
      id: 'note_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      content: content,
      updatedAt: DateTime.now(),
      category: '',
      isPinned: isPinned,
    );

    controller.addNote(newNote);
    Get.back();
  }

  void _insertFormatting(String prefix, [String suffix = '']) {
    final text = contentController.text;
    final selection = contentController.selection;
    if (selection.isValid && selection.start >= 0 && selection.end >= 0) {
      final selectedText = text.substring(selection.start, selection.end);
      final newText = text.replaceRange(
        selection.start,
        selection.end,
        '$prefix$selectedText$suffix',
      );
      contentController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: selection.start + prefix.length + selectedText.length + suffix.length,
        ),
      );
    } else {
      contentController.text = '$text\n$prefix$suffix';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Standard FormTopBar (64px, arrow_back, modal-title)
            const FormTopBar(title: 'Catatan Baru'),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.margin,
                  vertical: 16,
                ),
                children: [
                  // 1. One Large White Card (24px radius, minHeight 460)
                  Container(
                    constraints: const BoxConstraints(minHeight: 460),
                    padding: const EdgeInsets.all(AppDimens.spaceXl),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                      boxShadow: const [AppShadows.standard],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status Header Line: Clock icon + "Dibuat hari ini • Baru"
                        Row(
                          children: [
                            const Icon(
                              Icons.schedule,
                              size: 14,
                              color: AppColors.secondary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Dibuat hari ini • Baru',
                              style: AppTypography.captionMeta.copyWith(
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Title Input (24px w800, borderless)
                        TextField(
                          controller: titleController,
                          style: AppTypography.headlineH1.copyWith(
                            color: AppColors.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Judul catatan',
                            hintStyle: AppTypography.headlineH1.copyWith(
                              color: AppColors.outline,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Divider(height: 1, color: AppColors.divider),
                        const SizedBox(height: 14),

                        // Content Textarea (borderless, multiline)
                        TextField(
                          controller: contentController,
                          maxLines: null,
                          minLines: 10,
                          style: AppTypography.bodyDefault.copyWith(
                            color: AppColors.onSurface,
                            height: 1.5,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Mulai menulis catatan di sini...',
                            hintStyle: AppTypography.bodyDefault.copyWith(
                              color: AppColors.outline,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Divider(height: 1, color: AppColors.divider),
                        const SizedBox(height: 12),

                        // Status Footer: Grey dot + "Draf baru", "MARKDOWN" tag
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.outline,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Draf baru',
                                  style: AppTypography.captionMeta.copyWith(
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.fill1,
                                borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                              ),
                              child: Text(
                                'MARKDOWN',
                                style: AppTypography.captionMeta.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 2. Formatting Dock Card (16px radius, surface, standard shadow)
                  Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppDimens.radius2Xl),
                      boxShadow: const [AppShadows.standard],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                // Bold button
                                IconButton(
                                  icon: const Text('B', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                                  onPressed: () => _insertFormatting('**', '**'),
                                  tooltip: 'Tebal',
                                ),
                                // Bullet list button
                                IconButton(
                                  icon: const Icon(Icons.format_list_bulleted, size: 20),
                                  onPressed: () => _insertFormatting('- '),
                                  tooltip: 'Daftar',
                                ),
                                // Checklist button
                                IconButton(
                                  icon: const Icon(Icons.check_box_outlined, size: 20),
                                  onPressed: () => _insertFormatting('- [ ] '),
                                  tooltip: 'Checklist',
                                ),
                                // Pin toggle button
                                IconButton(
                                  icon: Icon(
                                    isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                                    size: 20,
                                    color: isPinned ? AppColors.primary : AppColors.secondary,
                                  ),
                                  onPressed: () => setState(() => isPinned = !isPinned),
                                  tooltip: 'Sematkan',
                                ),
                                const VerticalDivider(width: 8, indent: 14, endIndent: 14, color: AppColors.divider),
                                // Attach image placeholder
                                IconButton(
                                  icon: const Icon(Icons.image_outlined, size: 20),
                                  onPressed: () => _insertFormatting('![Gambar](url)'),
                                  tooltip: 'Gambar',
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Word count
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            '$wordCount kata',
                            style: AppTypography.captionMeta.copyWith(
                              color: AppColors.outline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 3. Ambient Guidance
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_outline, size: 14, color: AppColors.outline),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Enkripsi lokal aktif • Hanya Anda yang dapat membaca catatan ini',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.captionMeta.copyWith(
                            fontSize: 10.5,
                            color: AppColors.outline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 4. Page Flow Stacked Buttons (52px black over 52px fill-1 Hapus Draf)
                  ElevatedButton(
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
                    child: Text(
                      'Simpan Catatan',
                      style: AppTypography.buttonText.copyWith(color: AppColors.onPrimary),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.fill1,
                      foregroundColor: AppColors.onSurface,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                      ),
                    ),
                    child: Text(
                      'Hapus Draf',
                      style: AppTypography.buttonText.copyWith(color: AppColors.onSurface),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/note_model.dart';
import '../../../global_widgets/confirmation_dialog.dart';
import '../../../global_widgets/form_top_bar.dart';
import '../note_controller.dart';

class EditNoteView extends StatefulWidget {
  const EditNoteView({super.key});

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  late final NoteController controller;
  late NoteModel note;

  late TextEditingController titleController;
  late TextEditingController contentController;

  late bool isPinned;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<NoteController>()
        ? Get.find<NoteController>()
        : Get.put(NoteController(), permanent: true);

    if (Get.arguments is NoteModel) {
      note = Get.arguments as NoteModel;
    } else if (controller.notes.isNotEmpty) {
      note = controller.notes.first;
    } else {
      note = NoteModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '',
        content: '',
        updatedAt: DateTime.now(),
      );
    }
    titleController = TextEditingController(text: note.title);
    contentController = TextEditingController(text: note.content);
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
        duration: const Duration(milliseconds: 1800),
        backgroundColor: AppColors.primary,
        colorText: AppColors.onPrimary,
      );
      return;
    }

    final updated = note.copyWith(
      title: title,
      content: content,
      updatedAt: DateTime.now(),
      isPinned: isPinned,
    );

    controller.updateNote(updated);
    Get.back();
  }

  void _confirmDelete() {
    ConfirmationDialog.show(
      title: 'Hapus Catatan?',
      message: 'Apakah Anda yakin ingin menghapus catatan ini? Tindakan ini tidak dapat dibatalkan.',
      icon: Icons.delete_outline_rounded,
      confirmText: 'Hapus',
      cancelText: 'Batal',
      isDestructive: true,
      onConfirm: () {
        Get.back(); // close dialog
        controller.deleteNote(note.id);
        Get.back(); // close edit screen
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('HH:mm').format(note.updatedAt);
    final dateStr = DateFormat('d MMM').format(note.updatedAt);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Standard FormTopBar (64px, arrow_back, modal-title)
            const FormTopBar(title: 'Edit Catatan'),

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
                        // Status Header Line
                        Row(
                          children: [
                            const Icon(
                              Icons.schedule,
                              size: 14,
                              color: AppColors.secondary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Terakhir diedit $timeStr WIB • $dateStr',
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

                        // Status Footer: Grey dot + "Tersimpan otomatis", "MARKDOWN" tag
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
                                  'Tersimpan otomatis',
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
                  const SizedBox(height: 16),

                  // 2. Ambient Guidance
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

                  // 4. Page Flow Stacked Buttons
                  ElevatedButton(
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
                    child: Text(
                      'Simpan Perubahan',
                      style: AppTypography.buttonText.copyWith(color: AppColors.onPrimary),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _confirmDelete,
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.fill1,
                      foregroundColor: AppColors.onSurface,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                      ),
                    ),
                    icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.onSurface),
                    label: Text(
                      'Hapus Catatan',
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

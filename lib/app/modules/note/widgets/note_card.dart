import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../data/models/note_model.dart';
import '../../../routes/app_routes.dart';
import '../note_controller.dart';

class NoteCard extends GetView<NoteController> {
  final NoteModel note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('d MMM, HH:mm').format(note.updatedAt);

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.gutter),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed(AppRoutes.noteEdit, arguments: note),
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: Date Pill + Pin Icon + More Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 28,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColors.fill1,
                        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time_rounded, size: 13, color: AppColors.secondary),
                          const SizedBox(width: 5),
                          Text(
                            dateStr,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      children: [
                        // Pin Toggle Icon
                        IconButton(
                          icon: Icon(
                            note.isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
                            size: 18,
                            color: note.isPinned ? AppColors.primary : AppColors.tertiary,
                          ),
                          onPressed: () => controller.togglePin(note.id),
                          tooltip: note.isPinned ? 'Lepas Sematan' : 'Sematkan ke Atas',
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          padding: EdgeInsets.zero,
                        ),

                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert_rounded, size: 20, color: AppColors.secondary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimens.radiusInput),
                          ),
                          onSelected: (val) {
                            if (val == 'edit') {
                              Get.toNamed(AppRoutes.noteEdit, arguments: note);
                            } else if (val == 'delete') {
                              controller.deleteNote(note.id);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                                  SizedBox(width: 10),
                                  Text('Edit Catatan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            const PopupMenuDivider(height: 1),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                                  SizedBox(width: 10),
                                  Text('Hapus', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.error)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Row 2: Title
                Text(
                  note.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 8),

                // Row 3: Preview (max 2 lines)
                Text(
                  note.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondary,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 12),

                // Row 4: Tag Category Pill
                Container(
                  height: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.fill1,
                    borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.label_outline_rounded, size: 12, color: AppColors.secondary),
                      const SizedBox(width: 4),
                      Text(
                        note.category,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


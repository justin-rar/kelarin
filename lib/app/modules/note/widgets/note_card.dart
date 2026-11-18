import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/note_model.dart';
import '../../../routes/app_routes.dart';
import '../note_controller.dart';

/// NoteCard matching DESIGN.md:
/// 24px radius, standard shadow, active scale 0.99.
/// Header: time/date pill + optional 28px fill-1 circle with pin + more_vert (popover: only Hapus).
/// Title (card-title, max 2 lines), preview (14px secondary, max 2 lines), fill-1 category chip.
class NoteCard extends StatefulWidget {
  final NoteModel note;

  const NoteCard({super.key, required this.note});

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  NoteController get controller => Get.find<NoteController>();
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final note = widget.note;
    final dateStr = DateFormat('d MMM, HH:mm').format(note.updatedAt);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () => Get.toNamed(AppRoutes.noteEdit, arguments: note),
      child: AnimatedScale(
        scale: _pressed ? 0.99 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          margin: const EdgeInsets.only(bottom: AppDimens.gutter),
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            boxShadow: const [AppShadows.standard],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Date Pill + Pinned Circle + More Actions (Only Hapus)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Date / Time Pill
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
                            const Icon(
                              Icons.schedule,
                              size: 14,
                              color: AppColors.secondary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              dateStr,
                              style: AppTypography.captionMeta.copyWith(
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 28px fill-1 circle with pin for pinned notes
                      if (note.isPinned) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: AppColors.fill1,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.push_pin,
                              size: 14,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Popover Menu (Notes: ONLY "Hapus")
                  PopupMenuButton<String>(
                    tooltip: 'Menu opsi',
                    position: PopupMenuPosition.under,
                    offset: const Offset(0, 8),
                    elevation: 8,
                    shadowColor: Colors.black.withValues(alpha: 0.14),
                    surfaceTintColor: Colors.transparent,
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: AppColors.divider.withValues(alpha: 0.8),
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 120),
                    onSelected: (val) {
                      if (val == 'delete') {
                        controller.deleteNote(note.id);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'delete',
                        height: 44,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: AppColors.onSurface,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Hapus',
                              style: AppTypography.bodyDefault.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.fill1,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.more_vert_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title (card-title, max 2 lines)
              Text(
                note.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.cardTitle.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 6),

              // Preview (14px secondary, max 2 lines)
              if (note.content.isNotEmpty)
                Text(
                  note.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyDefault.copyWith(
                    color: AppColors.secondary,
                    height: 1.4,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/task_model.dart';
import '../../../routes/app_routes.dart';
import '../task_controller.dart';

/// TaskCard matching DESIGN.md:
/// 24px radius, 16px padding, standard shadow.
/// 24px circular checkbox without borders (solid surfaceContainerHigh when empty, solid black when checked).
/// Left: date/time pill, right: more_vert or undo button.
/// Title, indented meta row with • separators, indented chips (category, priority).
/// Popover menu with neutral Edit & Hapus rows.
class TaskCard extends StatefulWidget {
  final TaskModel task;
  final bool isCompletedVariant;

  const TaskCard({
    super.key,
    required this.task,
    this.isCompletedVariant = false,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  TaskController get controller => Get.isRegistered<TaskController>()
      ? Get.find<TaskController>()
      : Get.put(TaskController(), permanent: true);
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final isDone = task.isCompleted || widget.isCompletedVariant;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () => Get.toNamed(AppRoutes.taskDetail, arguments: task),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
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
              // Row 1: Date/Time Pill (Left) & Actions (Right)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date / Time / Completed Pill
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
                        Icon(
                          isDone ? Icons.check_circle : Icons.calendar_today_outlined,
                          size: 14,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isDone
                              ? 'Selesai · ${task.timeString.isNotEmpty ? task.timeString : '14:15 WIB'}'
                              : (task.timeString.isNotEmpty ? task.timeString : 'Terjadwal'),
                          style: AppTypography.captionMeta.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right: Undo button (for Selesai) or 3-dot Popover Menu
                  if (widget.isCompletedVariant || isDone)
                    GestureDetector(
                      onTap: () => controller.toggleTaskComplete(task.id),
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.fill1,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.undo_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  else
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
                      constraints: const BoxConstraints(minWidth: 140),
                      onSelected: (val) {
                        if (val == 'edit') {
                          Get.toNamed(AppRoutes.taskEdit, arguments: task);
                        } else if (val == 'delete') {
                          controller.deleteTask(task.id);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          height: 44,
                          child: Row(
                            children: [
                              const Icon(Icons.edit_outlined, size: 18, color: AppColors.onSurface),
                              const SizedBox(width: 10),
                              Text('Edit', style: AppTypography.bodyDefault.copyWith(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(height: 1),
                        PopupMenuItem(
                          value: 'delete',
                          height: 44,
                          child: Row(
                            children: [
                              const Icon(Icons.delete_outline, size: 18, color: AppColors.onSurface),
                              const SizedBox(width: 10),
                              Text('Hapus', style: AppTypography.bodyDefault.copyWith(fontWeight: FontWeight.w600)),
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

              // Row 2: 24px Circular Checkbox & Task Title
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => controller.toggleTaskComplete(task.id),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      margin: const EdgeInsets.only(top: 1, right: 12),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDone ? AppColors.primary : AppColors.surfaceContainerHigh,
                      ),
                      child: isDone
                          ? const Center(
                              child: Icon(
                                Icons.check,
                                size: 16,
                                color: AppColors.onPrimary,
                              ),
                            )
                          : null,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      task.title,
                      style: AppTypography.cardTitle.copyWith(
                        color: isDone ? AppColors.secondary : AppColors.onSurface,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Row 3: Metadata (Indented under title: 36px)
              Padding(
                padding: const EdgeInsets.only(left: 36),
                child: Row(
                  children: [
                    if (task.location.isNotEmpty) ...[
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          task.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.captionMeta.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ] else ...[
                      const Icon(
                        Icons.folder_outlined,
                        size: 14,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task.category,
                        style: AppTypography.captionMeta.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Row 4: Chips (Indented under title: 36px)
              Padding(
                padding: const EdgeInsets.only(left: 36),
                child: Row(
                  children: [
                    // Category Chip
                    Container(
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.fill1,
                        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                      ),
                      child: Text(
                        task.category,
                        style: AppTypography.navLabel.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Priority Chip with literal prefix: — Rendah, = Sedang, ! Tinggi
                    Container(
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.fill1,
                        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                      ),
                      child: Text(
                        task.priority,
                        style: AppTypography.navLabel.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

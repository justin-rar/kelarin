import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../data/models/task_model.dart';
import '../../../routes/app_routes.dart';
import '../task_controller.dart';

class TaskCard extends GetView<TaskController> {
  final TaskModel task;
  final bool isCompletedVariant;

  const TaskCard({
    super.key,
    required this.task,
    this.isCompletedVariant = false,
  });

  @override
  Widget build(BuildContext context) {
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
          onTap: () => Get.toNamed(AppRoutes.taskDetail, arguments: task),
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: Date/Schedule Badge (Left) & More Actions Menu (Right)
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
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 13,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            task.timeString.isNotEmpty ? task.timeString : 'Terjadwal',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Actions Menu (or Undo for completed variant)
                    if (isCompletedVariant)
                      IconButton(
                        icon: const Icon(
                          Icons.replay_rounded,
                          size: 20,
                          color: AppColors.secondary,
                        ),
                        onPressed: () => controller.toggleTaskComplete(task.id),
                        tooltip: 'Urungkan Selesai',
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        padding: EdgeInsets.zero,
                      )
                    else
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert_rounded,
                          size: 20,
                          color: AppColors.secondary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimens.radiusInput),
                        ),
                        color: AppColors.surface,
                        elevation: 6,
                        onSelected: (val) {
                          if (val == 'edit') {
                            Get.toNamed(AppRoutes.taskEdit, arguments: task);
                          } else if (val == 'delete') {
                            controller.deleteTask(task.id);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                                SizedBox(width: 10),
                                Text('Edit', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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

                const SizedBox(height: 12),

                // Row 2: Checkbox & Task Title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => controller.toggleTaskComplete(task.id),
                      child: Container(
                        margin: const EdgeInsets.only(top: 2, right: 12),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: task.isCompleted ? AppColors.primary : AppColors.statLight,
                          border: task.isCompleted
                              ? null
                              : Border.all(color: AppColors.outlineVariant, width: 1.5),
                        ),
                        child: task.isCompleted
                            ? const Center(
                                child: Icon(
                                  Icons.check_rounded,
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: task.isCompleted ? AppColors.secondary : AppColors.primary,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Row 3: Metadata (Location / Note preview)
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
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ] else ...[
                        const Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Tenggat Mendatang',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Row 4: Tag Chips (Category & Priority)
                Padding(
                  padding: const EdgeInsets.only(left: 36),
                  child: Row(
                    children: [
                      // Category Chip
                      Container(
                        height: 24,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.fill1,
                          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                        ),
                        child: Center(
                          child: Text(
                            task.category,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Priority Chip
                      Container(
                        height: 24,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.fill1,
                          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                        ),
                        child: Center(
                          child: Text(
                            task.priority,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: task.priority == '! Tinggi'
                                  ? AppColors.primary
                                  : AppColors.secondary,
                            ),
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
      ),
    );
  }
}


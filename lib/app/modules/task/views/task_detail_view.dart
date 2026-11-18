import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/task_model.dart';
import '../../../global_widgets/form_top_bar.dart';
import '../../../routes/app_routes.dart';
import '../task_controller.dart';

class TaskDetailView extends GetView<TaskController> {
  const TaskDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final taskArg = Get.arguments is TaskModel ? (Get.arguments as TaskModel) : null;
    if (taskArg == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const SafeArea(
          child: Center(child: Text('Tugas tidak ditemukan')),
        ),
      );
    }

    return Obx(() {
      // Find latest updated task from state
      final currentTask = controller.allTasks.firstWhere(
        (t) => t.id == taskArg.id,
        orElse: () => taskArg,
      );

      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Standard FormTopBar with Edit button on right
              FormTopBar(
                title: 'Detail Tugas',
                trailing: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    boxShadow: const [AppShadows.standard],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.primary),
                    onPressed: () => Get.toNamed(AppRoutes.taskEdit, arguments: currentTask),
                  ),
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppDimens.margin),
                  children: [
                    // Main Card (24px radius, standard shadow)
                    Container(
                      padding: const EdgeInsets.all(AppDimens.spaceXl),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                        boxShadow: const [AppShadows.standard],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: currentTask.isCompleted ? AppColors.primary : AppColors.fill1,
                              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                            ),
                            child: Text(
                              currentTask.isCompleted ? '✓ Selesai' : 'Sedang Berjalan',
                              style: AppTypography.captionMeta.copyWith(
                                fontWeight: FontWeight.w700,
                                color: currentTask.isCompleted
                                    ? AppColors.onPrimary
                                    : AppColors.secondary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Title
                          Text(
                            currentTask.title,
                            style: AppTypography.headlineH1.copyWith(
                              color: currentTask.isCompleted
                                  ? AppColors.secondary
                                  : AppColors.primary,
                              decoration: currentTask.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 20),

                          const Divider(height: 1, color: AppColors.divider),
                          const SizedBox(height: 16),

                          // Schedule Row
                          _buildInfoRow(
                            icon: Icons.calendar_today_outlined,
                            label: 'Waktu / Tenggat',
                            value: currentTask.timeString.isNotEmpty
                                ? currentTask.timeString
                                : 'Hari ini',
                          ),
                          const SizedBox(height: 14),

                          // Category Row
                          _buildInfoRow(
                            icon: Icons.folder_outlined,
                            label: 'Kategori',
                            value: currentTask.category,
                          ),
                          const SizedBox(height: 14),

                          // Priority Row
                          _buildInfoRow(
                            icon: Icons.flag_outlined,
                            label: 'Prioritas',
                            value: currentTask.priority,
                          ),

                          if (currentTask.location.isNotEmpty) ...[
                            const SizedBox(height: 14),
                            _buildInfoRow(
                              icon: Icons.location_on_outlined,
                              label: 'Lokasi',
                              value: currentTask.location,
                            ),
                          ],
                        ],
                      ),
                    ),

                    if (currentTask.note != null && currentTask.note!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(AppDimens.spaceXl),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                          boxShadow: const [AppShadows.standard],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.notes_rounded, size: 18, color: AppColors.secondary),
                                const SizedBox(width: 8),
                                Text(
                                  'Catatan',
                                  style: AppTypography.fieldLabel.copyWith(
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              currentTask.note!,
                              style: AppTypography.bodyDefault.copyWith(
                                height: 1.5,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Bottom Sticky Action Bar
              Container(
                padding: const EdgeInsets.all(AppDimens.margin),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [AppShadows.stickyActionBar],
                ),
                child: Row(
                  children: [
                    // Delete Button (Neutral monochrome, no red per standards)
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.fill1,
                        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.primary),
                        onPressed: () {
                          controller.deleteTask(currentTask.id);
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Toggle Complete Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          controller.toggleTaskComplete(currentTask.id);
                          Get.back();
                        },
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
                          currentTask.isCompleted ? 'Tandai Belum Selesai' : 'Tandai Selesai',
                          style: AppTypography.buttonText.copyWith(color: AppColors.onPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.secondary),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.captionMeta.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppTypography.bodyDefault.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

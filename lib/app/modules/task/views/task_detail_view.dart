import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../data/models/task_model.dart';
import '../../../routes/app_routes.dart';
import '../task_controller.dart';

class TaskDetailView extends GetView<TaskController> {
  const TaskDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final taskArg = Get.arguments as TaskModel?;
    if (taskArg == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Tugas')),
        body: const Center(child: Text('Tugas tidak ditemukan')),
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
            'Detail Tugas',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  boxShadow: const [AppColors.cardShadow],
                ),
                child: IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.primary),
                  onPressed: () => Get.toNamed(AppRoutes.taskEdit, arguments: currentTask),
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
                    // Main Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                        boxShadow: const [AppColors.cardShadow],
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
                              style: TextStyle(
                                fontSize: 12,
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
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: currentTask.isCompleted
                                  ? AppColors.secondary
                                  : AppColors.primary,
                              decoration: currentTask.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 20),

                          const Divider(),
                          const SizedBox(height: 16),

                          // Schedule Row
                          _buildInfoRow(
                            icon: Icons.calendar_today_rounded,
                            label: 'Waktu / Tenggat',
                            value: currentTask.timeString.isNotEmpty
                                ? currentTask.timeString
                                : 'Hari ini',
                          ),
                          const SizedBox(height: 14),

                          // Location Row
                          if (currentTask.location.isNotEmpty) ...[
                            _buildInfoRow(
                              icon: Icons.location_on_outlined,
                              label: 'Lokasi / Ruang',
                              value: currentTask.location,
                            ),
                            const SizedBox(height: 14),
                          ],

                          // Category & Priority
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoRow(
                                  icon: Icons.folder_outlined,
                                  label: 'Kategori',
                                  value: currentTask.category,
                                ),
                              ),
                              Expanded(
                                child: _buildInfoRow(
                                  icon: Icons.flag_outlined,
                                  label: 'Prioritas',
                                  value: currentTask.priority,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Notes Section
                    if (currentTask.note != null && currentTask.note!.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                          boxShadow: const [AppColors.cardShadow],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.notes_rounded, size: 18, color: AppColors.secondary),
                                SizedBox(width: 8),
                                Text(
                                  'Catatan Tambahan',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              currentTask.note!,
                              style: const TextStyle(
                                fontSize: 14,
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

              // Bottom Action Buttons
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
                child: Row(
                  children: [
                    // Delete Button
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.fill1,
                        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
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
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
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


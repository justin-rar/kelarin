import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../main_navigation/main_nav_controller.dart';
import '../../task/task_controller.dart';
import '../../../global_widgets/sine_wave_painter.dart';

class StatGrid extends GetView<TaskController> {
  const StatGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
      child: Column(
        children: [
          // 2x2 Checkerboard Stat Grid with SineWave Decoration
          Row(
            children: [
              // Tile 1: Total (Stat Light)
              Expanded(
                child: Obx(
                  () => _buildStatTile(
                    count: controller.totalCount.toString(),
                    label: 'Total',
                    bgColor: AppColors.statLight,
                    onTap: () => controller.selectedCategory.value = 'Semua',
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.gutter),
              // Tile 2: Terjadwal (Stat Dark)
              Expanded(
                child: Obx(
                  () => _buildStatTile(
                    count: controller.scheduledCount.toString(),
                    label: 'Terjadwal',
                    bgColor: AppColors.statDark,
                    onTap: () => controller.selectedCategory.value = 'Semua',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.gutter),
          Row(
            children: [
              // Tile 3: Prioritas (Stat Dark)
              Expanded(
                child: Obx(
                  () => _buildStatTile(
                    count: controller.priorityCount.toString(),
                    label: 'Prioritas',
                    bgColor: AppColors.statDark,
                    onTap: () => controller.selectedCategory.value = 'Semua',
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.gutter),
              // Tile 4: Sudah Selesai (Stat Light)
              Expanded(
                child: Obx(
                  () => _buildStatTile(
                    count: controller.completedCount.toString(),
                    label: 'Sudah Selesai',
                    bgColor: AppColors.statLight,
                    onTap: () {
                      if (Get.isRegistered<MainNavController>()) {
                        Get.find<MainNavController>().changeTab(1);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile({
    required String count,
    required String label,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        child: Container(
          height: 96,
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          ),
          child: Stack(
            children: [
              // Decorative Sine-Wave in top-right
              Positioned(
                top: 0,
                right: 0,
                child: CustomPaint(
                  size: const Size(44, 14),
                  painter: SineWavePainter(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    strokeWidth: 2.0,
                  ),
                ),
              ),

              // Content: Count & Label
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    count,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: -0.03,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

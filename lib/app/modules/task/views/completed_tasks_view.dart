import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../../../global_widgets/app_header.dart';
import '../../../global_widgets/app_search_bar.dart';
import '../../../global_widgets/confirmation_dialog.dart';
import '../../../global_widgets/empty_state.dart';
import '../../../global_widgets/page_title_row.dart';
import '../../../global_widgets/section_label.dart';
import '../../../global_widgets/stat_tile.dart';
import '../../ai/views/tanya_ai_bottom_sheet.dart';
import '../task_controller.dart';
import '../widgets/task_card.dart';

class CompletedTasksView extends GetView<TaskController> {
  const CompletedTasksView({super.key});

  static const List<String> _categories = [
    'Semua',
    'Kuliah',
    'Pekerjaan',
    'Pribadi',
    'Lainnya',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Fixed AppHeader (56px, blur + background/90)
            AppHeader(
              onAiTap: () => TanyaAiBottomSheet.show(context),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => controller.loadTasks(),
                color: AppColors.primary,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 120),
                  children: [
                    // 1. Page Title Row: Rekap (filter di atas dihapus)
                    const PageTitleRow(title: 'Rekap'),
                    const SizedBox(height: 16),

                    // 2. StatGrid: Rekap (2x2 Checkerboard, 96px high, sine-wave & chevron)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
                      child: Obx(() => Column(
                            children: [
                              // Top Row: Selesai (Light) & Hari Ini (Dark)
                              Row(
                                children: [
                                  Expanded(
                                    child: StatTile(
                                      value: controller.completedTasks.length.toString(),
                                      label: 'Selesai',
                                      backgroundColor: AppColors.statLight,
                                      variant: StatTileVariant.rekap,
                                    ),
                                  ),
                                  const SizedBox(width: AppDimens.gutter),
                                  Expanded(
                                    child: StatTile(
                                      value: controller.todayCompletedCount.toString(),
                                      label: 'Hari Ini',
                                      backgroundColor: AppColors.statDark,
                                      variant: StatTileVariant.rekap,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDimens.gutter),
                              // Bottom Row: Bulan Ini (Dark) & Tepat Waktu (Light)
                              Row(
                                children: [
                                  Expanded(
                                    child: StatTile(
                                      value: controller.monthCompletedCount.toString(),
                                      label: 'Bulan Ini',
                                      backgroundColor: AppColors.statDark,
                                      variant: StatTileVariant.rekap,
                                    ),
                                  ),
                                  const SizedBox(width: AppDimens.gutter),
                                  Expanded(
                                    child: StatTile(
                                      value: '${controller.onTimeRate}%',
                                      label: 'Tepat Waktu',
                                      backgroundColor: AppColors.statLight,
                                      variant: StatTileVariant.rekap,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(height: 14),

                    // 3. Search Bar (48px, surface, 16px radius, standard shadow)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
                      child: AppSearchBar(
                        placeholder: 'Cari tugas selesai...',
                        onChanged: (val) => controller.completedSearchQuery.value = val,
                        onClear: () => controller.completedSearchQuery.value = '',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 4. Dropdown Filter Kategori (menggantikan PillTabs, sama seperti Home)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: Obx(
                          () => PopupMenuButton<String>(
                            position: PopupMenuPosition.under,
                            offset: const Offset(0, 6),
                            color: AppColors.surface,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                              side: BorderSide(
                                color: AppColors.divider.withValues(alpha: 0.6),
                                width: 1,
                              ),
                            ),
                            onSelected: (cat) => controller.completedCategory.value = cat,
                            itemBuilder: (context) => _categories.map((cat) {
                              final isSelected = cat == controller.completedCategory.value;
                              return PopupMenuItem<String>(
                                value: cat,
                                height: 44,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      cat,
                                      style: AppTypography.bodyDefault.copyWith(
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.onSurface,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_rounded,
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(AppDimens.radius2Xl),
                                boxShadow: const [AppShadows.field],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.category_outlined,
                                        size: 18,
                                        color: AppColors.secondary,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        controller.completedCategory.value == 'Semua'
                                            ? 'Semua Kategori'
                                            : controller.completedCategory.value,
                                        style: AppTypography.bodyDefault.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 20,
                                    color: AppColors.secondary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 5. Grouped Completed Tasks / Empty State
                    Obx(() {
                      final todayTasks = controller.todayCompletedTasks;
                      final earlierTasks = controller.earlierCompletedTasks;
                      final isEmpty = todayTasks.isEmpty && earlierTasks.isEmpty;

                      if (isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.margin,
                            vertical: 8,
                          ),
                          child: const EmptyStateCard(
                            icon: Icons.task_alt_rounded,
                            title: 'Belum Ada Tugas Selesai',
                            subtitle:
                                'Tugas yang telah Anda selesaikan dari halaman Home akan dicatat rapi di sini.',
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section 1: Selesai Hari Ini
                            if (todayTasks.isNotEmpty) ...[
                              SectionLabel(
                                label: 'SELESAI HARI INI',
                                rightText: '${todayTasks.length} tugas',
                              ),
                              const SizedBox(height: 12),
                              ...todayTasks.map((task) => TaskCard(
                                    task: task,
                                    isCompletedVariant: true,
                                  )),
                              const SizedBox(height: 16),
                            ],

                            // Section 2: Kemarin / Lebih Awal
                            if (earlierTasks.isNotEmpty) ...[
                              SectionLabel(
                                label: 'KEMARIN',
                                rightText: '${earlierTasks.length} tugas',
                              ),
                              const SizedBox(height: 12),
                              ...earlierTasks.map((task) => TaskCard(
                                    task: task,
                                    isCompletedVariant: true,
                                  )),
                            ],
                            if (todayTasks.isNotEmpty || earlierTasks.isNotEmpty) ...[
                              const SizedBox(height: 24),
                              Center(
                                child: TextButton.icon(
                                  onPressed: () => _confirmClearCompleted(context),
                                  icon: const Icon(Icons.delete_sweep_outlined, size: 18, color: AppColors.secondary),
                                  label: Text(
                                    'Bersihkan Seluruh Riwayat',
                                    style: AppTypography.captionMeta.copyWith(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmClearCompleted(BuildContext context) {
    ConfirmationDialog.show(
      title: 'Bersihkan Riwayat?',
      message: 'Apakah Anda yakin ingin menghapus seluruh riwayat tugas yang telah selesai?',
      icon: Icons.cleaning_services_rounded,
      confirmText: 'Hapus Semua',
      cancelText: 'Batal',
      isDestructive: true,
      onConfirm: () {
        Get.back();
        controller.clearCompletedTasks();
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../global_widgets/app_header.dart';
import '../../global_widgets/empty_state.dart';
import '../../global_widgets/page_title_row.dart';
import '../../routes/app_routes.dart';
import '../ai/views/tanya_ai_bottom_sheet.dart';
import '../task/task_controller.dart';
import '../task/widgets/task_card.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/pill_tabs.dart';
import 'widgets/stat_grid.dart';

class HomeView extends GetView<TaskController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Fixed AppHeader
            AppHeader(
              onAiTap: () => TanyaAiBottomSheet.show(context),
            ),
            const SizedBox(height: 8),

            // Scrollable Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => controller.loadTasks(),
                color: AppColors.primary,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 120),
                  children: [
                    // 1. Page Title Row
                    PageTitleRow(
                      title: 'Overview',
                      filterText: controller.selectedTimeFilter.value,
                      onFilterTap: () => _showTimeFilterDialog(context),
                    ),
                    const SizedBox(height: 16),

                    // 2. Stat Grid (2x2 Tiles with Sine-wave)
                    const StatGrid(),
                    const SizedBox(height: 20),

                    // 3. Search Bar
                    const HomeSearchBar(),
                    const SizedBox(height: 14),

                    // 4. Category Filter Pill Tabs
                    const PillTabs(),
                    const SizedBox(height: 20),

                    // 5. Task List Sections
                    Obx(() {
                      final highPriority = controller.highPriorityActiveTasks;
                      final upcoming = controller.upcomingActiveTasks;

                      if (highPriority.isEmpty && upcoming.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.margin,
                            vertical: 12,
                          ),
                          child: EmptyStateCard(
                            icon: Icons.checklist_rounded,
                            title: 'Tidak Ada Tugas Aktif',
                            subtitle:
                                'Semua tugas pada kategori ini sudah selesai atau belum ditambahkan.',
                            buttonLabel: 'Tambah Tugas',
                            onButtonTap: () => Get.toNamed(AppRoutes.taskAdd),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section: Prioritas Utama
                            if (highPriority.isNotEmpty) ...[
                              const Text(
                                'PRIORITAS UTAMA',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.secondary,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...highPriority.map((task) => TaskCard(task: task)),
                              const SizedBox(height: 16),
                            ],

                            // Section: Akan Datang
                            if (upcoming.isNotEmpty) ...[
                              const Text(
                                'AKAN DATANG',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.secondary,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...upcoming.map((task) => TaskCard(task: task)),
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

  void _showTimeFilterDialog(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(AppDimens.margin),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.fill1,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Filter Rentang Waktu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ...['Minggu Ini', 'Bulan Ini', 'Semua Waktu'].map((opt) {
              return ListTile(
                title: Text(opt, style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: controller.selectedTimeFilter.value == opt
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () {
                  controller.selectedTimeFilter.value = opt;
                  Get.back();
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}


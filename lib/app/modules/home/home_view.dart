import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_shadows.dart';
import '../../core/theme/app_typography.dart';
import '../../global_widgets/app_header.dart';
import '../../global_widgets/app_search_bar.dart';
import '../../global_widgets/empty_state.dart';
import '../../global_widgets/page_title_row.dart';
import '../../global_widgets/section_label.dart';
import '../../global_widgets/stat_tile.dart';
import '../../routes/app_routes.dart';
import '../ai/views/tanya_ai_bottom_sheet.dart';
import '../main_navigation/main_nav_controller.dart';
import '../task/task_controller.dart';
import '../task/widgets/task_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final TaskController controller;
  final FocusNode _searchFocus = FocusNode();

  static const List<String> _categories = [
    'Semua',
    'Kuliah',
    'Pekerjaan',
    'Pribadi',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<TaskController>()
        ? Get.find<TaskController>()
        : Get.put(TaskController(), permanent: true);
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

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

            // Scrollable Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => controller.loadTasks(),
                color: AppColors.primary,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 120),
                  children: [
                    // 1. Page Title Row
                    const PageTitleRow(title: 'Overview'),
                    const SizedBox(height: 16),

                    // 2. Stat Grid: Home (2 tiles, 88px centered, no wave, no chevron)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
                      child: Obx(() => Row(
                            children: [
                              // Tile 1: Total (Stat Light)
                              Expanded(
                                child: StatTile(
                                  value: controller.totalCount.toString(),
                                  label: 'Total',
                                  backgroundColor: AppColors.statLight,
                                  variant: StatTileVariant.home,
                                  onTap: () => controller.selectedCategory.value = 'Semua',
                                ),
                              ),
                              const SizedBox(width: AppDimens.gutter),
                              // Tile 2: Sudah Selesai (Stat Dark)
                              Expanded(
                                child: StatTile(
                                  value: controller.completedCount.toString(),
                                  label: 'Sudah Selesai',
                                  backgroundColor: AppColors.statDark,
                                  variant: StatTileVariant.home,
                                  onTap: () {
                                    if (Get.isRegistered<MainNavController>()) {
                                      Get.find<MainNavController>().changeTab(1);
                                    }
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(height: 14),

                    // 3. Search Bar (48px, 16px radius, standard shadow)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
                      child: AppSearchBar(
                        placeholder: 'Cari tugas...',
                        focusNode: _searchFocus,
                        onChanged: (val) => controller.searchQuery.value = val,
                        onClear: () => controller.searchQuery.value = '',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 4. Category Filter Dropdown (Opens downwards cleanly)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: PopupMenuButton<String>(
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
                          onSelected: (cat) => controller.selectedCategory.value = cat,
                          itemBuilder: (context) => _categories.map((cat) {
                            final isSelected = cat == controller.selectedCategory.value;
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
                                    Obx(() {
                                      final current = _categories.contains(controller.selectedCategory.value)
                                          ? controller.selectedCategory.value
                                          : 'Semua';
                                      return Text(
                                        current == 'Semua' ? 'Semua Kategori' : current,
                                        style: AppTypography.bodyDefault.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.secondary,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 5. Task List Sections / Empty State
                    Obx(() {
                      final highPriority = controller.highPriorityActiveTasks;
                      final upcoming = controller.upcomingActiveTasks;
                      final isEmpty = highPriority.isEmpty && upcoming.isEmpty;

                      if (isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.margin,
                            vertical: 8,
                          ),
                          child: EmptyStateCard(
                            icon: Icons.check_rounded,
                            title: 'Belum Ada Tugas',
                            subtitle:
                                'Tambahkan tugas pertamamu atau cari tugas yang sudah ada.',
                            primaryButtonLabel: 'Tambah Tugas',
                            onPrimaryTap: () => Get.toNamed(AppRoutes.taskAdd),
                            secondaryButtonLabel: 'Cari Tugas',
                            secondaryButtonIcon: Icons.search_rounded,
                            onSecondaryTap: () {
                              _searchFocus.requestFocus();
                            },
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
                              const SectionLabel(label: 'PRIORITAS UTAMA'),
                              const SizedBox(height: 12),
                              ...highPriority.map((task) => TaskCard(task: task)),
                              const SizedBox(height: 16),
                            ],

                            // Section: Akan Datang
                            if (upcoming.isNotEmpty) ...[
                              const SectionLabel(label: 'AKAN DATANG'),
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
}

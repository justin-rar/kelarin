import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../../../global_widgets/app_header.dart';
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

  static const List<String> _bulanNames = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List.generate(5, (i) => currentYear - i);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
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
                    // 1. Page Title
                    const PageTitleRow(title: 'Rekap'),
                    const SizedBox(height: 16),

                    // 2. StatGrid 2x2
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
                      child: Obx(() => Column(
                            children: [
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
                    const SizedBox(height: 16),

                    // 3. Filter Bulan & Tahun
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
                      child: Obx(() => Row(
                            children: [
                              // Dropdown Bulan
                              Expanded(
                                flex: 3,
                                child: _buildDropdown<int>(
                                  context: context,
                                  icon: Icons.calendar_month_outlined,
                                  label: _bulanNames[controller.completedFilterMonth.value - 1],
                                  items: List.generate(12, (i) => i + 1),
                                  selectedValue: controller.completedFilterMonth.value,
                                  itemLabel: (m) => _bulanNames[m - 1],
                                  onSelected: (m) => controller.completedFilterMonth.value = m,
                                ),
                              ),
                              const SizedBox(width: AppDimens.gutter),
                              // Dropdown Tahun
                              Expanded(
                                flex: 2,
                                child: _buildDropdown<int>(
                                  context: context,
                                  icon: Icons.event_note_outlined,
                                  label: controller.completedFilterYear.value.toString(),
                                  items: years,
                                  selectedValue: controller.completedFilterYear.value,
                                  itemLabel: (y) => y.toString(),
                                  onSelected: (y) => controller.completedFilterYear.value = y,
                                ),
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(height: 20),

                    // 4. Daftar Tugas Selesai / Empty State
                    Obx(() {
                      final todayTasks = controller.todayCompletedTasks;
                      final earlierTasks = controller.earlierCompletedTasks;
                      final isEmpty = todayTasks.isEmpty && earlierTasks.isEmpty;

                      final bulanLabel =
                          _bulanNames[controller.completedFilterMonth.value - 1];
                      final tahunLabel =
                          controller.completedFilterYear.value.toString();

                      if (isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.margin,
                            vertical: 8,
                          ),
                          child: EmptyStateCard(
                            icon: Icons.task_alt_rounded,
                            title: 'Belum Ada Tugas Selesai',
                            subtitle:
                                'Tidak ada tugas yang diselesaikan pada $bulanLabel $tahunLabel.',
                          ),
                        );
                      }

                      return Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: AppDimens.margin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section: Selesai Hari Ini
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

                            // Section: Bulan terpilih
                            if (earlierTasks.isNotEmpty) ...[
                              SectionLabel(
                                label:
                                    '${bulanLabel.toUpperCase()} $tahunLabel',
                                rightText: '${earlierTasks.length} tugas',
                              ),
                              const SizedBox(height: 12),
                              ...earlierTasks.map((task) => TaskCard(
                                    task: task,
                                    isCompletedVariant: true,
                                  )),
                            ],

                            if (todayTasks.isNotEmpty ||
                                earlierTasks.isNotEmpty) ...[
                              const SizedBox(height: 24),
                              Center(
                                child: TextButton.icon(
                                  onPressed: () =>
                                      _confirmClearCompleted(context),
                                  icon: const Icon(
                                      Icons.delete_sweep_outlined,
                                      size: 18,
                                      color: AppColors.secondary),
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

  /// Dropdown pill generik — style sesuai design system
  Widget _buildDropdown<T>({
    required BuildContext context,
    required IconData icon,
    required String label,
    required List<T> items,
    required T selectedValue,
    required String Function(T) itemLabel,
    required void Function(T) onSelected,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: PopupMenuButton<T>(
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
        onSelected: onSelected,
        itemBuilder: (context) => items.map((item) {
          final isSelected = item == selectedValue;
          return PopupMenuItem<T>(
            value: item,
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  itemLabel(item),
                  style: AppTypography.bodyDefault.copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.onSurface,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_rounded,
                      size: 18, color: AppColors.primary),
              ],
            ),
          );
        }).toList(),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
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
                  Icon(icon, size: 16, color: AppColors.secondary),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: AppTypography.bodyDefault.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.keyboard_arrow_down_rounded,
                  size: 20, color: AppColors.secondary),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmClearCompleted(BuildContext context) {
    ConfirmationDialog.show(
      title: 'Bersihkan Riwayat?',
      message:
          'Apakah Anda yakin ingin menghapus seluruh riwayat tugas yang telah selesai?',
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

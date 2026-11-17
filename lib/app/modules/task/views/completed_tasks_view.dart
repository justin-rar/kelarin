import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../global_widgets/app_header.dart';
import '../../../global_widgets/empty_state.dart';
import '../../../global_widgets/page_title_row.dart';
import '../../ai/views/tanya_ai_bottom_sheet.dart';
import '../task_controller.dart';
import '../widgets/task_card.dart';

class CompletedTasksView extends GetView<TaskController> {
  const CompletedTasksView({super.key});

  @override
  Widget build(BuildContext context) {
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
                    PageTitleRow(
                      title: 'Selesai',
                      filterText: 'Bersihkan',
                      onFilterTap: () => _confirmClearCompleted(context),
                    ),
                    const SizedBox(height: 16),

                    Obx(() {
                      final completed = controller.completedTasks;
                      if (completed.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.margin,
                            vertical: 24,
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
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.fill1,
                                borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                              ),
                              child: Text(
                                '${completed.length} tugas telah diselesaikan',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...completed.map((task) => TaskCard(
                              task: task,
                              isCompletedVariant: true,
                            )),
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
    Get.defaultDialog(
      title: 'Bersihkan Riwayat',
      titleStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
      middleText: 'Apakah Anda yakin ingin menghapus seluruh riwayat tugas selesai?',
      middleTextStyle: const TextStyle(fontSize: 14, color: AppColors.secondary),
      radius: 20,
      backgroundColor: AppColors.surface,
      textConfirm: 'Hapus Semua',
      confirmTextColor: AppColors.onPrimary,
      buttonColor: AppColors.primary,
      textCancel: 'Batal',
      cancelTextColor: AppColors.primary,
      onConfirm: () {
        controller.clearCompletedTasks();
        Get.back();
      },
    );
  }
}


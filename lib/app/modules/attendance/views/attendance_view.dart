import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../global_widgets/app_header.dart';
import '../../../global_widgets/empty_state.dart';
import '../../../global_widgets/page_title_row.dart';
import '../../../routes/app_routes.dart';
import '../../ai/views/tanya_ai_bottom_sheet.dart';
import '../attendance_controller.dart';
import '../widgets/attendance_card.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({super.key});

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
                onRefresh: () async => controller.loadAttendances(),
                color: AppColors.primary,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 120),
                  children: [
                    PageTitleRow(
                      title: 'Jadwal Kuliah',
                      filterText: '+ Tambah',
                      onFilterTap: () => Get.toNamed(AppRoutes.attendanceAdd),
                    ),
                    const SizedBox(height: 16),

                    Obx(() {
                      final list = controller.attendances;
                      if (list.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.margin,
                            vertical: 24,
                          ),
                          child: EmptyStateCard(
                            icon: Icons.calendar_today_rounded,
                            title: 'Belum Ada Jadwal Kuliah',
                            subtitle:
                                'Tambahkan mata kuliah teori atau praktikum Anda untuk memantau presensi dan pengingat kelas.',
                            buttonLabel: 'Tambah Jadwal',
                            onButtonTap: () => Get.toNamed(AppRoutes.attendanceAdd),
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
                                '${list.length} Mata Kuliah Terjadwal',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...list.map((att) => AttendanceCard(attendance: att)),
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


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../global_widgets/app_header.dart';
import '../../../global_widgets/confirmation_dialog.dart';
import '../../../global_widgets/course_card.dart';
import '../../../global_widgets/empty_state.dart';
import '../../../global_widgets/page_title_row.dart';
import '../../../routes/app_routes.dart';
import '../attendance_controller.dart';

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
            // Fixed AppHeader (56px, blur + background/90)
            const AppHeader(),
            const SizedBox(height: 8),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => controller.loadAttendances(),
                color: AppColors.primary,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 120),
                  children: [
                    // 1. Page Title Row: Eyebrow "JADWAL KITA" + "Presensi Aktif" + count pill
                    Obx(() => PageTitleRow(
                          eyebrow: 'JADWAL KITA',
                          title: 'Presensi Aktif',
                          countText: '${controller.attendances.length} Mata Kuliah',
                        )),
                    const SizedBox(height: 16),

                    // 2. Active Courses List or Empty State
                    Obx(() {
                      final list = controller.attendances;
                      if (list.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.margin,
                            vertical: 8,
                          ),
                          child: EmptyStateCard(
                            icon: Icons.calendar_today_rounded,
                            showBadgeAddOnIcon: true,
                            title: 'Belum Ada Jadwal Absen',
                            subtitle:
                                'Kamu belum menambahkan mata kuliah atau jadwal presensi. Tambahkan jadwal kuliahmu agar tidak melewatkan waktu absen.',
                            primaryButtonLabel: 'Tambah Absen',
                            onPrimaryTap: () => Get.toNamed(AppRoutes.attendanceAdd),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
                        child: Column(
                          children: list
                              .map((att) => CourseCard(
                                    attendance: att,
                                    onToggleReminder: () => controller.toggleReminder(att.id),
                                    onDelete: () => _confirmDelete(att.id, att.subjectName),
                                  ))
                              .toList(),
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

  void _confirmDelete(String id, String subjectName) {
    ConfirmationDialog.show(
      title: 'Hapus Jadwal?',
      message: 'Apakah Anda yakin ingin menghapus jadwal presensi $subjectName?',
      icon: Icons.event_busy_rounded,
      confirmText: 'Hapus',
      cancelText: 'Batal',
      isDestructive: true,
      onConfirm: () {
        Get.back();
        controller.deleteAttendance(id);
      },
    );
  }
}

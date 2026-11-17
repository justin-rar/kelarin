import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../data/models/attendance_model.dart';
import '../attendance_controller.dart';

class AttendanceCard extends GetView<AttendanceController> {
  final AttendanceModel attendance;

  const AttendanceCard({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    final percent = (attendance.attendedMeetings / attendance.totalMeetings).clamp(0.0, 1.0);
    final isPraktikum = attendance.type.toLowerCase() == 'praktikum';

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.gutter),
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Type Pill (Praktikum black vs Teori fill1) & Reminder Switch / Delete
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 28,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isPraktikum ? AppColors.primary : AppColors.fill1,
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                ),
                child: Center(
                  child: Text(
                    attendance.type,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isPraktikum ? AppColors.onPrimary : AppColors.secondary,
                    ),
                  ),
                ),
              ),

              Row(
                children: [
                  // Reminder indicator toggle
                  InkWell(
                    onTap: () => controller.toggleReminder(attendance.id),
                    borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            attendance.reminderActive
                                ? Icons.notifications_active_rounded
                                : Icons.notifications_off_outlined,
                            size: 16,
                            color: attendance.reminderActive
                                ? AppColors.primary
                                : AppColors.tertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            attendance.reminderActive ? 'Aktif' : 'Nonaktif',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: attendance.reminderActive
                                  ? AppColors.primary
                                  : AppColors.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert_rounded, size: 20, color: AppColors.secondary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusInput),
                    ),
                    onSelected: (val) {
                      if (val == 'delete') {
                        controller.deleteAttendance(attendance.id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                            SizedBox(width: 8),
                            Text('Hapus Jadwal', style: TextStyle(color: AppColors.error, fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Subject Name
          Text(
            attendance.subjectName,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              height: 1.25,
            ),
          ),

          const SizedBox(height: 8),

          // Day, Time & Room
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 14, color: AppColors.secondary),
              const SizedBox(width: 6),
              Text(
                '${attendance.day}, ${attendance.time}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 8),
              const Text('•', style: TextStyle(color: AppColors.secondary)),
              const SizedBox(width: 8),
              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.secondary),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  attendance.room,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Attendance Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kehadiran: ${attendance.attendedMeetings}/${attendance.totalMeetings} Pertemuan',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '${(percent * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Progress Bar Track
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 6,
              backgroundColor: AppColors.statDark,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),

          const SizedBox(height: 14),

          // Check-in / Absen Button
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton.icon(
              onPressed: () => controller.incrementAttendance(attendance.id),
              icon: const Icon(Icons.how_to_reg_rounded, size: 16, color: AppColors.primary),
              label: const Text(
                '+ Catat Hadir Minggu Ini',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.divider, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../../calendar/calendar_controller.dart';
import '../../calendar/views/holiday_list_bottom_sheet.dart';

class HomeCalendarCard extends StatelessWidget {
  const HomeCalendarCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<CalendarController>()
        ? Get.find<CalendarController>()
        : Get.put(CalendarController());

    return Obx(() {
      final nextHoliday = controller.nextHoliday;

      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          boxShadow: const [AppShadows.standard],
          border: Border.all(
            color: AppColors.divider.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => HolidayListBottomSheet.show(context),
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.calendar_month,
                                size: 15,
                                color: AppColors.onPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'KALENDER & HARI LIBUR',
                            style: AppTypography.fieldLabel.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                      if (nextHoliday != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.fill1,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            nextHoliday.countdownText,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Content
                  if (controller.isLoading.value) ...[
                    Row(
                      children: [
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Memeriksa kalender libur via API...',
                          style: AppTypography.captionMeta
                              .copyWith(color: AppColors.secondary),
                        ),
                      ],
                    ),
                  ] else if (nextHoliday != null) ...[
                    Text(
                      nextHoliday.localName,
                      style: AppTypography.cardTitle.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      nextHoliday.formattedDateIndo,
                      style: AppTypography.captionMeta.copyWith(
                        color: AppColors.secondary,
                        fontSize: 12,
                      ),
                    ),
                  ] else ...[
                    Text(
                      'Tidak ada jadwal libur mendatang',
                      style: AppTypography.captionMeta
                          .copyWith(color: AppColors.secondary),
                    ),
                  ],

                  const SizedBox(height: 10),
                  const Divider(height: 1, color: AppColors.divider),
                  const SizedBox(height: 8),

                  // Bottom action row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lihat semua tanggal merah & libur',
                        style: AppTypography.captionMeta.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: AppColors.outline,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

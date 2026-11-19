import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/holiday_model.dart';
import '../calendar_controller.dart';

/// Modal Kalender Interaktif yang menampilkan grid kalender bulanan,
/// indikator tanggal merah resmi via REST API, dan integrasi ke agenda tugas.
class CalendarBottomSheet extends StatelessWidget {
  const CalendarBottomSheet({super.key});

  static void show(BuildContext context) {
    Get.bottomSheet(
      const CalendarBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  static const List<String> _monthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  static const List<String> _weekDayNames = [
    'Min',
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab'
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<CalendarController>()
        ? Get.find<CalendarController>()
        : Get.put(CalendarController());

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.statDark,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),

          // 2. Header: Month Navigation & Today Jump Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
            child: Obx(() {
              final cur = controller.currentMonth.value;
              final monthTitle = '${_monthNames[cur.month - 1]} ${cur.year}';

              return Row(
                children: [
                  // Prev Month Button
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 24),
                    onPressed: controller.prevMonth,
                    tooltip: 'Bulan sebelumnya',
                  ),

                  // Month & Year Title
                  Expanded(
                    child: Center(
                      child: Text(
                        monthTitle,
                        style: AppTypography.cardTitle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),

                  // Next Month Button
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 24),
                    onPressed: controller.nextMonth,
                    tooltip: 'Bulan berikutnya',
                  ),

                  const SizedBox(width: 4),

                  // "Hari Ini" Quick Jump Pill
                  InkWell(
                    onTap: controller.goToToday,
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.fill1,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Hari Ini',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),

          // Live API Status Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981), // Green status dot
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Tanggal merah tersinkronisasi via REST API (date.nager.at)',
                  style: AppTypography.captionMeta.copyWith(
                    color: AppColors.secondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),

          // 3. Scrollable Calendar Body
          Flexible(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.margin, vertical: 12),
              children: [
                // Day of Week Labels Row (Min s.d. Sab)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (i) {
                    final isSunday = i == 0;
                    return SizedBox(
                      width: 40,
                      child: Text(
                        _weekDayNames[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isSunday
                              ? const Color(0xFFDC2626) // Red for Sunday
                              : AppColors.secondary,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),

                // Month Calendar Grid
                Obx(() => _buildCalendarGrid(context, controller)),

                const SizedBox(height: 16),
                const Divider(height: 1, color: AppColors.divider),
                const SizedBox(height: 12),

                // Selected Date Detail Section
                Obx(() => _buildSelectedDateDetail(context, controller)),

                const SizedBox(height: 16),

                // List of Holidays in Selected Month
                Obx(() => _buildMonthHolidaysList(context, controller)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Membangun grid 7-kolom untuk hari-hari dalam bulan aktif
  Widget _buildCalendarGrid(
      BuildContext context, CalendarController controller) {
    final cur = controller.currentMonth.value;
    final totalDays = DateTime(cur.year, cur.month + 1, 0).day;
    final firstDayWeekday = DateTime(cur.year, cur.month, 1).weekday;
    // Minggu = 7 -> offset 0. Senin = 1 -> offset 1, dst.
    final leadingEmpty = firstDayWeekday % 7;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = controller.selectedDate.value;

    final totalCells = leadingEmpty + totalDays;
    final rowCount = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rowCount, (row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (col) {
              final cellIndex = row * 7 + col;
              final dayNumber = cellIndex - leadingEmpty + 1;

              if (dayNumber < 1 || dayNumber > totalDays) {
                return const SizedBox(width: 40, height: 42);
              }

              final cellDate = DateTime(cur.year, cur.month, dayNumber);
              final isToday = cellDate.isAtSameMomentAs(today);
              final isSelected = cellDate.year == selected.year &&
                  cellDate.month == selected.month &&
                  cellDate.day == selected.day;

              final holiday = controller.getHolidayFor(cellDate);
              final isHoliday = holiday != null;
              final isSunday = col == 0;

              return InkWell(
                onTap: () => controller.selectDate(cellDate),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 40,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isToday
                        ? AppColors.primary
                        : (isSelected ? AppColors.fill1 : Colors.transparent),
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected && !isToday
                        ? Border.all(color: AppColors.primary, width: 1.5)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$dayNumber',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: (isToday || isSelected || isHoliday)
                              ? FontWeight.w800
                              : FontWeight.w500,
                          color: isToday
                              ? AppColors.onPrimary
                              : (isHoliday || isSunday
                                  ? const Color(0xFFDC2626) // Red date
                                  : AppColors.onSurface),
                        ),
                      ),
                      // Dot indicator for holiday
                      if (isHoliday)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isToday
                                ? AppColors.onPrimary
                                : const Color(0xFFDC2626),
                            shape: BoxShape.circle,
                          ),
                        )
                      else
                        const SizedBox(height: 4),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  /// Detail untuk tanggal yang sedang diklik/dipilih
  Widget _buildSelectedDateDetail(
      BuildContext context, CalendarController controller) {
    final selected = controller.selectedDate.value;
    final holiday = controller.getHolidayFor(selected);

    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    final dayLabel =
        '${days[selected.weekday - 1]}, ${selected.day} ${months[selected.month - 1]} ${selected.year}';

    if (holiday != null) {
      // Tanggal Merah Terpilih
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2), // Light red background
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFECACA), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.event_busy,
                        size: 16, color: Color(0xFFDC2626)),
                    const SizedBox(width: 6),
                    Text(
                      'TANGGAL MERAH / HARI LIBUR',
                      style: AppTypography.fieldLabel.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFDC2626),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    holiday.countdownText,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              holiday.localName,
              style: AppTypography.cardTitle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF991B1B),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              dayLabel,
              style: AppTypography.captionMeta.copyWith(
                color: const Color(0xFFB91C1C),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.back(); // close modal
                  controller.addHolidayToAgenda(holiday);
                },
                icon: const Icon(Icons.add_task, size: 16),
                label: const Text('Buat Agenda Libur Ini'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Hari Biasa
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.divider.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dayLabel,
                  style: AppTypography.cardTitle.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Hari kerja / perkuliahan aktif (Bukan libur nasional)',
                  style: AppTypography.captionMeta.copyWith(
                    color: AppColors.secondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Get.back();
              Get.toNamed(
                '/task/add',
                arguments: {'initialDate': selected},
              );
            },
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Tambah'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Daftar seluruh hari libur di bulan yang sedang aktif
  Widget _buildMonthHolidaysList(
      BuildContext context, CalendarController controller) {
    final holidays = controller.holidaysInCurrentMonth;
    final cur = controller.currentMonth.value;
    final monthName = _monthNames[cur.month - 1];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'DAFTAR LIBUR DI $monthName'.toUpperCase(),
              style: AppTypography.fieldLabel.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: 0.8,
              ),
            ),
            Text(
              '${holidays.length} Hari',
              style: AppTypography.captionMeta.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (holidays.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                'Tidak ada tanggal merah nasional pada bulan $monthName.',
                style: AppTypography.captionMeta
                    .copyWith(color: AppColors.secondary),
              ),
            ),
          )
        else
          ...holidays.map((h) => _buildMonthHolidayTile(context, h, controller)),
      ],
    );
  }

  Widget _buildMonthHolidayTile(
    BuildContext context,
    HolidayModel holiday,
    CalendarController controller,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.divider.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFDC2626),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              holiday.shortDateIndo,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holiday.localName,
                  style: AppTypography.cardTitle.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  holiday.countdownText,
                  style: AppTypography.captionMeta.copyWith(
                    color: AppColors.secondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_task, size: 18),
            tooltip: 'Tambah ke Agenda',
            onPressed: () {
              Get.back();
              controller.addHolidayToAgenda(holiday);
            },
          ),
        ],
      ),
    );
  }
}

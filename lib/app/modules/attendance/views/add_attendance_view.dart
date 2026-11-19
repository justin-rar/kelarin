import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/attendance_model.dart';
import '../../../data/services/notification_service.dart';
import '../../../global_widgets/app_form_field.dart';
import '../../../global_widgets/form_top_bar.dart';
import '../../../global_widgets/segmented_selector.dart';
import '../../../global_widgets/sticky_action_bar.dart';
import '../../../global_widgets/toggle_row.dart';
import '../attendance_controller.dart';

class AddAttendanceView extends StatefulWidget {
  const AddAttendanceView({super.key});

  @override
  State<AddAttendanceView> createState() => _AddAttendanceViewState();
}

class _AddAttendanceViewState extends State<AddAttendanceView> {
  late final AttendanceController controller;

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController roomController = TextEditingController();

  static const List<String> _allDays = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const List<String> _weekdays = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
  ];

  // Set pilihan hari (default: hari ini)
  late final Set<String> selectedDays;
  TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);

  String selectedType = 'Praktikum';

  // Toggle notifikasi (default hanya saat kuliah dimulai)
  bool notifyAtStart = true;
  bool notify15Min = false;
  bool notify30Min = false;

  final List<String> types = ['Praktikum', 'Teori'];

  @override
  void initState() {
    super.initState();
    // Default ke hari ini agar penambahan jadwal & testing notifikasi langsung relevan hari ini
    final todayIdx = (DateTime.now().weekday - 1).clamp(0, 6);
    selectedDays = {_allDays[todayIdx]};

    controller = Get.isRegistered<AttendanceController>()
        ? Get.find<AttendanceController>()
        : Get.put(AttendanceController(), permanent: true);

    if (Get.isRegistered<NotificationService>()) {
      Get.find<NotificationService>().requestPermissions();
    }
  }

  @override
  void dispose() {
    subjectController.dispose();
    classController.dispose();
    roomController.dispose();
    super.dispose();
  }

  bool get _isAllWeekdaysSelected =>
      _weekdays.every((d) => selectedDays.contains(d)) &&
      selectedDays.length == _weekdays.length;

  void _toggleAllWeekdays() {
    setState(() {
      if (_isAllWeekdaysSelected) {
        selectedDays.clear();
        selectedDays.add('Senin');
      } else {
        selectedDays.clear();
        selectedDays.addAll(_weekdays);
      }
    });
  }

  void _toggleDay(String day) {
    setState(() {
      if (selectedDays.contains(day)) {
        if (selectedDays.length > 1) {
          selectedDays.remove(day);
        }
      } else {
        selectedDays.add(day);
      }
    });
  }

  String _formatSelectedDays() {
    if (_isAllWeekdaysSelected) {
      return 'Senin - Jumat';
    }
    final sorted = _allDays.where((d) => selectedDays.contains(d)).toList();
    return sorted.join(', ');
  }

  /// Menghitung DateTime kemunculan berikutnya dari hari & jam yang dipilih
  DateTime _getNextOccurrenceForDays(Set<String> days, TimeOfDay time) {
    const dayMap = {
      'Senin': 1,
      'Selasa': 2,
      'Rabu': 3,
      'Kamis': 4,
      'Jumat': 5,
      'Sabtu': 6,
      'Minggu': 7,
    };

    final now = DateTime.now();
    DateTime? earliest;

    for (final day in days) {
      final targetWeekday = dayMap[day] ?? 1;
      int daysUntil = (targetWeekday - now.weekday) % 7;
      DateTime candidate = DateTime(
        now.year,
        now.month,
        now.day + daysUntil,
        time.hour,
        time.minute,
      );

      // Jika hari yang dipilih adalah HARI INI:
      if (daysUntil == 0) {
        if (candidate.isBefore(now)) {
          // Jika waktu yang dipilih baru saja terlewat atau dalam toleransi 3 menit (misal saat testing):
          if (now.difference(candidate).inMinutes < 3) {
            candidate = now.add(const Duration(seconds: 2));
          } else {
            // Sudah lewat jamnya hari ini (misal kuliah pagi, sekarang sore): jadwalkan minggu depan
            candidate = candidate.add(const Duration(days: 7));
          }
        }
      } else if (candidate.isBefore(now)) {
        candidate = candidate.add(const Duration(days: 7));
      }

      if (earliest == null || candidate.isBefore(earliest)) {
        earliest = candidate;
      }
    }

    return earliest ?? now.add(const Duration(seconds: 2));
  }

  String _formatNextReminderPreview() {
    if (selectedDays.isEmpty) return '-';
    final next = _getNextOccurrenceForDays(selectedDays, selectedTime);
    final now = DateTime.now();
    final isToday = next.year == now.year && next.month == now.month && next.day == now.day;
    final timeStr = '${next.hour.toString().padLeft(2, '0')}:${next.minute.toString().padLeft(2, '0')} WIB';
    if (isToday) {
      return 'Hari ini, $timeStr';
    }
    const dayNames = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final dayName = dayNames[(next.weekday - 1).clamp(0, 6)];
    final dateStr = '${next.day}/${next.month}';
    return '$dayName ($dateStr), $timeStr';
  }

  void _saveAttendance() {
    final name = subjectController.text.trim();
    if (name.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Nama mata kuliah wajib diisi!',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(milliseconds: 1800),
        backgroundColor: AppColors.primary,
        colorText: AppColors.onPrimary,
      );
      return;
    }

    if (selectedDays.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Pilih minimal satu hari kuliah!',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(milliseconds: 1800),
        backgroundColor: AppColors.primary,
        colorText: AppColors.onPrimary,
      );
      return;
    }

    final dayFormatted = _formatSelectedDays();
    final startTimeStr =
        '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
    final endHour = (selectedTime.hour +
            1 +
            (selectedTime.minute + 40 >= 60 ? 1 : 0)) %
        24;
    final endMinute = (selectedTime.minute + 40) % 60;
    final endTimeStr =
        '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';
    final timeStr = '$startTimeStr - $endTimeStr WIB';

    final roomText = roomController.text.trim().isNotEmpty
        ? roomController.text.trim()
        : 'Lab Komputer';
    final fullRoom = classController.text.trim().isNotEmpty
        ? '$roomText (${classController.text.trim()})'
        : roomText;

    final nextOccurrence = _getNextOccurrenceForDays(selectedDays, selectedTime);

    final newAttendance = AttendanceModel(
      id: 'att_${DateTime.now().millisecondsSinceEpoch}',
      subjectName: name,
      type: selectedType,
      day: dayFormatted,
      time: timeStr,
      room: fullRoom,
      reminderActive: notifyAtStart || notify15Min || notify30Min,
      attendedMeetings: 0,
      totalMeetings: 14,
      scheduledEpoch: nextOccurrence.millisecondsSinceEpoch,
    );

    controller.addAttendance(
      newAttendance,
      notifyAtStart: notifyAtStart,
      notify15Min: notify15Min,
      notify30Min: notify30Min,
    );
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Standard FormTopBar (64px, arrow_back, modal-title)
            const FormTopBar(title: 'Tambah Absen'),

            // Scrollable Form Fields
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.margin,
                  vertical: 16,
                ),
                children: [
                  // 1. Nama Mata Kuliah *
                  AppFormField(
                    label: 'Nama Mata Kuliah',
                    isRequired: true,
                    placeholder: 'Contoh: Pemrograman Web Lanjut',
                    controller: subjectController,
                  ),
                  const SizedBox(height: 16),

                  // 2. Kelas & Ruangan (2 Kolom)
                  Row(
                    children: [
                      Expanded(
                        child: AppFormField(
                          label: 'Kelas',
                          isRequired: true,
                          placeholder: 'Contoh: 4A',
                          controller: classController,
                        ),
                      ),
                      const SizedBox(width: AppDimens.gutter),
                      Expanded(
                        child: AppFormField(
                          label: 'Ruangan',
                          isRequired: true,
                          placeholder: 'Lab Komputer 3',
                          controller: roomController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 3. Pilihan Hari Kuliah (Pilihan hari Senin s/d Jumat & Custom)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'HARI KULIAH *',
                        style: AppTypography.fieldLabel.copyWith(color: AppColors.secondary),
                      ),
                      GestureDetector(
                        onTap: _toggleAllWeekdays,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            _isAllWeekdaysSelected ? 'Reset Hari' : 'Pilih Senin - Jumat',
                            style: AppTypography.captionMeta.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _allDays.map((day) {
                      final isSelected = selectedDays.contains(day);
                      return GestureDetector(
                        onTap: () => _toggleDay(day),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.surface,
                            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.divider,
                              width: 1.2,
                            ),
                            boxShadow: isSelected ? const [AppShadows.standard] : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isSelected) ...[
                                const Icon(
                                  Icons.check_rounded,
                                  size: 14,
                                  color: AppColors.onPrimary,
                                ),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                day,
                                style: AppTypography.captionMeta.copyWith(
                                  color: isSelected
                                      ? AppColors.onPrimary
                                      : AppColors.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // 4. Jam Mulai Kuliah
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'JAM MULAI KULIAH *',
                      style: AppTypography.fieldLabel.copyWith(color: AppColors.secondary),
                    ),
                  ),
                  GestureDetector(
                    onTap: _pickTime,
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppDimens.radiusInput),
                        boxShadow: const [AppShadows.field],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.schedule_outlined,
                            size: 18,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')} WIB',
                              style: AppTypography.bodyDefault.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_down_rounded,
                            color: AppColors.secondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Info preview pengingat berikutnya
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.fill1,
                      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.notifications_active_outlined,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Pengingat berikutnya: ${_formatNextReminderPreview()}',
                            style: AppTypography.captionMeta.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 5. Tipe Kelas *
                  SegmentedSelector(
                    label: 'Tipe Kelas *',
                    options: types,
                    selectedOption: selectedType,
                    columns: 2,
                    onSelected: (t) => setState(() => selectedType = t),
                  ),
                  const SizedBox(height: 16),

                  // 6. Notifikasi Absen (Card 24px with ToggleRows)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'NOTIFIKASI ABSEN',
                      style: AppTypography.fieldLabel.copyWith(color: AppColors.secondary),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                      boxShadow: const [AppShadows.standard],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        ToggleRow(
                          label: 'Saat kuliah dimulai',
                          icon: Icons.notifications_none_rounded,
                          value: notifyAtStart,
                          onChanged: (v) => setState(() => notifyAtStart = v),
                        ),
                        const Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: AppColors.divider,
                        ),
                        ToggleRow(
                          label: '15 menit sebelum',
                          icon: Icons.notifications_none_rounded,
                          value: notify15Min,
                          onChanged: (v) => setState(() => notify15Min = v),
                        ),
                        const Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: AppColors.divider,
                        ),
                        ToggleRow(
                          label: '30 menit sebelum',
                          icon: notify30Min
                              ? Icons.notifications_none_rounded
                              : Icons.notifications_off_outlined,
                          value: notify30Min,
                          onChanged: (v) => setState(() => notify30Min = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Standard StickyActionBar
            StickyActionBar(
              primaryLabel: 'Simpan Absen',
              onPrimaryTap: _saveAttendance,
              secondaryLabel: 'Batal',
              onSecondaryTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }
}

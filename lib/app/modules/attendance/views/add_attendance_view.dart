import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/attendance_model.dart';
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

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);

  String selectedType = 'Praktikum';

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<AttendanceController>()
        ? Get.find<AttendanceController>()
        : Get.put(AttendanceController(), permanent: true);
  }

  // Toggle rows
  bool notifyAtStart = true;
  bool notify15Min = true;
  bool notify30Min = false;

  final List<String> types = ['Praktikum', 'Teori'];

  @override
  void dispose() {
    subjectController.dispose();
    classController.dispose();
    roomController.dispose();
    super.dispose();
  }

  void _saveAttendance() {
    final name = subjectController.text.trim();
    if (name.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Nama mata kuliah wajib diisi!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.primary,
        colorText: AppColors.onPrimary,
      );
      return;
    }

    final dayName = DateFormat('EEEE', 'id_ID').format(selectedDate);
    final startTimeStr = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
    // Estimated end time 1h40m later
    final endHour = (selectedTime.hour + 1 + (selectedTime.minute + 40 >= 60 ? 1 : 0)) % 24;
    final endMinute = (selectedTime.minute + 40) % 60;
    final endTimeStr = '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';
    final timeStr = '$startTimeStr - $endTimeStr WIB';

    final className = classController.text.trim().isNotEmpty
        ? 'Kelas ${classController.text.trim()}'
        : dayName;

    final scheduledDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    final newAttendance = AttendanceModel(
      id: 'att_${DateTime.now().millisecondsSinceEpoch}',
      subjectName: name,
      type: selectedType,
      day: className,
      time: timeStr,
      room: roomController.text.trim().isNotEmpty
          ? roomController.text.trim()
          : 'Lab Komputer',
      reminderActive: notifyAtStart || notify15Min || notify30Min,
      attendedMeetings: 0,
      totalMeetings: 14,
      scheduledEpoch: scheduledDateTime.millisecondsSinceEpoch,
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

                  // 3. Jadwal & Waktu (2 Kolom button style)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'JADWAL & WAKTU',
                      style: AppTypography.fieldLabel.copyWith(color: AppColors.secondary),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _pickDate,
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
                                const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.secondary),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    DateFormat('d MMM yyyy').format(selectedDate),
                                    style: AppTypography.bodyDefault.copyWith(fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimens.gutter),
                      Expanded(
                        child: GestureDetector(
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
                                const Icon(Icons.schedule_outlined, size: 18, color: AppColors.secondary),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')} WIB',
                                    style: AppTypography.bodyDefault.copyWith(fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 4. Tipe Kelas *
                  SegmentedSelector(
                    label: 'Tipe Kelas *',
                    options: types,
                    selectedOption: selectedType,
                    columns: 2,
                    onSelected: (t) => setState(() => selectedType = t),
                  ),
                  const SizedBox(height: 16),

                  // 5. Notifikasi Absen (Card 24px with ToggleRows)
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
                        const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.divider),
                        ToggleRow(
                          label: '15 menit sebelum',
                          icon: Icons.notifications_none_rounded,
                          value: notify15Min,
                          onChanged: (v) => setState(() => notify15Min = v),
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.divider),
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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
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
      setState(() => selectedDate = picked);
    }
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

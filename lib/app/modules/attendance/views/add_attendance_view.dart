import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../data/models/attendance_model.dart';
import '../attendance_controller.dart';

class AddAttendanceView extends StatefulWidget {
  const AddAttendanceView({super.key});

  @override
  State<AddAttendanceView> createState() => _AddAttendanceViewState();
}

class _AddAttendanceViewState extends State<AddAttendanceView> {
  final AttendanceController controller = Get.find<AttendanceController>();

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController roomController = TextEditingController();

  String selectedDay = 'Senin';
  String selectedType = 'Praktikum';
  bool reminderActive = true;

  final List<String> days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
  final List<String> types = ['Praktikum', 'Teori'];

  @override
  void dispose() {
    subjectController.dispose();
    timeController.dispose();
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
        backgroundColor: AppColors.error,
        colorText: AppColors.onError,
      );
      return;
    }

    final newAttendance = AttendanceModel(
      id: 'att_${DateTime.now().millisecondsSinceEpoch}',
      subjectName: name,
      type: selectedType,
      day: selectedDay,
      time: timeController.text.trim().isNotEmpty
          ? timeController.text.trim()
          : '08:00 - 10:00 WIB',
      room: roomController.text.trim().isNotEmpty
          ? roomController.text.trim()
          : 'Lab Komputer',
      reminderActive: reminderActive,
      attendedMeetings: 0,
      totalMeetings: 14,
    );

    controller.addAttendance(newAttendance);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                boxShadow: const [AppColors.cardShadow],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.primary),
                onPressed: () => Get.back(),
              ),
            ),
          ),
        ),
        title: const Text(
          'Tambah Jadwal Presensi',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppDimens.margin),
                children: [
                  _buildLabel('MATA KULIAH *'),
                  _buildTextInput(
                    controller: subjectController,
                    hint: 'Contoh: Pemrograman Aplikasi Mobile',
                    icon: Icons.school_outlined,
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('TIPE KELAS'),
                  Row(
                    children: types.map((t) {
                      final isSelected = selectedType == t;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            onTap: () => setState(() => selectedType = t),
                            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                            child: Container(
                              height: 42,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : AppColors.fill1,
                                borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                              ),
                              child: Text(
                                t,
                                style: TextStyle(
                                  color: isSelected ? AppColors.onPrimary : AppColors.secondary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('HARI KULIAH'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: days.map((d) {
                      final isSelected = selectedDay == d;
                      return ChoiceChip(
                        label: Text(d),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.fill1,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.onPrimary : AppColors.secondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                          side: BorderSide.none,
                        ),
                        showCheckmark: false,
                        onSelected: (_) => setState(() => selectedDay = d),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('JAM KULIAH'),
                  _buildTextInput(
                    controller: timeController,
                    hint: 'Contoh: 08:00 - 10:00 WIB',
                    icon: Icons.access_time_rounded,
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('RUANGAN / LAB'),
                  _buildTextInput(
                    controller: roomController,
                    hint: 'Contoh: Lab Komputer 3',
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 20),

                  // Reminder Toggle
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppDimens.radiusInput),
                      boxShadow: const [AppColors.cardShadow],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.notifications_active_outlined, size: 20, color: AppColors.primary),
                            SizedBox(width: 12),
                            Text(
                              'Aktifkan Pengingat Kelas',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                          ],
                        ),
                        Switch(
                          value: reminderActive,
                          activeThumbColor: AppColors.primary,
                          onChanged: (val) => setState(() => reminderActive = val),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Sticky Bottom
            Container(
              padding: const EdgeInsets.all(AppDimens.margin),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _saveAttendance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  ),
                ),
                child: const Text(
                  'Simpan Jadwal',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.secondary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusInput),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: AppColors.tertiary, fontSize: 13),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

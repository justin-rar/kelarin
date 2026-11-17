import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../data/models/task_model.dart';
import '../task_controller.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final TaskController controller = Get.find<TaskController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);

  String selectedCategory = 'Kuliah';
  String selectedPriority = '= Sedang';

  final List<String> categories = ['Kuliah', 'Pekerjaan', 'Pribadi', 'Kesehatan'];
  final List<String> priorities = ['— Rendah', '= Sedang', '! Tinggi'];

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void _saveTask() {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Judul tugas wajib diisi!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.error,
        colorText: AppColors.onError,
      );
      return;
    }

    final taskDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    final timeString = DateFormat('d MMM, HH:mm').format(taskDateTime);

    final newTask = TaskModel(
      id: 'task_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      dateTime: taskDateTime,
      timeString: timeString,
      location: locationController.text.trim(),
      category: selectedCategory,
      priority: selectedPriority,
      note: noteController.text.trim().isNotEmpty ? noteController.text.trim() : null,
    );

    controller.addTask(newTask);
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
          'Tambah Tugas',
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
                  // 1. Judul Tugas
                  _buildLabel('JUDUL TUGAS *'),
                  _buildTextInput(
                    controller: titleController,
                    hint: 'Contoh: Analisis Kebutuhan Sistem PAM',
                    icon: Icons.title_rounded,
                  ),
                  const SizedBox(height: 20),

                  // 2. Tanggal & Waktu
                  _buildLabel('WAKTU & TENGGAT'),
                  Row(
                    children: [
                      // Date Selector
                      Expanded(
                        child: InkWell(
                          onTap: _pickDate,
                          borderRadius: BorderRadius.circular(AppDimens.radiusInput),
                          child: Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(AppDimens.radiusInput),
                              boxShadow: const [AppColors.cardShadow],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.secondary),
                                const SizedBox(width: 10),
                                Text(
                                  DateFormat('d MMM yyyy').format(selectedDate),
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Time Selector
                      Expanded(
                        child: InkWell(
                          onTap: _pickTime,
                          borderRadius: BorderRadius.circular(AppDimens.radiusInput),
                          child: Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(AppDimens.radiusInput),
                              boxShadow: const [AppColors.cardShadow],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time_rounded, size: 18, color: AppColors.secondary),
                                const SizedBox(width: 10),
                                Text(
                                  selectedTime.format(context),
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 3. Lokasi
                  _buildLabel('LOKASI / RUANGAN'),
                  _buildTextInput(
                    controller: locationController,
                    hint: 'Contoh: Lab Komputer 3 / Online Zoom',
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 20),

                  // 4. Kategori Segmented Selector
                  _buildLabel('KATEGORI'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((cat) {
                      final isSelected = selectedCategory == cat;
                      return ChoiceChip(
                        label: Text(cat),
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
                        onSelected: (_) => setState(() => selectedCategory = cat),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // 5. Prioritas Segmented Selector
                  _buildLabel('TINGKAT PRIORITAS'),
                  Row(
                    children: priorities.map((prio) {
                      final isSelected = selectedPriority == prio;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            onTap: () => setState(() => selectedPriority = prio),
                            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                            child: Container(
                              height: 42,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : AppColors.fill1,
                                borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                              ),
                              child: Text(
                                prio,
                                style: TextStyle(
                                  color: isSelected ? AppColors.onPrimary : AppColors.secondary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // 6. Catatan Tambahan
                  _buildLabel('CATATAN TAMBAHAN (OPSIONAL)'),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppDimens.radiusInput),
                      boxShadow: const [AppColors.cardShadow],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: TextField(
                      controller: noteController,
                      maxLines: 4,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      decoration: const InputDecoration(
                        hintText: 'Tuliskan detail atau instruksi tugas...',
                        hintStyle: TextStyle(color: AppColors.tertiary, fontSize: 13),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Sticky Bottom Actions
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
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _saveTask,
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
                      'Simpan Tugas',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.fill1,
                      foregroundColor: AppColors.secondary,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
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


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/task_model.dart';
import '../../../global_widgets/app_form_field.dart';
import '../../../global_widgets/form_top_bar.dart';
import '../../../global_widgets/segmented_selector.dart';
import '../../../global_widgets/sticky_action_bar.dart';
import '../../../global_widgets/toggle_row.dart';
import '../task_controller.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  late final TaskController controller;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);

  String selectedCategory = 'Kuliah';
  String selectedPriority = '= Sedang';

  // Toggle states
  bool remind1Day = false;
  bool remind12Hours = false;
  bool remind6Hours = false;
  bool remind3Hours = true; // default on in spec
  bool remind1Hour = false;

  final List<String> categories = ['Kuliah', 'Pekerjaan', 'Pribadi', 'Lainnya'];
  final List<String> priorities = ['— Rendah', '= Sedang', '! Tinggi'];

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<TaskController>()
        ? Get.find<TaskController>()
        : Get.put(TaskController(), permanent: true);
  }

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
        backgroundColor: AppColors.primary,
        colorText: AppColors.onPrimary,
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
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Standard FormTopBar (64px, arrow_back, modal-title)
            const FormTopBar(title: 'Tambah Tugas'),

            // Scrollable Form Fields
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.margin,
                  vertical: 16,
                ),
                children: [
                  // 1. Judul Tugas *
                  AppFormField(
                    label: 'Judul Tugas',
                    isRequired: true,
                    placeholder: 'Masukkan judul tugas...',
                    controller: titleController,
                  ),
                  const SizedBox(height: 16),

                  // 2. Kategori *
                  SegmentedSelector(
                    label: 'Kategori *',
                    options: categories,
                    selectedOption: selectedCategory,
                    columns: 2,
                    onSelected: (cat) => setState(() => selectedCategory = cat),
                  ),
                  const SizedBox(height: 16),

                  // 3. Prioritas *
                  SegmentedSelector(
                    label: 'Prioritas *',
                    options: priorities,
                    selectedOption: selectedPriority,
                    columns: 3,
                    onSelected: (p) => setState(() => selectedPriority = p),
                  ),
                  const SizedBox(height: 16),

                  // 4. Tanggal & Waktu (2 Columns)
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'TANGGAL *',
                                style: AppTypography.fieldLabel.copyWith(color: AppColors.secondary),
                              ),
                            ),
                            GestureDetector(
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
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(selectedDate),
                                      style: AppTypography.bodyDefault.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppDimens.gutter),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'WAKTU *',
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
                                    const Icon(Icons.schedule_outlined, size: 18, color: AppColors.secondary),
                                    const SizedBox(width: 10),
                                    Text(
                                      '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')} WIB',
                                      style: AppTypography.bodyDefault.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 5. Lokasi
                  AppFormField(
                    label: 'Lokasi',
                    placeholder: 'Nama gedung, ruangan, atau link meet...',
                    prefixIcon: Icons.location_on_outlined,
                    controller: locationController,
                    linkText: 'Gunakan lokasi saat ini',
                    linkIcon: Icons.near_me_outlined,
                    onLinkTap: () {
                      locationController.text = 'Gedung Kuliah Bersama, R. 302';
                    },
                  ),
                  const SizedBox(height: 16),

                  // 6. Pengingat (Card 24px with ToggleRows)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'PENGINGAT',
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
                          label: '1 hari sebelum',
                          icon: Icons.notifications_none_rounded,
                          value: remind1Day,
                          onChanged: (v) => setState(() => remind1Day = v),
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.divider),
                        ToggleRow(
                          label: '12 jam sebelum',
                          icon: Icons.notifications_none_rounded,
                          value: remind12Hours,
                          onChanged: (v) => setState(() => remind12Hours = v),
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.divider),
                        ToggleRow(
                          label: '6 jam sebelum',
                          icon: Icons.notifications_none_rounded,
                          value: remind6Hours,
                          onChanged: (v) => setState(() => remind6Hours = v),
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.divider),
                        ToggleRow(
                          label: '3 jam sebelum',
                          icon: Icons.notifications_none_rounded,
                          value: remind3Hours,
                          onChanged: (v) => setState(() => remind3Hours = v),
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.divider),
                        ToggleRow(
                          label: '1 jam sebelum',
                          icon: Icons.notifications_none_rounded,
                          value: remind1Hour,
                          onChanged: (v) => setState(() => remind1Hour = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 7. Catatan (Textarea min 110px)
                  AppFormField(
                    label: 'Catatan Tambahan',
                    placeholder: 'Tambahkan instruksi, referensi, atau detail tugas...',
                    controller: noteController,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Standard StickyActionBar (52px black over fill-1 Batal)
            StickyActionBar(
              primaryText: 'Simpan Tugas',
              onPrimaryPressed: _saveTask,
              secondaryText: 'Batal',
              onSecondaryPressed: () => Get.back(),
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

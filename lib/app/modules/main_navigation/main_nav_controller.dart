import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../routes/app_routes.dart';
import '../ai/views/tanya_ai_bottom_sheet.dart';

class MainNavController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void openAddActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDimens.margin),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.fill1,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tambah Aksi Baru',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),

            _buildActionTile(
              icon: Icons.add_task_rounded,
              title: 'Tambah Tugas',
              subtitle: 'Catat tugas kuliah, proyek, atau to-do baru',
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.taskAdd);
              },
            ),
            const SizedBox(height: 8),

            _buildActionTile(
              icon: Icons.calendar_today_outlined,
              title: 'Tambah Jadwal Presensi',
              subtitle: 'Catat jadwal kelas praktikum atau teori',
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.attendanceAdd);
              },
            ),
            const SizedBox(height: 8),

            _buildActionTile(
              icon: Icons.edit_note_rounded,
              title: 'Buat Catatan Baru',
              subtitle: 'Tulis ringkasan materi atau gunakan template',
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.noteAdd);
              },
            ),
            const SizedBox(height: 8),

            _buildActionTile(
              icon: Icons.auto_awesome_rounded,
              title: 'Tanya AI Asisten',
              subtitle: 'Buat rencana belajar cerdas otomatis',
              onTap: () {
                Get.back();
                TanyaAiBottomSheet.show(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.fill1,
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.onPrimary, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.secondary),
            ],
          ),
        ),
      ),
    );
  }
}


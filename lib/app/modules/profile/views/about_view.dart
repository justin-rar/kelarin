import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

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
          'Tentang TaskFlow',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppDimens.margin),
          children: [
            Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: const [AppColors.cardShadow],
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.onPrimary,
                    size: 48,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'TaskFlow (Kelarin)',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 4),
            const Center(
              child: Text(
                'Versi 1.0.0 (Build 2026.11)',
                style: TextStyle(fontSize: 12, color: AppColors.secondary, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                boxShadow: const [AppColors.cardShadow],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deskripsi Proyek',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Aplikasi mobile produktivitas terpadu untuk mahasiswa yang mengintegrasikan manajemen to-do list, rekap riwayat tugas, pelacakan presensi kuliah, editor catatan akademik, dan asisten studi cerdas berbasis AI.',
                    style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.onSurface),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 12),
                  Text(
                    'Teknologi & Standar:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 6),
                  Text('• Flutter 3.47 & Dart 3.13', style: TextStyle(fontSize: 13, color: AppColors.secondary)),
                  Text('• GetX (State, Route & Dependency Management)', style: TextStyle(fontSize: 13, color: AppColors.secondary)),
                  Text('• Hive Local Database & SharedPreferences', style: TextStyle(fontSize: 13, color: AppColors.secondary)),
                  Text('• Google Stitch Monochromatic Design System', style: TextStyle(fontSize: 13, color: AppColors.secondary)),
                  Text('• Plus Jakarta Sans Typography', style: TextStyle(fontSize: 13, color: AppColors.secondary)),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 12),
                  Text(
                    'Mata Kuliah:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 4),
                  Text('Praktikum Pemrograman Aplikasi Mobile', style: TextStyle(fontSize: 13, color: AppColors.secondary)),
                  Text('Semester 5 — UPN "Veteran" Yogyakarta', style: TextStyle(fontSize: 13, color: AppColors.secondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


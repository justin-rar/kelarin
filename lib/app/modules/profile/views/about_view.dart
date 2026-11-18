import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../../../global_widgets/form_top_bar.dart';
import '../../../global_widgets/settings_group.dart';

/// Tentang TaskFlow screen matching Layar 23 (23_tentang.html):
/// - FormTopBar(title: 'Tentang TaskFlow')
/// - Brand Hero Visual (84x84 rounded 22px card with real app logo, "TaskFlow", tagline, and Build pill)
/// - Section "Tentang Aplikasi" Card
/// - Section "INFORMASI & TAUTAN" Group (Syarat & Ketentuan, Kebijakan Privasi, Lisensi, Situs Web)
/// - Section "DUKUNGAN" Group (Hubungi Dukungan, Beri Nilai, Periksa Pembaruan with check_circle)
/// - Copyright footer
class AboutView extends StatelessWidget {
  const AboutView({super.key});

  void _showInfoToast(String message) {
    Get.rawSnackbar(
      message: message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Top Bar
            FormTopBar(
              title: 'Tentang TaskFlow',
              onBack: () => Get.back(),
            ),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.margin,
                  vertical: 8,
                ),
                children: [
                  // Brand Hero Visual
                  Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: const [AppShadows.standard],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Center(
                          child: Image.asset(
                            'assets/logo.png',
                            width: 68,
                            height: 68,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.task_alt,
                              size: 44,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'TaskFlow',
                        style: AppTypography.headlineH1.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kuliah, tugas, dan catatan dalam satu tempat',
                        style: AppTypography.bodyDefault.copyWith(
                          fontSize: 13,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.fill1,
                          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Versi 1.0.0 (Build 240)',
                              style: AppTypography.captionMeta.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Section 1: Tentang Aplikasi Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                      boxShadow: const [AppShadows.standard],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Tentang Aplikasi',
                              style: AppTypography.cardTitle.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'TaskFlow dirancang khusus untuk mahasiswa agar dapat mengelola jadwal kuliah, agenda tugas, presensi harian, serta catatan belajar secara rapi dan produktif dalam satu aplikasi yang terintegrasi.',
                          style: AppTypography.bodyDefault.copyWith(
                            fontSize: 14,
                            color: AppColors.secondary,
                            height: 1.55,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Section 2: INFORMASI & TAUTAN
                  SettingsGroup(
                    title: 'INFORMASI & TAUTAN',
                    items: [
                      SettingsRowItem(
                        icon: Icons.description,
                        title: 'Syarat & Ketentuan Layanan',
                        subtitle: 'Ketentuan penggunaan aplikasi TaskFlow',
                        onTap: () => _showInfoToast('Syarat & Ketentuan Layanan dibuka'),
                      ),
                      SettingsRowItem(
                        icon: Icons.shield,
                        title: 'Kebijakan Privasi',
                        subtitle: 'Perlindungan data dan privasi pengguna',
                        onTap: () => _showInfoToast('Kebijakan Privasi dibuka'),
                      ),
                      SettingsRowItem(
                        icon: Icons.code,
                        title: 'Lisensi Sumber Terbuka',
                        subtitle: 'Komponen dan pustaka pihak ketiga',
                        onTap: () => _showInfoToast('Lisensi Sumber Terbuka dibuka'),
                      ),
                      SettingsRowItem(
                        icon: Icons.language,
                        title: 'Situs Web Resmi',
                        subtitle: 'taskflow.id',
                        trailing: const Icon(
                          Icons.open_in_new,
                          size: 18,
                          color: AppColors.outline,
                        ),
                        onTap: () => _showInfoToast('Membuka https://taskflow.id'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Section 3: DUKUNGAN
                  SettingsGroup(
                    title: 'DUKUNGAN',
                    items: [
                      SettingsRowItem(
                        icon: Icons.mail,
                        title: 'Hubungi Dukungan',
                        subtitle: 'bantuan@taskflow.id',
                        onTap: () => _showInfoToast('Email bantuan: bantuan@taskflow.id'),
                      ),
                      SettingsRowItem(
                        icon: Icons.grade,
                        title: 'Beri Nilai & Ulasan',
                        subtitle: 'Dukung pengembangan aplikasi',
                        onTap: () => _showInfoToast('Terima kasih telah mendukung TaskFlow!'),
                      ),
                      SettingsRowItem(
                        icon: Icons.sync,
                        title: 'Periksa Pembaruan',
                        subtitle: 'Aplikasi Anda menggunakan versi terbaru',
                        trailing: const Icon(
                          Icons.check_circle,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        onTap: () => _showInfoToast('TaskFlow v1.0.0 adalah versi terbaru'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Footer Copyright Note
                  Center(
                    child: Text(
                      '© 2025 TaskFlow Indonesia. Hak Cipta Dilindungi.',
                      style: AppTypography.captionMeta.copyWith(
                        fontSize: 12,
                        color: AppColors.outline,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

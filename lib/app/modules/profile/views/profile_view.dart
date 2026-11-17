import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../routes/app_routes.dart';
import '../profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ProfileController>()) {
      Get.put(ProfileController());
    }

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
          'Profil Mahasiswa',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppDimens.margin),
          children: [
            // User Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                boxShadow: const [AppColors.cardShadow],
              ),
              child: Column(
                children: [
                  Obx(() {
                    final initial = controller.name.value.isNotEmpty
                        ? controller.name.value[0].toUpperCase()
                        : 'T';
                    return Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          initial,
                          style: const TextStyle(
                            color: AppColors.onPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 14),

                  Obx(() => Text(
                    controller.name.value,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  )),
                  const SizedBox(height: 4),

                  Obx(() => Text(
                    '${controller.nim.value} • ${controller.major.value}',
                    style: const TextStyle(fontSize: 13, color: AppColors.secondary, fontWeight: FontWeight.w600),
                  )),
                  const SizedBox(height: 4),

                  Obx(() => Text(
                    controller.email.value,
                    style: const TextStyle(fontSize: 12, color: AppColors.tertiary),
                  )),
                  const SizedBox(height: 16),

                  // Semester Pill
                  Obx(() => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.fill1,
                      borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                    ),
                    child: Text(
                      controller.semester.value,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stat Counter Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.statLight,
                      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${controller.completedTasksCount}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Tugas Selesai',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppDimens.gutter),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.statDark,
                      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${controller.activeTasksCount}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Tugas Aktif',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Settings Menu List
            _buildSectionHeader('PENGATURAN AKUN & SISTEM'),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                boxShadow: const [AppColors.cardShadow],
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Edit Data Profil',
                    subtitle: 'Ubah nama, NIM, email, dan jurusan',
                    onTap: () => Get.toNamed(AppRoutes.profileEdit),
                  ),
                  const Divider(indent: 56),

                  Obx(() => SwitchListTile(
                    secondary: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.fill1,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.primary),
                    ),
                    title: const Text('Kunci Aplikasi PIN', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    subtitle: const Text('Amankan akses saat aplikasi dibuka', style: TextStyle(fontSize: 12, color: AppColors.secondary)),
                    value: controller.isPinEnabled.value,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) => controller.togglePinEnabled(val),
                  )),
                  const Divider(indent: 56),

                  _buildMenuItem(
                    icon: Icons.pin_outlined,
                    title: 'Ubah Kode PIN',
                    subtitle: 'Perbarui 4-digit PIN keamanan',
                    onTap: controller.changePin,
                  ),
                  const Divider(indent: 56),

                  _buildMenuItem(
                    icon: Icons.info_outline_rounded,
                    title: 'Tentang TaskFlow',
                    subtitle: 'Informasi versi dan tim pengembang',
                    onTap: () => Get.toNamed(AppRoutes.profileAbout),
                  ),
                  const Divider(indent: 56),

                  _buildMenuItem(
                    icon: Icons.cleaning_services_outlined,
                    title: 'Bersihkan Seluruh Data',
                    subtitle: 'Hapus data tugas, presensi, dan catatan',
                    iconColor: AppColors.error,
                    textColor: AppColors.error,
                    onTap: () => _confirmReset(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.secondary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = AppColors.primary,
    Color textColor = AppColors.primary,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: AppColors.fill1,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: iconColor),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textColor)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.secondary)),
      trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.tertiary),
    );
  }

  void _confirmReset(BuildContext context) {
    Get.defaultDialog(
      title: 'Bersihkan Semua Data?',
      titleStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
      middleText: 'Seluruh data tugas, presensi, catatan, dan notifikasi akan dihapus secara permanen.',
      middleTextStyle: const TextStyle(fontSize: 13, color: AppColors.secondary),
      radius: 20,
      backgroundColor: AppColors.surface,
      textConfirm: 'Hapus Bersih',
      confirmTextColor: AppColors.onPrimary,
      buttonColor: AppColors.error,
      textCancel: 'Batal',
      cancelTextColor: AppColors.primary,
      onConfirm: () {
        controller.clearAllData();
        Get.back();
      },
    );
  }
}

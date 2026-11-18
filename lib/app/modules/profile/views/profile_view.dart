import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../../../global_widgets/confirmation_dialog.dart';
import '../../../global_widgets/form_top_bar.dart';
import '../../../global_widgets/settings_group.dart';
import '../../../global_widgets/stat_tile.dart';
import '../../../global_widgets/toggle_row.dart';
import '../../../routes/app_routes.dart';
import '../profile_controller.dart';

/// Profil Mahasiswa screen matching Layar 21 (21_profil.html):
/// - FormTopBar(title: 'Profil')
/// - Centered 96x96 Avatar with 32x32 camera badge
/// - Name, email + semester subtitle, and Edit Profil pill button
/// - 2 Stat Tiles (Tugas Selesai in stat-light, Tugas Aktif in stat-dark) with SineWavePainter
/// - KEAMANAN group (Kunci Aplikasi PIN toggle, Ubah PIN row, Notifikasi toggle)
/// - DATA group (Bersihkan Tugas Selesai row, Tentang TaskFlow row)
/// - Full-width "Keluar dari Akun" pill button
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final ProfileController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<ProfileController>()) {
      controller = Get.put(ProfileController());
    } else {
      controller = Get.find<ProfileController>();
    }
  }

  void _showLogoutDialog() {
    ConfirmationDialog.show(
      title: 'Keluar dari Akun',
      message: 'Apakah kamu yakin ingin keluar dari akun ini di perangkat ini?',
      icon: Icons.logout_rounded,
      confirmText: 'Keluar',
      cancelText: 'Batal',
      onConfirm: () {
        Get.back();
        Get.rawSnackbar(
          message: 'Sesi akun berhasil diakhiri',
          snackPosition: SnackPosition.TOP,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Top Bar (64px, back button + centered "Profil" + spacer)
            FormTopBar(
              title: 'Profil',
              onBack: () => Get.back(),
            ),

            // Scrollable Content
            Expanded(
              child: Obx(() {
                final initial = controller.name.value.isNotEmpty
                    ? controller.name.value[0].toUpperCase()
                    : 'T';
                final emailText = controller.email.value.isNotEmpty
                    ? controller.email.value
                    : 'titut.student@taskflow.id';
                final semesterText = controller.semester.value.isNotEmpty
                    ? controller.semester.value
                    : 'Semester 5';

                return ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.margin,
                    vertical: 8,
                  ),
                  children: [
                    // Area Profil Utama (Avatar + Camera + Name + Subtext + Edit Button)
                    Column(
                      children: [
                        // Big 96x96 Avatar with Camera Badge
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: () => controller.showAvatarPickerSheet(context),
                              child: Obx(() {
                                final imagePath = controller.profileImagePath.value;
                                bool hasImage = false;
                                if (imagePath != null && imagePath.isNotEmpty) {
                                  try {
                                    hasImage = File(imagePath).existsSync();
                                  } catch (_) {
                                    hasImage = false;
                                  }
                                }

                                return Container(
                                  width: 96,
                                  height: 96,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [AppShadows.standard],
                                  ),
                                  child: hasImage
                                      ? ClipOval(
                                          child: Image.file(
                                            File(imagePath!),
                                            width: 96,
                                            height: 96,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Center(
                                              child: Text(
                                                initial,
                                                style: AppTypography.headlineH1
                                                    .copyWith(
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppColors.onPrimary,
                                                  height: 1.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            initial,
                                            style: AppTypography.headlineH1.copyWith(
                                              fontSize: 40,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.onPrimary,
                                              height: 1.0,
                                            ),
                                          ),
                                        ),
                                );
                              }),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => controller.showAvatarPickerSheet(context),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: AppColors.surface,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x14000000),
                                        blurRadius: 12,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.photo_camera,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // User Name
                        Text(
                          controller.name.value.isNotEmpty
                              ? controller.name.value
                              : 'Titut',
                          style: AppTypography.headlineH1.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Subtext: email • semester
                        Text(
                          '$emailText • $semesterText',
                          style: AppTypography.captionMeta.copyWith(
                            fontSize: 13,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Edit Profil Pill Button
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.profileEdit),
                          child: Container(
                            height: 36,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: AppColors.fill1,
                              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Edit Profil',
                                  style: AppTypography.buttonText.copyWith(
                                    fontSize: 13,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Two Stat Cards with Wave Decoration
                    Row(
                      children: [
                        Expanded(
                          child: StatTile(
                            value: '${controller.completedTasksCount}',
                            label: 'Tugas Selesai',
                            backgroundColor: AppColors.statLight,
                            variant: StatTileVariant.profile,
                          ),
                        ),
                        const SizedBox(width: AppDimens.gutter),
                        Expanded(
                          child: StatTile(
                            value: '${controller.activeTasksCount}',
                            label: 'Tugas Aktif',
                            backgroundColor: AppColors.statDark,
                            variant: StatTileVariant.profile,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Settings Group 1: KEAMANAN
                    SettingsGroup(
                      title: 'KEAMANAN',
                      items: [
                        SettingsRowItem(
                          icon: Icons.lock,
                          title: 'Kunci Aplikasi PIN',
                          subtitle: 'Amankan data tugas & catatan',
                          trailing: AppSwitch(
                            value: controller.isPinEnabled.value,
                            onChanged: controller.togglePinEnabled,
                          ),
                        ),
                        SettingsRowItem(
                          icon: Icons.pin,
                          title: 'Ubah PIN',
                          subtitle: 'Terakhir diubah 30 hari lalu',
                          onTap: controller.changePin,
                        ),
                        SettingsRowItem(
                          icon: Icons.notifications,
                          title: 'Notifikasi & Pengingat',
                          subtitle: 'Pemberitahuan jadwal & deadline',
                          trailing: AppSwitch(
                            value: controller.isNotificationsEnabled.value,
                            onChanged: controller.toggleNotificationsEnabled,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Settings Group 2: DATA
                    SettingsGroup(
                      title: 'DATA',
                      items: [
                        SettingsRowItem(
                          icon: Icons.cleaning_services,
                          title: 'Bersihkan Tugas Selesai',
                          subtitle: 'Arsipkan atau hapus rekap tugas lama',
                          onTap: controller.clearCompletedTasks,
                        ),
                        SettingsRowItem(
                          icon: Icons.info,
                          title: 'Tentang TaskFlow',
                          subtitle: 'Versi 1.0.0 (Build 240)',
                          onTap: () => Get.toNamed(AppRoutes.profileAbout),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Bottom Action: Keluar dari Akun
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _showLogoutDialog,
                        borderRadius: BorderRadius.circular(AppDimens.radiusFab),
                        child: Container(
                          height: 48,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.fill1,
                            borderRadius: BorderRadius.circular(AppDimens.radiusFab),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.logout,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Keluar dari Akun',
                                style: AppTypography.buttonText.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../../../global_widgets/form_top_bar.dart';
import '../../../global_widgets/sticky_action_bar.dart';
import '../profile_controller.dart';

/// Edit Data Profil screen:
/// - FormTopBar(title: 'Edit Profil')
/// - Avatar Upload Area with Ganti Foto Profil (Kamera / Galeri / Hapus)
/// - Field Nama Lengkap *
/// - Pertanyaan Keamanan Dropdown
/// - Field Informasi Pribadi (Jawaban Keamanan) yang di-hide seperti password
/// - Sticky Bottom Actions (Simpan Perubahan & Batal)
class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late final ProfileController controller;

  late final TextEditingController nameController;
  late final TextEditingController securityAnswerController;
  late String selectedSecurityQuestion;
  bool _obscureSecurityAnswer = true;

  static const List<String> _securityQuestions = [
    'Nama Ibu Kandung',
    'Nama Hewan Peliharaan Pertama',
    'Kota Tempat Lahir',
    'Sekolah Dasar Pertama',
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController(), permanent: true);
    nameController = TextEditingController(
      text: controller.name.value.isNotEmpty ? controller.name.value : 'Titut',
    );
    securityAnswerController = TextEditingController(
      text: controller.securityAnswer.value,
    );
    selectedSecurityQuestion = _securityQuestions.contains(controller.securityQuestion.value)
        ? controller.securityQuestion.value
        : _securityQuestions.first;
  }

  @override
  void dispose() {
    nameController.dispose();
    securityAnswerController.dispose();
    super.dispose();
  }

  void _save() {
    final name = nameController.text.trim();
    final answer = securityAnswerController.text.trim();

    if (name.isEmpty) {
      Get.rawSnackbar(
        message: 'Nama lengkap tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (answer.isEmpty) {
      Get.rawSnackbar(
        message: 'Informasi pribadi tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    controller.updateProfile(
      newName: name,
      newSecurityQuestion: selectedSecurityQuestion,
      newSecurityAnswer: answer,
    );
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            FormTopBar(
              title: 'Edit Profil',
              onBack: () => Get.back(),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: AppDimens.margin,
                  right: AppDimens.margin,
                  top: 8,
                  bottom: 24,
                ),
                child: Column(
                  children: [
                    // Avatar Upload Area
                    Center(
                      child: GestureDetector(
                        onTap: () => controller.showAvatarPickerSheet(context),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Obx(() {
                              final imagePath = controller.profileImagePath.value;
                              final hasImage = imagePath != null &&
                                  imagePath.isNotEmpty &&
                                  File(imagePath).existsSync();
                              final initialLetter = nameController.text.isNotEmpty
                                  ? nameController.text[0].toUpperCase()
                                  : 'T';

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
                                          File(imagePath),
                                          width: 96,
                                          height: 96,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          initialLetter,
                                          style: AppTypography.splashTitle.copyWith(
                                            color: AppColors.onPrimary,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                              );
                            }),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x1F000000),
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => controller.showAvatarPickerSheet(context),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        foregroundColor: AppColors.primary,
                      ),
                      child: Text(
                        'Ganti Foto Profil',
                        style: AppTypography.captionMeta.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Form Fields Stack
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Field 1: Nama Lengkap *
                        _buildInputField(
                          label: 'Nama Lengkap *',
                          icon: Icons.person_outline_rounded,
                          controller: nameController,
                          placeholder: 'Masukkan nama lengkap',
                        ),

                        const SizedBox(height: 20),

                        // Field 2: Pertanyaan Keamanan Dropdown
                        Text(
                          'Pertanyaan Keamanan',
                          style: AppTypography.fieldLabel.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppDimens.radius2Xl),
                            boxShadow: const [AppShadows.field],
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedSecurityQuestion,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.secondary,
                              ),
                              items: _securityQuestions.map((q) {
                                return DropdownMenuItem(
                                  value: q,
                                  child: Text(
                                    q,
                                    style: AppTypography.bodyDefault.copyWith(
                                      color: AppColors.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => selectedSecurityQuestion = val);
                                }
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Field 3: Informasi Pribadi (Jawaban Keamanan yang di-hide)
                        _buildSecureField(
                          label: 'Informasi Pribadi (Pemulihan PIN) *',
                          icon: Icons.lock_outline_rounded,
                          controller: securityAnswerController,
                          placeholder: 'Masukkan informasi rahasia...',
                          isObscured: _obscureSecurityAnswer,
                          onToggleObscure: () {
                            setState(() {
                              _obscureSecurityAnswer = !_obscureSecurityAnswer;
                            });
                          },
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'Informasi pribadi ini digunakan untuk memverifikasi identitas Anda saat lupa PIN.',
                            style: AppTypography.captionMeta.copyWith(
                              fontSize: 11,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Actions
            StickyActionBar(
              primaryLabel: 'Simpan Perubahan',
              onPrimaryTap: _save,
              secondaryLabel: 'Batal',
              onSecondaryTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String placeholder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.fieldLabel.copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimens.radius2Xl),
            boxShadow: const [AppShadows.field],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: AppTypography.bodyDefault.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: AppTypography.bodyDefault.copyWith(
                      color: AppColors.outlineVariant,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecureField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String placeholder,
    required bool isObscured,
    required VoidCallback onToggleObscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.fieldLabel.copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimens.radius2Xl),
            boxShadow: const [AppShadows.field],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: isObscured,
                  style: AppTypography.bodyDefault.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w500,
                    letterSpacing: isObscured ? 2.0 : 0.0,
                  ),
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: AppTypography.bodyDefault.copyWith(
                      color: AppColors.outlineVariant,
                      letterSpacing: 0.0,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onToggleObscure,
                child: Icon(
                  isObscured
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

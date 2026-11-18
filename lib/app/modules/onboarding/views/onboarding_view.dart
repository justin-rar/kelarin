import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<OnboardingController>()) {
      Get.put(OnboardingController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.currentStep.value == 0) {
            return _buildProfileSetupStep(context);
          } else {
            return _buildPinSetupStep(context);
          }
        }),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 0: PROFIL & INFORMASI PEMULIHAN KEAMANAN
  // ---------------------------------------------------------------------------
  Widget _buildProfileSetupStep(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.margin,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // Logo & Header
          Center(
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [AppShadows.standard],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.school_rounded,
                        size: 36,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Selamat Datang di TaskFlow',
                  textAlign: TextAlign.center,
                  style: AppTypography.headlineH1.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Text(
                    'Lengkapi data profil dan pertanyaan keamanan untuk mengamankan akun dan pemulihan PIN.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyDefault.copyWith(
                      color: AppColors.secondary,
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Section 1: Profil Mahasiswa
          Text(
            'DATA PRIBADI MAHASISWA',
            style: AppTypography.fieldLabel.copyWith(
              color: AppColors.secondary,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),

          // Field: Nama Lengkap
          _buildField(
            label: 'Nama Lengkap *',
            icon: Icons.person_outline,
            controller: controller.nameController,
            placeholder: 'Masukkan nama lengkap',
          ),
          const SizedBox(height: 14),

          // Field: NIM
          _buildField(
            label: 'Nomor Induk Mahasiswa (NIM) *',
            icon: Icons.badge_outlined,
            controller: controller.nimController,
            placeholder: 'Contoh: 123220001',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 14),

          // Field: Email
          _buildField(
            label: 'Email Kampus *',
            icon: Icons.mail_outline,
            controller: controller.emailController,
            placeholder: 'nama@student.upnyk.ac.id',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),

          // Field: Program Studi
          _buildField(
            label: 'Program Studi',
            icon: Icons.school_outlined,
            controller: controller.majorController,
            placeholder: 'Sistem Informasi / Informatika',
          ),

          const SizedBox(height: 24),

          // Section 2: Pertanyaan Keamanan untuk Lupa PIN
          Text(
            'PEMULIHAN KUNCI KEAMANAN (LUPA PIN)',
            style: AppTypography.fieldLabel.copyWith(
              color: AppColors.secondary,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),

          // Dropdown Pertanyaan
          Text(
            'Pilih Pertanyaan Keamanan *',
            style: AppTypography.fieldLabel.copyWith(color: AppColors.secondary),
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
                const Icon(Icons.help_outline, size: 20, color: AppColors.secondary),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: controller.selectedSecurityQuestion.value,
                      items: controller.securityQuestions.map((q) {
                        return DropdownMenuItem(
                          value: q,
                          child: Text(
                            q,
                            style: AppTypography.bodyDefault.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          controller.selectedSecurityQuestion.value = val;
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Field Jawaban Keamanan
          _buildField(
            label: 'Jawaban Keamanan *',
            icon: Icons.verified_user_outlined,
            controller: controller.securityAnswerController,
            placeholder: 'Masukkan jawaban keamanan',
          ),

          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Informasi ini akan diminta jika Anda lupa PIN keamanan saat ingin membuka aplikasi.',
              style: AppTypography.captionMeta.copyWith(
                color: AppColors.secondary,
                fontSize: 11,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Next Button
          SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                ),
              ),
              onPressed: controller.proceedToPinSetup,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lanjut: Atur PIN Keamanan',
                    style: AppTypography.buttonText.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String placeholder,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.fieldLabel.copyWith(color: AppColors.secondary),
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
              Icon(icon, size: 20, color: AppColors.secondary),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
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

  // ---------------------------------------------------------------------------
  // STEP 1 & 2: ATUR PIN & KONFIRMASI PIN
  // ---------------------------------------------------------------------------
  Widget _buildPinSetupStep(BuildContext context) {
    final bool isConfirm = controller.currentStep.value == 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
      child: Column(
        children: [
          // Top Back button
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: GestureDetector(
                onTap: controller.backToProfileForm,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    boxShadow: [AppShadows.standard],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const Spacer(flex: 1),

          // Lock Icon Badge
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [AppShadows.standard],
            ),
            child: const Center(
              child: Icon(
                Icons.lock_outline_rounded,
                color: AppColors.onPrimary,
                size: 30,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            isConfirm ? 'Konfirmasi PIN Baru' : 'Atur PIN Keamanan',
            style: AppTypography.headlineH1.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 6),

          // Subtitle
          Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(
              isConfirm
                  ? 'Masukkan kembali 4 digit PIN baru Anda untuk verifikasi keakuratan'
                  : 'Pilih 4 digit kode PIN untuk melindungi akses data tugas dan catatan Anda',
              textAlign: TextAlign.center,
              style: AppTypography.bodyDefault.copyWith(
                fontSize: 13,
                color: AppColors.secondary,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // 4 Dots
          Obx(() {
            final len = controller.enteredPin.value.length;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final bool isFilled = index < len;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? AppColors.primary : AppColors.statDark,
                    boxShadow: isFilled
                        ? const [
                            BoxShadow(
                              color: Color(0x1F000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                );
              }),
            );
          }),

          const SizedBox(height: 12),

          // Error Message
          Obx(() {
            if (controller.pinErrorMessage.value.isEmpty) {
              return const SizedBox(height: 22);
            }
            return Container(
              height: 22,
              alignment: Alignment.center,
              child: Text(
                controller.pinErrorMessage.value,
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }),

          const Spacer(flex: 2),

          // Keypad
          _buildKeypad(),

          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['1', '2', '3'].map((d) => _buildKey(d)).toList(),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['4', '5', '6'].map((d) => _buildKey(d)).toList(),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['7', '8', '9'].map((d) => _buildKey(d)).toList(),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Clear button
            _buildActionKey(
              icon: Icons.clear_rounded,
              onTap: controller.clearPin,
            ),
            _buildKey('0'),
            // Backspace button
            _buildActionKey(
              icon: Icons.backspace_outlined,
              onTap: controller.deletePinDigit,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKey(String digit) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => controller.appendPinDigit(digit),
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        child: Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            boxShadow: [AppShadows.standard],
          ),
          child: Center(
            child: Text(
              digit,
              style: AppTypography.statNumber.copyWith(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionKey({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        child: Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              size: 24,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

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
                  'Selamat Datang di Kelarin',
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

          // Section 1: Data Pribadi
          Text(
            'DATA PRIBADI',
            style: AppTypography.fieldLabel.copyWith(
              color: AppColors.secondary,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),

          // Field: Nama Lengkap *
          _buildField(
            label: 'Nama Lengkap *',
            icon: Icons.person_outline_rounded,
            controller: controller.nameController,
            placeholder: 'Masukkan nama lengkap',
          ),

          const SizedBox(height: 24),

          // Section 2: Pemulihan Kunci Keamanan
          Text(
            'PEMULIHAN KUNCI KEAMANAN',
            style: AppTypography.fieldLabel.copyWith(
              color: AppColors.secondary,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),

          // Dropdown Pertanyaan Keamanan (Dropdown kebawah)
          Text(
            'Pertanyaan Keamanan *',
            style: AppTypography.fieldLabel.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: Obx(
              () => PopupMenuButton<String>(
                position: PopupMenuPosition.under,
                offset: const Offset(0, 6),
                color: AppColors.surface,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                  side: BorderSide(
                    color: AppColors.divider.withValues(alpha: 0.6),
                    width: 1,
                  ),
                ),
                onSelected: (val) {
                  controller.selectedSecurityQuestion.value = val;
                },
                itemBuilder: (context) => controller.securityQuestions.map((q) {
                  final isSelected = q == controller.selectedSecurityQuestion.value;
                  return PopupMenuItem<String>(
                    value: q,
                    height: 44,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            q,
                            style: AppTypography.bodyDefault.copyWith(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                  );
                }).toList(),
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppDimens.radius2Xl),
                    boxShadow: const [AppShadows.field],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.help_outline_rounded,
                        size: 20,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          controller.selectedSecurityQuestion.value,
                          style: AppTypography.bodyDefault.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Field: Informasi Pribadi (Pemulihan PIN) *
          Obx(
            () => _buildSecureField(
              label: 'Informasi Pribadi (Pemulihan PIN) *',
              icon: Icons.lock_outline_rounded,
              controller: controller.securityAnswerController,
              placeholder: 'Masukkan informasi rahasia...',
              isObscured: controller.obscureSecurityAnswer.value,
              onToggleObscure: controller.toggleObscureSecurityAnswer,
            ),
          ),

          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Informasi pribadi ini digunakan untuk memverifikasi identitas Anda saat lupa PIN.',
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
              Icon(icon, size: 20, color: AppColors.secondary),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: isObscured,
                  style: AppTypography.bodyDefault.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
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
              GestureDetector(
                onTap: onToggleObscure,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Icon(
                    isObscured
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: AppColors.secondary,
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

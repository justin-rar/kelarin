import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_shadows.dart';
import '../../core/theme/app_typography.dart';
import 'pin_controller.dart';

class PinView extends GetView<PinController> {
  const PinView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PinController>()) {
      Get.put(PinController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
          child: Column(
            children: [
              // Top Bar for modal / non-auth modes (Back button)
              Obx(() {
                if (controller.isAuthMode && !controller.isForgotPinReset) {
                  return const SizedBox(height: 32);
                }
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: GestureDetector(
                      onTap: () => Get.back(),
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
                );
              }),

              const Spacer(flex: 1),

              // Lock Icon Badge (64x64 Black circle)
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

              // Screen Title
              Obx(() => Text(
                controller.screenTitle,
                textAlign: TextAlign.center,
                style: AppTypography.headlineH1.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              )),

              const SizedBox(height: 6),

              // Screen Subtitle
              Obx(() => Container(
                constraints: const BoxConstraints(maxWidth: 300),
                child: Text(
                  controller.screenSubtitle,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyDefault.copyWith(
                    fontSize: 13,
                    color: AppColors.secondary,
                    height: 1.4,
                  ),
                ),
              )),

              const SizedBox(height: 32),

              // 4 PIN Dots Indicator
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
                if (controller.errorMessage.value.isEmpty) {
                  return const SizedBox(height: 22);
                }
                return Container(
                  height: 22,
                  alignment: Alignment.center,
                  child: Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }),

              // "Lupa PIN?" button
              Obx(() {
                if (!controller.canShowForgotPin) {
                  return const SizedBox(height: 12);
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 8),
                  child: TextButton(
                    onPressed: () => controller.openForgotPinModal(context),
                    child: Text(
                      'Lupa PIN?',
                      style: AppTypography.buttonText.copyWith(
                        fontSize: 13,
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                );
              }),

              const Spacer(flex: 2),

              // Keypad (Numeric 1-9, clear, 0, backspace)
              _buildKeypad(),

              const SizedBox(height: 28),
            ],
          ),
        ),
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
              onTap: controller.deleteDigit,
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
        onTap: () => controller.appendDigit(digit),
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

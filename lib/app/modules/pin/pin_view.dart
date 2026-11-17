import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import 'pin_controller.dart';

class PinView extends GetView<PinController> {
  const PinView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Lock Icon Badge
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.onPrimary,
                    size: 32,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Obx(() => Text(
                controller.isAuthMode.value
                    ? 'Masukkan PIN Keamanan'
                    : 'Atur PIN Keamanan Baru',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              )),

              const SizedBox(height: 8),

              const Text(
                'Akses data tugas dan catatan dilindungi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondary,
                ),
              ),

              const SizedBox(height: 36),

              // 4 PIN Dots Indicator
              Obx(() {
                final len = controller.enteredPin.value.length;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    final bool isFilled = index < len;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isFilled ? AppColors.primary : AppColors.statDark,
                      ),
                    );
                  }),
                );
              }),

              const SizedBox(height: 16),

              // Error Message
              Obx(() {
                if (controller.errorMessage.value.isEmpty) {
                  return const SizedBox(height: 20);
                }
                return SizedBox(
                  height: 20,
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }),

              const Spacer(),

              // Numeric Keypad (1 to 9, clear, 0, delete)
              _buildKeypad(),

              const SizedBox(height: 32),
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
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['4', '5', '6'].map((d) => _buildKey(d)).toList(),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['7', '8', '9'].map((d) => _buildKey(d)).toList(),
        ),
        const SizedBox(height: 16),
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
    return InkWell(
      onTap: () => controller.appendDigit(digit),
      borderRadius: BorderRadius.circular(AppDimens.radiusFull),
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          boxShadow: const [AppColors.cardShadow],
        ),
        child: Center(
          child: Text(
            digit,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionKey({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusFull),
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          color: AppColors.fill1,
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
    );
  }
}


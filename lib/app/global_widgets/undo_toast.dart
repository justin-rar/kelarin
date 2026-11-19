import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';
import '../core/constants/app_shadows.dart';
import '../core/theme/app_typography.dart';

/// Floating Toast matching DESIGN.md:
/// Floats above the BottomNav, 56px high, black, 20px radius, white content.
/// Leading check_circle + 14px bold message, trailing action (Urungkan button or close icon).
class UndoToast {
  UndoToast._();

  static void show({
    required String message,
    String? actionLabel = 'Urungkan',
    VoidCallback? onAction,
    VoidCallback? onUndo, // Backward compatibility alias
    bool showClose = false,
    Duration duration = const Duration(milliseconds: 1800),
  }) {
    final effectiveCallback = onUndo ?? onAction;

    Get.rawSnackbar(
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.only(
        left: AppDimens.margin,
        right: AppDimens.margin,
        bottom: 96, // Floats cleanly above the 72px floating bottom nav
      ),
      padding: EdgeInsets.zero,
      duration: duration,
      messageText: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppDimens.radiusFab),
          boxShadow: const [AppShadows.toast],
        ),
        child: Row(
          children: [
            // Leading check_circle icon
            const Icon(
              Icons.check_circle,
              size: 20,
              color: AppColors.onPrimary,
            ),
            const SizedBox(width: 12),

            // Message text (14px bold white)
            Expanded(
              child: Text(
                message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.buttonText.copyWith(
                  color: AppColors.onPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Trailing action: bold text button or close icon
            if (effectiveCallback != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Get.back();
                  effectiveCallback();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Text(
                    actionLabel ?? 'Urungkan',
                    style: AppTypography.buttonText.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ] else if (showClose) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => Get.back(),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

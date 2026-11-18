import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';
import '../core/constants/app_shadows.dart';
import '../core/theme/app_typography.dart';

/// Redesigned Overlay Popup Konfirmasi matching DESIGN.md:
/// - 40% Scrim with 4px backdrop blur
/// - 24px radius white surface card
/// - Sheet elevation shadow + subtle divider border
/// - 56px circular fill-1 icon badge
/// - Plus Jakarta Sans typography
/// - Side-by-side pill action buttons (Fill-1 for Batal, Primary Black for Konfirmasi)
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final IconData icon;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Lanjutkan',
    this.cancelText = 'Batal',
    this.icon = Icons.help_outline_rounded,
    required this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  static Future<T?> show<T>({
    required String title,
    required String message,
    String confirmText = 'Lanjutkan',
    String cancelText = 'Batal',
    IconData icon = Icons.help_outline_rounded,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
  }) {
    return Get.dialog<T>(
      ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        icon: icon,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDestructive: isDestructive,
      ),
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Scrim 40% black with 4px backdrop blur (matches Aksi Cepat / DESIGN.md)
        Positioned.fill(
          child: GestureDetector(
            onTap: onCancel ?? () => Get.back(),
            behavior: HitTestBehavior.opaque,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  color: AppColors.scrim,
                ),
              ),
            ),
          ),
        ),

        // 2. Centered Floating Confirmation Card
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 340),
              margin: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                boxShadow: const [AppShadows.sheet],
                border: Border.all(
                  color: AppColors.divider.withValues(alpha: 0.6),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon Circle Badge (56x56 px, Fill-1 background)
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: AppColors.fill1,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 26,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Title (Plus Jakarta Sans, 18px, 800)
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTypography.cardTitle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: -0.02 * 18,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Message / Description (Plus Jakarta Sans, 13px, secondary color)
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyDefault.copyWith(
                      color: AppColors.secondary,
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Dual Action Buttons (Side by Side)
                  Row(
                    children: [
                      // Cancel Button (Fill-1 pill)
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: TextButton(
                            onPressed: onCancel ?? () => Get.back(),
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.fill1,
                              foregroundColor: AppColors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                              ),
                            ),
                            child: Text(
                              cancelText,
                              style: AppTypography.buttonText.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Confirm Button (Primary Black pill)
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: onConfirm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                              ),
                            ),
                            child: Text(
                              confirmText,
                              style: AppTypography.buttonText.copyWith(
                                color: AppColors.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

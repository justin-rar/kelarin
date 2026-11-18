import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';
import '../core/constants/app_shadows.dart';
import '../core/theme/app_typography.dart';

/// StickyActionBar fixed at the bottom of forms.
/// Near-white background with blur and upward shadow (AppShadows.stickyActionBar).
/// 52px stacked pills: primary black over fill-1 Batal, plus optional text button.
/// Acuan: design/DESIGN.md
class StickyActionBar extends StatefulWidget {
  final String primaryLabel;
  final VoidCallback onPrimaryTap;
  final String secondaryLabel;
  final VoidCallback? onSecondaryTap;
  final Widget? primaryLeading;
  final String? destructiveLabel;
  final VoidCallback? onDestructiveTap;

  const StickyActionBar({
    super.key,
    String? primaryLabel,
    String? primaryText,
    VoidCallback? onPrimaryTap,
    VoidCallback? onPrimaryPressed,
    String? secondaryLabel,
    String? secondaryText,
    VoidCallback? onSecondaryTap,
    VoidCallback? onSecondaryPressed,
    this.primaryLeading,
    String? destructiveLabel,
    String? destructiveText,
    VoidCallback? onDestructiveTap,
    VoidCallback? onDestructivePressed,
  })  : primaryLabel = primaryLabel ?? primaryText ?? 'Simpan',
        onPrimaryTap = onPrimaryTap ?? onPrimaryPressed ?? _defaultTap,
        secondaryLabel = secondaryLabel ?? secondaryText ?? 'Batal',
        onSecondaryTap = onSecondaryTap ?? onSecondaryPressed,
        destructiveLabel = destructiveLabel ?? destructiveText,
        onDestructiveTap = onDestructiveTap ?? onDestructivePressed;

  static void _defaultTap() {}

  @override
  State<StickyActionBar> createState() => _StickyActionBarState();
}

class _StickyActionBarState extends State<StickyActionBar> {
  bool _primaryPressed = false;
  bool _secondaryPressed = false;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background.withOpacity(0.92),
            boxShadow: const [AppShadows.stickyActionBar],
          ),
          padding: const EdgeInsets.only(
            left: AppDimens.margin,
            right: AppDimens.margin,
            top: 14,
            bottom: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Primary Action Button (52px, primary black)
              GestureDetector(
                onTapDown: (_) => setState(() => _primaryPressed = true),
                onTapUp: (_) => setState(() => _primaryPressed = false),
                onTapCancel: () => setState(() => _primaryPressed = false),
                onTap: widget.onPrimaryTap,
                child: AnimatedScale(
                  scale: _primaryPressed ? 0.98 : 1.0,
                  duration: const Duration(milliseconds: 100),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                      boxShadow: const [AppShadows.cta],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.primaryLeading != null) ...[
                          widget.primaryLeading!,
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.primaryLabel,
                          style: AppTypography.buttonText.copyWith(
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // 2. Secondary Action Button (52px, fill-1 "Batal")
              GestureDetector(
                onTapDown: (_) => setState(() => _secondaryPressed = true),
                onTapUp: (_) => setState(() => _secondaryPressed = false),
                onTapCancel: () => setState(() => _secondaryPressed = false),
                onTap: widget.onSecondaryTap ?? () => Get.back(),
                child: AnimatedScale(
                  scale: _secondaryPressed ? 0.98 : 1.0,
                  duration: const Duration(milliseconds: 100),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.fill1,
                      borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.secondaryLabel,
                      style: AppTypography.buttonText.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),
              ),

              // 3. Optional Destructive Action (Text-only "Hapus Tugas" under Batal)
              if (widget.destructiveLabel != null && widget.onDestructiveTap != null) ...[
                const SizedBox(height: 4),
                TextButton.icon(
                  onPressed: widget.onDestructiveTap,
                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.secondary),
                  label: Text(
                    widget.destructiveLabel!,
                    style: AppTypography.bodyDefault.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

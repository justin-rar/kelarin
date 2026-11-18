import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/theme/app_typography.dart';

/// SectionLabel for group headers across lists.
/// field-label, uppercase, tracking-wider, secondary.
/// Acuan: design/DESIGN.md
class SectionLabel extends StatelessWidget {
  final String label;
  final String? rightText;
  final IconData? leadingIcon;
  final bool isCentered;

  const SectionLabel({
    super.key,
    required this.label,
    this.rightText,
    this.leadingIcon,
    this.isCentered = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCentered) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(
            label.toUpperCase(),
            style: AppTypography.fieldLabel.copyWith(
              color: AppColors.secondary,
              letterSpacing: 1.2,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                Icon(
                  leadingIcon,
                  size: 14,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label.toUpperCase(),
                style: AppTypography.fieldLabel.copyWith(
                  color: AppColors.secondary,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          if (rightText != null)
            Text(
              rightText!,
              style: AppTypography.captionMeta.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}

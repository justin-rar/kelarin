import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';
import '../core/constants/app_shadows.dart';
import '../core/theme/app_typography.dart';

/// Reusable EmptyStateCard matching DESIGN.md:
/// White 24px-radius card, 96px fill-1 circle with 40px icon,
/// card-title heading, 14px secondary body, and action buttons.
class EmptyStateCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? primaryButtonLabel;
  final VoidCallback? onPrimaryTap;
  final String? secondaryButtonLabel;
  final VoidCallback? onSecondaryTap;
  final IconData? secondaryButtonIcon;
  final bool isButtonCompact; // True for Catatan (compact pill), false for full-width
  final bool showBadgeAddOnIcon; // True for Absen empty state

  const EmptyStateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    String? primaryButtonLabel,
    String? buttonLabel, // Backward compatibility alias
    VoidCallback? onPrimaryTap,
    VoidCallback? onButtonTap, // Backward compatibility alias
    this.secondaryButtonLabel,
    this.onSecondaryTap,
    this.secondaryButtonIcon,
    this.isButtonCompact = false,
    this.showBadgeAddOnIcon = false,
  })  : primaryButtonLabel = primaryButtonLabel ?? buttonLabel,
        onPrimaryTap = onPrimaryTap ?? onButtonTap;

  @override
  State<EmptyStateCard> createState() => _EmptyStateCardState();
}

class _EmptyStateCardState extends State<EmptyStateCard> {
  bool _primaryPressed = false;
  bool _secondaryPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        boxShadow: const [AppShadows.standard],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 96px fill-1 circle with icon
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: AppColors.fill1,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    widget.icon,
                    size: 40,
                    color: AppColors.outline,
                  ),
                ),
              ),
              // Optional small black round add badge at bottom-right (for Absen empty state)
              if (widget.showBadgeAddOnIcon)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        size: 16,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: AppTypography.cardTitle.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle / Body
          Text(
            widget.subtitle,
            textAlign: TextAlign.center,
            style: AppTypography.bodyDefault.copyWith(
              color: AppColors.secondary,
              height: 1.4,
            ),
          ),

          // Buttons
          if (widget.primaryButtonLabel != null && widget.onPrimaryTap != null) ...[
            const SizedBox(height: 24),
            if (widget.isButtonCompact)
              // Compact pill button (for Catatan empty state)
              GestureDetector(
                onTapDown: (_) => setState(() => _primaryPressed = true),
                onTapUp: (_) => setState(() => _primaryPressed = false),
                onTapCancel: () => setState(() => _primaryPressed = false),
                onTap: widget.onPrimaryTap,
                child: AnimatedScale(
                  scale: _primaryPressed ? 0.95 : 1.0,
                  duration: const Duration(milliseconds: 100),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                      boxShadow: const [AppShadows.cta],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, size: 18, color: AppColors.onPrimary),
                        const SizedBox(width: 8),
                        Text(
                          widget.primaryButtonLabel!,
                          style: AppTypography.buttonText.copyWith(
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              // Full-width pill buttons (for Home & Absen)
              Column(
                children: [
                  GestureDetector(
                    onTapDown: (_) => setState(() => _primaryPressed = true),
                    onTapUp: (_) => setState(() => _primaryPressed = false),
                    onTapCancel: () => setState(() => _primaryPressed = false),
                    onTap: widget.onPrimaryTap,
                    child: AnimatedScale(
                      scale: _primaryPressed ? 0.98 : 1.0,
                      duration: const Duration(milliseconds: 100),
                      child: Container(
                        height: 48,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                          boxShadow: const [AppShadows.cta],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add, size: 18, color: AppColors.onPrimary),
                            const SizedBox(width: 8),
                            Text(
                              widget.primaryButtonLabel!,
                              style: AppTypography.buttonText.copyWith(
                                color: AppColors.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (widget.secondaryButtonLabel != null &&
                      widget.onSecondaryTap != null) ...[
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTapDown: (_) => setState(() => _secondaryPressed = true),
                      onTapUp: (_) => setState(() => _secondaryPressed = false),
                      onTapCancel: () => setState(() => _secondaryPressed = false),
                      onTap: widget.onSecondaryTap,
                      child: AnimatedScale(
                        scale: _secondaryPressed ? 0.98 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        child: Container(
                          height: 48,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.fill1,
                            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.secondaryButtonIcon != null) ...[
                                Icon(
                                  widget.secondaryButtonIcon,
                                  size: 18,
                                  color: AppColors.secondary,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                widget.secondaryButtonLabel!,
                                style: AppTypography.buttonText.copyWith(
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ],
      ),
    );
  }
}

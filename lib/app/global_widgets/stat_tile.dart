import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';
import '../core/constants/app_shadows.dart';
import '../core/theme/app_typography.dart';
import 'sine_wave_painter.dart';

enum StatTileVariant {
  home, // 88px, centered count + label, no wave, no chevron
  rekap, // 96px, count top-left, wavy line top-right, label bottom-left, chevron bottom-right
  profile, // count + label left-aligned, wavy line top-right, no chevron
}

/// Reusable StatTile supporting Home, Rekap, and Profil variants.
/// Acuan: design/DESIGN.md
class StatTile extends StatefulWidget {
  final String value;
  final String label;
  final Color backgroundColor;
  final StatTileVariant variant;
  final VoidCallback? onTap;

  const StatTile({
    super.key,
    required this.value,
    required this.label,
    required this.backgroundColor,
    this.variant = StatTileVariant.home,
    this.onTap,
  });

  @override
  State<StatTile> createState() => _StatTileState();
}

class _StatTileState extends State<StatTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    switch (widget.variant) {
      case StatTileVariant.home:
        return _buildHomeTile();
      case StatTileVariant.rekap:
        return _buildRekapTile();
      case StatTileVariant.profile:
        return _buildProfileTile();
    }
  }

  Widget _buildHomeTile() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 88,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.value,
                style: AppTypography.statNumber.copyWith(
                  color: AppColors.primary,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.label,
                style: AppTypography.captionMeta.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRekapTile() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 96,
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            boxShadow: const [AppShadows.statTile],
          ),
          child: Stack(
            children: [
              // Value top-left
              Positioned(
                top: 0,
                left: 0,
                child: Text(
                  widget.value,
                  style: AppTypography.statNumber.copyWith(
                    color: AppColors.primary,
                    height: 1.0,
                  ),
                ),
              ),

              // Black wavy line top-right (about 44x14 px, 2px stroke)
              Positioned(
                top: 4,
                right: 0,
                child: CustomPaint(
                  size: const Size(44, 14),
                  painter: SineWavePainter(
                    color: AppColors.primary,
                    strokeWidth: 2.0,
                  ),
                ),
              ),

              // Label bottom-left
              Positioned(
                bottom: 0,
                left: 0,
                child: Text(
                  widget.label,
                  style: AppTypography.captionMeta.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
              ),

              // Chevron bottom-right
              const Positioned(
                bottom: 0,
                right: 0,
                child: Icon(
                  Icons.chevron_right,
                  size: 14,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTile() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 96,
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          ),
          child: Stack(
            children: [
              // Wavy line top-right
              Positioned(
                top: 2,
                right: 0,
                child: CustomPaint(
                  size: const Size(44, 14),
                  painter: SineWavePainter(
                    color: AppColors.primary,
                    strokeWidth: 2.0,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.value,
                    style: AppTypography.statNumber.copyWith(
                      color: AppColors.primary,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.label,
                    style: AppTypography.captionMeta.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

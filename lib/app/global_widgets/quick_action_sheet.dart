import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';
import '../core/constants/app_shadows.dart';
import '../core/theme/app_typography.dart';
import '../routes/app_routes.dart';

/// QuickActionSheet (Aksi Cepat) overlay dengan animasi slide-up + fade.
/// Floats above the bottom navigation bar with a 40% scrim and 4px blur.
/// 28px radius white card, sheet shadow, 3 quick action items.
/// Acuan: design/DESIGN.md
class QuickActionSheet extends StatefulWidget {
  final VoidCallback onClose;

  const QuickActionSheet({super.key, required this.onClose});

  @override
  State<QuickActionSheet> createState() => _QuickActionSheetState();
}

class _QuickActionSheetState extends State<QuickActionSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 40% Scrim dengan blur — fade in
        Positioned.fill(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: GestureDetector(
              onTap: widget.onClose,
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
        ),

        // Floating card — slide-up + fade
        Positioned(
          left: AppDimens.margin,
          right: AppDimens.margin,
          bottom: 104,
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimens.radiusSheet),
                  boxShadow: const [AppShadows.sheet],
                  border: Border.all(color: AppColors.divider.withValues(alpha: 0.6), width: 1),
                ),
                padding: const EdgeInsets.all(AppDimens.spaceLg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'AKSI CEPAT',
                          style: AppTypography.fieldLabel.copyWith(
                            color: AppColors.primary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        Text(
                          'Pilih tindakan',
                          style: AppTypography.captionMeta.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AppColors.divider),
                    const SizedBox(height: 8),

                    _buildActionRow(
                      icon: Icons.task_alt,
                      title: 'Tambah Tugas',
                      subtitle: 'Buat to-do & agenda kuliah',
                      delay: 0,
                      onTap: () {
                        widget.onClose();
                        Get.toNamed(AppRoutes.taskAdd);
                      },
                    ),
                    const SizedBox(height: 6),

                    _buildActionRow(
                      icon: Icons.calendar_today,
                      title: 'Tambah Absen',
                      subtitle: 'Pengingat presensi kelas',
                      delay: 40,
                      onTap: () {
                        widget.onClose();
                        Get.toNamed(AppRoutes.attendanceAdd);
                      },
                    ),
                    const SizedBox(height: 6),

                    _buildActionRow(
                      icon: Icons.edit_note,
                      title: 'Catatan Baru',
                      subtitle: 'Tulis materi atau ide',
                      delay: 80,
                      onTap: () {
                        widget.onClose();
                        Get.toNamed(AppRoutes.noteAdd);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required int delay,
    required VoidCallback onTap,
  }) {
    return _ActionRowWidget(
      icon: icon,
      title: title,
      subtitle: subtitle,
      parentAnim: _ctrl,
      delay: delay,
      onTap: onTap,
    );
  }
}

class _ActionRowWidget extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final AnimationController parentAnim;
  final int delay;
  final VoidCallback onTap;

  const _ActionRowWidget({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.parentAnim,
    required this.delay,
    required this.onTap,
  });

  @override
  State<_ActionRowWidget> createState() => _ActionRowWidgetState();
}

class _ActionRowWidgetState extends State<_ActionRowWidget> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              // 44px fill-1 icon circle
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.fill1,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 14),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: AppTypography.buttonText.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style: AppTypography.captionMeta.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Light chevron
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


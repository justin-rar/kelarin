import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';
import '../core/constants/app_shadows.dart';
import '../core/theme/app_typography.dart';
import '../routes/app_routes.dart';

/// QuickActionSheet (Aksi Cepat) overlay.
/// Animasi backdrop blur fade instan dan slide halus pada kartu.
class QuickActionSheet extends StatefulWidget {
  final VoidCallback onClose;

  const QuickActionSheet({super.key, required this.onClose});

  @override
  State<QuickActionSheet> createState() => _QuickActionSheetState();
}

class _QuickActionSheetState extends State<QuickActionSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _cardController;
  late final Animation<Offset> _cardSlideAnimation;

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _cardSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutCubic,
    ));
    _cardController.forward();
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 40% Scrim dengan blur statis instan
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onClose,
            behavior: HitTestBehavior.opaque,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.5, sigmaY: 5.5),
                child: Container(color: AppColors.scrim),
              ),
            ),
          ),
        ),

        // Floating card dengan animasi slide halus
        Positioned(
          left: AppDimens.margin,
          right: AppDimens.margin,
          bottom: 104,
          child: SlideTransition(
            position: _cardSlideAnimation,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.radiusSheet),
                boxShadow: const [AppShadows.sheet],
                border: Border.all(
                    color: AppColors.divider.withValues(alpha: 0.6), width: 1),
              ),
              padding: const EdgeInsets.all(AppDimens.spaceLg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                        style: AppTypography.captionMeta
                            .copyWith(color: AppColors.secondary),
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
      ],
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return _ActionRowWidget(
        icon: icon, title: title, subtitle: subtitle, onTap: onTap);
  }
}

class _ActionRowWidget extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionRowWidget({
    required this.icon,
    required this.title,
    required this.subtitle,
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
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.fill1,
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
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
                      style: AppTypography.captionMeta
                          .copyWith(color: AppColors.secondary),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  size: 18, color: AppColors.outline),
            ],
          ),
        ),
      ),
    );
  }
}



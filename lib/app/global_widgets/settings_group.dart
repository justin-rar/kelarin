import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';
import '../core/constants/app_shadows.dart';
import '../core/theme/app_typography.dart';
import 'section_label.dart';

class SettingsRowItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsRowItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });
}

/// SettingsGroup used on Profil and Tentang screens.
/// Renders an uppercase section label over a white 24px radius card.
/// Inside: 36px fill-1 icon circles, 14px bold titles, 12px secondary subtitles, 1px dividers.
class SettingsGroup extends StatelessWidget {
  final String title;
  final List<SettingsRowItem> items;

  const SettingsGroup({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(label: title),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            boxShadow: const [AppShadows.standard],
          ),
          child: Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isLast = index == items.length - 1;

              return Column(
                children: [
                  _SettingsRowWidget(item: item),
                  if (!isLast) const Divider(height: 1, color: AppColors.divider),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _SettingsRowWidget extends StatefulWidget {
  final SettingsRowItem item;

  const _SettingsRowWidget({required this.item});

  @override
  State<_SettingsRowWidget> createState() => _SettingsRowWidgetState();
}

class _SettingsRowWidgetState extends State<_SettingsRowWidget> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.item.onTap != null) setState(() => _pressed = true);
      },
      onTapUp: (_) {
        if (widget.item.onTap != null) setState(() => _pressed = false);
      },
      onTapCancel: () {
        if (widget.item.onTap != null) setState(() => _pressed = false);
      },
      onTap: widget.item.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // 36px fill-1 icon circle
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.fill1,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.item.icon,
                  size: 18,
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
                      widget.item.title,
                      style: AppTypography.bodyDefault.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    if (widget.item.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.item.subtitle!,
                        style: AppTypography.captionMeta.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Trailing action or chevron
              if (widget.item.trailing != null)
                widget.item.trailing!
              else if (widget.item.onTap != null)
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

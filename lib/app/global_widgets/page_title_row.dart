import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';
import '../core/constants/app_shadows.dart';
import '../core/theme/app_typography.dart';

/// PageTitleRow for screens header row (headline-h1 + optional trailing pill dropdown or count pill).
/// Acuan: design/DESIGN.md
class PageTitleRow extends StatefulWidget {
  final String title;
  final String? filterText;
  final VoidCallback? onFilterTap;
  final bool isCountPill; // If true, renders a static fill-1 count pill (e.g. Absen: "3 Mata Kuliah")
  final String? countText; // Dedicated count text
  final String? eyebrow; // Optional uppercase eyebrow (e.g. Absen: "JADWAL KITA")

  const PageTitleRow({
    super.key,
    required this.title,
    this.filterText,
    this.onFilterTap,
    this.isCountPill = false,
    this.countText,
    this.eyebrow,
  });

  @override
  State<PageTitleRow> createState() => _PageTitleRowState();
}

class _PageTitleRowState extends State<PageTitleRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveCountText = widget.countText ?? (widget.isCountPill ? widget.filterText : null);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Left: Title (with optional eyebrow above)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.eyebrow != null) ...[
                  Text(
                    widget.eyebrow!.toUpperCase(),
                    style: AppTypography.fieldLabel.copyWith(
                      color: AppColors.secondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  widget.title,
                  style: AppTypography.headlineH1.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          // Right: Dropdown Pill or Count Pill
          if (effectiveCountText != null)
            Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.fill1,
                borderRadius: BorderRadius.circular(AppDimens.radiusFull),
              ),
              child: Text(
                effectiveCountText,
                style: AppTypography.captionMeta.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
            )
          else if (widget.filterText != null)
            GestureDetector(
              onTapDown: (_) => setState(() => _pressed = true),
              onTapUp: (_) => setState(() => _pressed = false),
              onTapCancel: () => setState(() => _pressed = false),
              onTap: widget.onFilterTap,
              child: AnimatedScale(
                scale: _pressed ? 0.95 : 1.0,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                    boxShadow: const [AppShadows.standard],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.filterText!,
                        style: AppTypography.captionMeta.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.expand_more,
                        size: 16,
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

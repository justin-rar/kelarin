import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';
import '../core/constants/app_shadows.dart';
import '../core/theme/app_typography.dart';

class PillTabItem {
  final String label;
  final int? count;
  final String id;

  const PillTabItem({
    required this.label,
    this.count,
    required this.id,
  });

  String get displayText => count != null ? '$label ($count)' : label;
}

/// PillTabs horizontal selector.
/// 36px high, 8px gap, button-text (14px bold).
/// Selected: primary black fill, white text, standard shadow.
/// Unselected: fill-1 background, secondary text.
/// Acuan: design/DESIGN.md
class PillTabs extends StatefulWidget {
  final List<PillTabItem> items;
  final String selectedId;
  final ValueChanged<String> onSelected;
  final bool isCompact; // For 2-pill layout (e.g. Notifikasi)

  const PillTabs({
    super.key,
    required this.items,
    required this.selectedId,
    required this.onSelected,
    this.isCompact = false,
  });

  @override
  State<PillTabs> createState() => _PillTabsState();
}

class _PillTabsState extends State<PillTabs> {
  String? _pressedId;

  @override
  Widget build(BuildContext context) {
    if (widget.isCompact) {
      return Row(
        children: widget.items.map((item) {
          final isSelected = item.id == widget.selectedId;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildPill(item, isSelected),
          );
        }).toList(),
      );
    }

    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
        scrollDirection: Axis.horizontal,
        itemCount: widget.items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = widget.items[index];
          final isSelected = item.id == widget.selectedId;
          return _buildPill(item, isSelected);
        },
      ),
    );
  }

  Widget _buildPill(PillTabItem item, bool isSelected) {
    final isPressed = _pressedId == item.id;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressedId = item.id),
      onTapUp: (_) => setState(() => _pressedId = null),
      onTapCancel: () => setState(() => _pressedId = null),
      onTap: () => widget.onSelected(item.id),
      child: AnimatedScale(
        scale: isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.fill1,
            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            boxShadow: isSelected ? const [AppShadows.standard] : null,
          ),
          child: Text(
            item.displayText,
            style: AppTypography.buttonText.copyWith(
              color: isSelected ? AppColors.onPrimary : AppColors.secondary,
            ),
          ),
        ),
      ),
    );
  }
}

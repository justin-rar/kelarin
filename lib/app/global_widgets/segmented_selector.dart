import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';
import '../core/constants/app_shadows.dart';
import '../core/theme/app_typography.dart';

/// Reusable segmented selector matching DESIGN.md:
/// 48px high options, 16px radius, 8px gap.
/// Selected: primary black with white text and selectedSegment shadow.
/// Unselected: fill-1 with secondary text.
/// Acuan: design/DESIGN.md
class SegmentedSelector extends StatelessWidget {
  final String? label;
  final List<String> options;
  final String selectedOption;
  final ValueChanged<String> onSelected;
  final int columns; // 2, 3, or grid 2x2

  const SegmentedSelector({
    super.key,
    this.label,
    required this.options,
    required this.selectedOption,
    required this.onSelected,
    this.columns = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 2),
            child: Text(
              label!.toUpperCase(),
              style: AppTypography.fieldLabel.copyWith(
                color: AppColors.secondary,
                letterSpacing: 0.8,
              ),
            ),
          ),

        // Grid / Row Layout
        if (columns == 2 && options.length == 4)
          // 2x2 Grid (e.g. Tipe Tugas)
          Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildOption(options[0])),
                  const SizedBox(width: 8),
                  Expanded(child: _buildOption(options[1])),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildOption(options[2])),
                  const SizedBox(width: 8),
                  Expanded(child: _buildOption(options[3])),
                ],
              ),
            ],
          )
        else
          // 1 Row with N columns (e.g. 3 columns Priority, or 2 columns Tipe Kelas)
          Row(
            children: List.generate(options.length, (index) {
              final opt = options[index];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < options.length - 1 ? 8.0 : 0.0,
                  ),
                  child: _buildOption(opt),
                ),
              );
            }),
          ),
      ],
    );
  }

  Widget _buildOption(String option) {
    final isSelected = selectedOption == option;

    return _SegmentedOptionItem(
      label: option,
      isSelected: isSelected,
      onTap: () => onSelected(option),
    );
  }
}

class _SegmentedOptionItem extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SegmentedOptionItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SegmentedOptionItem> createState() => _SegmentedOptionItemState();
}

class _SegmentedOptionItemState extends State<_SegmentedOptionItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.isSelected ? AppColors.primary : AppColors.fill1,
            borderRadius: BorderRadius.circular(AppDimens.radius2Xl),
            boxShadow: widget.isSelected ? const [AppShadows.selectedSegment] : null,
          ),
          child: Text(
            widget.label,
            style: AppTypography.buttonText.copyWith(
              color: widget.isSelected ? AppColors.onPrimary : AppColors.secondary,
            ),
          ),
        ),
      ),
    );
  }
}

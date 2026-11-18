import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';
import '../core/constants/app_shadows.dart';
import '../core/theme/app_typography.dart';

/// AppSearchBar shared across Home, Rekap, and Catatan.
/// 48px high, surface, 16px radius, standard shadow.
/// 20px search icon in outline, 12px text.
/// Acuan: design/DESIGN.md
class AppSearchBar extends StatefulWidget {
  final String placeholder;
  final String initialValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const AppSearchBar({
    super.key,
    required this.placeholder,
    this.initialValue = '',
    this.onChanged,
    this.onClear,
    this.controller,
    this.focusNode,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _controller;
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController(text: widget.initialValue);
      _isInternalController = true;
    }
  }

  @override
  void dispose() {
    if (_isInternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radius2Xl),
        boxShadow: const [AppShadows.standard],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.search,
            size: 20,
            color: AppColors.outline,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: widget.focusNode,
              onChanged: (val) {
                setState(() {});
                widget.onChanged?.call(val);
              },
              style: AppTypography.bodyDefault.copyWith(
                color: AppColors.onSurface,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: AppTypography.captionMeta.copyWith(
                  color: AppColors.outline,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _controller.clear();
                setState(() {});
                widget.onChanged?.call('');
                widget.onClear?.call();
              },
              child: const Icon(
                Icons.cancel,
                size: 18,
                color: AppColors.outline,
              ),
            ),
        ],
      ),
    );
  }
}

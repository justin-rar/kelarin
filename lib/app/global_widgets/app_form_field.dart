import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';
import '../core/constants/app_shadows.dart';
import '../core/theme/app_typography.dart';

/// Reusable form input field matching DESIGN.md:
/// 52px high (textarea min 110px), 16px radius, field shadow,
/// 14px value text, outline placeholder, 12px 700 field-label above.
class AppFormField extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final IconData? leadingIcon;
  final bool isRequired;
  final bool isTextarea;
  final int maxLines;
  final String? helperText;
  final Widget? trailingLink;
  final String? linkText;
  final IconData? linkIcon;
  final VoidCallback? onLinkTap;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppFormField({
    super.key,
    required this.label,
    required this.placeholder,
    this.controller,
    this.initialValue,
    this.onChanged,
    IconData? leadingIcon,
    IconData? prefixIcon,
    this.isRequired = false,
    bool? isTextarea,
    this.maxLines = 1,
    this.helperText,
    this.trailingLink,
    this.linkText,
    this.linkIcon,
    this.onLinkTap,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
  })  : leadingIcon = leadingIcon ?? prefixIcon,
        isTextarea = isTextarea ?? (maxLines > 1);

  @override
  State<AppFormField> createState() => _AppFormFieldState();
}

class _AppFormFieldState extends State<AppFormField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelText = widget.isRequired ? '${widget.label} *' : widget.label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label (12px, 700, secondary, 8px above field)
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 2),
          child: Text(
            labelText.toUpperCase(),
            style: AppTypography.fieldLabel.copyWith(
              color: AppColors.secondary,
              letterSpacing: 0.8,
            ),
          ),
        ),

        // Input Container
        Container(
          constraints: BoxConstraints(
            minHeight: widget.isTextarea ? 110 : 52,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimens.radiusInput),
            boxShadow: [
              _isFocused ? AppShadows.fieldFocus : AppShadows.field,
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: widget.isTextarea ? 14 : 0,
          ),
          alignment: widget.isTextarea ? Alignment.topLeft : Alignment.centerLeft,
          child: Row(
            crossAxisAlignment:
                widget.isTextarea ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              if (widget.leadingIcon != null) ...[
                Padding(
                  padding: EdgeInsets.only(top: widget.isTextarea ? 2 : 0),
                  child: Icon(
                    widget.leadingIcon,
                    size: 18,
                    color: _isFocused ? AppColors.primary : AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  readOnly: widget.readOnly,
                  onTap: widget.onTap,
                  onChanged: widget.onChanged,
                  maxLines: widget.isTextarea ? widget.maxLines : 1,
                  keyboardType: widget.keyboardType,
                  style: AppTypography.bodyDefault.copyWith(
                    color: AppColors.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: AppTypography.bodyDefault.copyWith(
                      color: AppColors.outline,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Helper text below field
        if (widget.helperText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              widget.helperText!,
              style: AppTypography.captionMeta.copyWith(
                color: AppColors.secondary,
              ),
            ),
          ),
        ],

        // Trailing link below field (e.g. "Gunakan lokasi saat ini")
        if (widget.trailingLink != null) ...[
          const SizedBox(height: 6),
          widget.trailingLink!,
        ] else if (widget.linkText != null) ...[
          const SizedBox(height: 6),
          GestureDetector(
            onTap: widget.onLinkTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.linkIcon != null) ...[
                    Icon(widget.linkIcon, size: 14, color: AppColors.secondary),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    widget.linkText!,
                    style: AppTypography.captionMeta.copyWith(
                      color: AppColors.secondary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

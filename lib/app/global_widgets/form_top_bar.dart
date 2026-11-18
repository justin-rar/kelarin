import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';
import '../core/constants/app_shadows.dart';
import '../core/theme/app_typography.dart';

/// FormTopBar for form, detail, profile, and modal screens.
/// Fixed 64px, translucent background with blur and hairline shadow.
/// 44px white circle back button with arrow_back, centered modal-title, 44px spacer/action.
/// Acuan: design/DESIGN.md
class FormTopBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final Widget? trailingAction;

  const FormTopBar({
    super.key,
    required this.title,
    this.subtitle,
    VoidCallback? onBack,
    VoidCallback? onBackTap,
    Widget? trailingAction,
    Widget? trailing,
  })  : onBack = onBackTap ?? onBack,
        trailingAction = trailingAction ?? trailing;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  State<FormTopBar> createState() => _FormTopBarState();
}

class _FormTopBarState extends State<FormTopBar> {
  bool _backPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.90),
        boxShadow: const [AppShadows.topBar],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 44px white circle back button with standard arrow_back
                GestureDetector(
                  onTapDown: (_) => setState(() => _backPressed = true),
                  onTapUp: (_) => setState(() => _backPressed = false),
                  onTapCancel: () => setState(() => _backPressed = false),
                  onTap: widget.onBack ?? () => Get.back(),
                  child: AnimatedScale(
                    scale: _backPressed ? 0.92 : 1.0,
                    duration: const Duration(milliseconds: 100),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        boxShadow: [AppShadows.standard],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),

                // Centered modal-title (18px, w700, primary)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: AppTypography.modalTitle.copyWith(
                          color: AppColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle!,
                          style: AppTypography.captionMeta.copyWith(
                            color: AppColors.secondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),

                // 44px Right slot: Trailing Action or Invisible Spacer
                SizedBox(
                  width: 44,
                  height: 44,
                  child: widget.trailingAction ?? const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

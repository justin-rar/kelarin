import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';
import '../core/constants/app_shadows.dart';
import '../core/theme/app_typography.dart';

/// Reusable ChatBubble matching DESIGN.md:
/// User bubble: right-aligned, black, white text, rounded-br-sm (4px) tail.
/// AI bubble: left-aligned with 28px sparkle avatar, white, on-surface text, rounded-bl-sm (4px) tail.
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final String timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    if (isUser) {
      return _buildUserBubble();
    } else {
      return _buildAiBubble();
    }
  }

  Widget _buildUserBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 280),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimens.radius2Xl),
                topRight: Radius.circular(AppDimens.radius2Xl),
                bottomLeft: Radius.circular(AppDimens.radius2Xl),
                bottomRight: Radius.circular(AppDimens.radiusSm), // 4px tail
              ),
            ),
            child: Text(
              message,
              style: AppTypography.bodyDefault.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                timestamp,
                style: AppTypography.captionMeta.copyWith(
                  color: AppColors.outline,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.done_all,
                size: 14,
                color: AppColors.outline,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAiBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 28px black AI avatar with sparkle
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.auto_awesome,
                    size: 14,
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // AI bubble
              Flexible(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 280),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimens.radius2Xl),
                      topRight: Radius.circular(AppDimens.radius2Xl),
                      bottomLeft: Radius.circular(AppDimens.radiusSm), // 4px tail
                      bottomRight: Radius.circular(AppDimens.radius2Xl),
                    ),
                    boxShadow: [AppShadows.standard],
                  ),
                  child: Text(
                    message,
                    style: AppTypography.bodyDefault.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Text(
              timestamp,
              style: AppTypography.captionMeta.copyWith(
                color: AppColors.outline,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

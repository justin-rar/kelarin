import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';
import '../core/constants/app_shadows.dart';
import '../core/theme/app_typography.dart';
import '../data/services/storage_service.dart';
import '../modules/notification/notification_controller.dart';
import '../routes/app_routes.dart';

/// AppHeader for main tab screens (Home, Selesai, Absen, Catatan).
/// Fixed 56px height, 20px side padding, background/90 with blur filter.
/// Acuan: design/DESIGN.md
class AppHeader extends StatefulWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAiTap;
  final VoidCallback? onProfileTap;

  const AppHeader({
    super.key,
    this.onNotificationTap,
    this.onAiTap,
    this.onProfileTap,
  });

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  bool _profilePressed = false;
  bool _notifPressed = false;
  bool _aiPressed = false;

  @override
  Widget build(BuildContext context) {
    String userName = 'Titut';
    String? profileImagePath;
    if (Get.isRegistered<StorageService>()) {
      final storage = Get.find<StorageService>();
      if (storage.userName.isNotEmpty) {
        userName = storage.userName;
      }
      profileImagePath = storage.profileImagePath;
    }
    final initialLetter = userName.isNotEmpty ? userName[0].toUpperCase() : 'T';
    bool hasImage = false;
    if (profileImagePath != null && profileImagePath.isNotEmpty) {
      try {
        hasImage = File(profileImagePath).existsSync();
      } catch (_) {
        hasImage = false;
      }
    }

    NotificationController? notifController;
    if (Get.isRegistered<NotificationController>()) {
      notifController = Get.find<NotificationController>();
    }

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 56,
          color: AppColors.background.withOpacity(0.90),
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: User Avatar + Welcome Text (Links to Profile)
              GestureDetector(
                onTapDown: (_) => setState(() => _profilePressed = true),
                onTapUp: (_) => setState(() => _profilePressed = false),
                onTapCancel: () => setState(() => _profilePressed = false),
                onTap: widget.onProfileTap ?? () => Get.toNamed(AppRoutes.profile),
                behavior: HitTestBehavior.opaque,
                child: AnimatedScale(
                  scale: _profilePressed ? 0.95 : 1.0,
                  duration: const Duration(milliseconds: 100),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 44px Black circle with white initial "T" or photo
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: hasImage
                            ? ClipOval(
                                child: Image.file(
                                  File(profileImagePath!),
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Text(
                                  initialLetter,
                                  style: AppTypography.cardTitle.copyWith(
                                    color: AppColors.onPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(width: AppDimens.spaceMd),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat datang',
                            style: AppTypography.captionMeta.copyWith(
                              color: AppColors.secondary,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            userName,
                            style: AppTypography.cardTitle.copyWith(
                              color: AppColors.onSurface,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Right: Action Buttons (Notification Bell & Tanya AI Sparkle)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Bell Button
                  GestureDetector(
                    onTapDown: (_) => setState(() => _notifPressed = true),
                    onTapUp: (_) => setState(() => _notifPressed = false),
                    onTapCancel: () => setState(() => _notifPressed = false),
                    onTap: widget.onNotificationTap ??
                        () => Get.toNamed(AppRoutes.notification),
                    child: AnimatedScale(
                      scale: _notifPressed ? 0.95 : 1.0,
                      duration: const Duration(milliseconds: 100),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                              boxShadow: [AppShadows.standard],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.notifications_none_outlined,
                                size: 20,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                          // Top-right black badge count (dynamically reflecting unread count)
                          Positioned(
                            top: -1,
                            right: -1,
                            child: Obx(() {
                              final controller = notifController ??
                                  (Get.isRegistered<NotificationController>()
                                      ? Get.find<NotificationController>()
                                      : null);
                              if (controller == null) return const SizedBox.shrink();
                              final unread = controller.unreadCount;
                              if (unread <= 0) return const SizedBox.shrink();

                              return Container(
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius:
                                      BorderRadius.circular(AppDimens.radiusFull),
                                ),
                                child: Center(
                                  child: Text(
                                    unread > 99 ? '99+' : '$unread',
                                    style: AppTypography.navLabel.copyWith(
                                      color: AppColors.onPrimary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      height: 1.0,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimens.gutter),

                  // Sparkle (Tanya AI) Button
                  GestureDetector(
                    onTapDown: (_) => setState(() => _aiPressed = true),
                    onTapUp: (_) => setState(() => _aiPressed = false),
                    onTapCancel: () => setState(() => _aiPressed = false),
                    onTap: widget.onAiTap ?? () => Get.toNamed(AppRoutes.ai),
                    child: AnimatedScale(
                      scale: _aiPressed ? 0.95 : 1.0,
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
                            Icons.auto_awesome_outlined,
                            size: 20,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

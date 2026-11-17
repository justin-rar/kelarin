import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';
import '../data/services/storage_service.dart';
import '../routes/app_routes.dart';

class AppHeader extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final storage = Get.find<StorageService>();
    final userName = storage.userName;
    final initialLetter = userName.isNotEmpty ? userName[0].toUpperCase() : 'T';

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: User Avatar + Welcome Text
          InkWell(
            onTap: onProfileTap ?? () => Get.toNamed(AppRoutes.profile),
            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initialLetter,
                      style: const TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: 16,
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
                    const Text(
                      'Selamat datang',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondary,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right: Action Buttons (Notification Bell & Tanya AI Sparkle)
          Row(
            children: [
              // Notification Bell Button
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      boxShadow: const [AppColors.cardShadow],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      onPressed: onNotificationTap ?? () => Get.toNamed(AppRoutes.notification),
                      splashRadius: 22,
                    ),
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                      ),
                      child: const Center(
                        child: Text(
                          '2',
                          style: TextStyle(
                            color: AppColors.onPrimary,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppDimens.spaceMd),

              // Sparkle (Tanya AI) Button
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  boxShadow: const [AppColors.cardShadow],
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.auto_awesome_rounded,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  onPressed: onAiTap,
                  splashRadius: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


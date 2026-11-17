import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../data/models/notification_item_model.dart';
import '../../../global_widgets/empty_state.dart';
import '../notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<NotificationController>()) {
      Get.put(NotificationController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                boxShadow: const [AppColors.cardShadow],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.primary),
                onPressed: () => Get.back(),
              ),
            ),
          ),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: controller.markAllAsRead,
              child: const Text(
                'Tandai Baca',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final list = controller.notifications;
          if (list.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(AppDimens.margin),
              child: EmptyStateCard(
                icon: Icons.notifications_none_rounded,
                title: 'Tidak Ada Notifikasi',
                subtitle: 'Semua informasi tugas, jadwal kuliah, dan sistem akan muncul di sini.',
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppDimens.margin),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notif = list[index];
              return _buildNotifCard(notif);
            },
          );
        }),
      ),
    );
  }

  Widget _buildNotifCard(NotificationItemModel notif) {
    final timeStr = DateFormat('HH:mm • d MMM').format(notif.timestamp);

    IconData icon;
    if (notif.type == 'TUGAS') {
      icon = Icons.assignment_outlined;
    } else if (notif.type == 'PRESENSI') {
      icon = Icons.calendar_today_outlined;
    } else {
      icon = Icons.info_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Tile
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: notif.isRead ? AppColors.fill1 : AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: notif.isRead ? AppColors.secondary : AppColors.onPrimary,
            ),
          ),
          const SizedBox(width: 14),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notif.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    if (!notif.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notif.message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.secondary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  timeStr,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.tertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

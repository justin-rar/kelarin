import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/notification_item_model.dart';
import '../../../global_widgets/empty_state.dart';
import '../../../global_widgets/form_top_bar.dart';
import '../notification_controller.dart';

/// Notification screen matching Layar 20 (20_notifikasi.html):
/// - FormTopBar(title: 'Notifikasi')
/// - Clean 2-tab filter switch: "Semua (X)" and "Belum Dibaca (Y)"
/// - 24px radius notification cards with time pill (schedule / notifications_active / check_circle),
///   8px black dot for unread, 75% opacity for read.
/// - Centered bottom action: "Bersihkan notifikasi" with delete_sweep icon.
class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  late final NotificationController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<NotificationController>()) {
      controller = Get.put(NotificationController());
    } else {
      controller = Get.find<NotificationController>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed 64px Top Bar with back button and centered title
            FormTopBar(
              title: 'Notifikasi',
              onBack: () => Get.back(),
            ),

            // Content Area
            Expanded(
              child: Obx(() {
                final allCount = controller.notifications.length;
                final unreadCount = controller.unreadCount;
                final filteredList = controller.filteredNotifications;
                final selectedFilter = controller.selectedFilterIndex.value;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.margin,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Clean 2-tab Filter Switch
                      Row(
                        children: [
                          _buildFilterTab(
                            label: 'Semua ($allCount)',
                            isSelected: selectedFilter == 0,
                            onTap: () => controller.setFilter(0),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterTab(
                            label: 'Belum Dibaca ($unreadCount)',
                            isSelected: selectedFilter == 1,
                            onTap: () => controller.setFilter(1),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Notification List or Empty State
                      if (filteredList.isEmpty) ...[
                        const SizedBox(height: 40),
                        EmptyStateCard(
                          icon: Icons.notifications_none_outlined,
                          title: selectedFilter == 1
                              ? 'Semua Sudah Dibaca'
                              : 'Belum Ada Notifikasi',
                          subtitle: selectedFilter == 1
                              ? 'Tidak ada notifikasi baru yang belum dibaca saat ini.'
                              : 'Semua informasi tugas, jadwal kuliah, dan sistem akan muncul di sini.',
                        ),
                      ] else ...[
                        for (int i = 0; i < filteredList.length; i++) ...[
                          if (i > 0) const SizedBox(height: 12),
                          _buildNotificationCard(filteredList[i]),
                        ],

                        // Bottom Action: "Bersihkan notifikasi"
                        const SizedBox(height: 32),
                        Center(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: controller.clearAll,
                              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.delete_sweep,
                                      size: 16,
                                      color: AppColors.secondary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Bersihkan notifikasi',
                                      style: AppTypography.captionMeta.copyWith(
                                        color: AppColors.secondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.fill1,
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.buttonText.copyWith(
            fontSize: 12,
            color: isSelected ? AppColors.onPrimary : AppColors.secondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItemModel notif) {
    final bool isRead = notif.isRead;
    final String timeBadge = controller.formatRelativeTime(
      notif.timestamp,
      notif.type,
      isRead,
    );

    IconData icon;
    if (notif.type == 'TUGAS') {
      icon = Icons.schedule;
    } else if (notif.type == 'PRESENSI') {
      icon = Icons.notifications_active;
    } else {
      icon = Icons.check_circle;
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isRead ? 0.75 : 1.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (!isRead) {
              controller.markAsRead(notif.id);
            }
          },
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
              boxShadow: const [AppShadows.standard],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row (Time pill + unread dot)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Time pill
                    Container(
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColors.fill1,
                        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            icon,
                            size: 14,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            timeBadge,
                            style: AppTypography.captionMeta.copyWith(
                              fontSize: 11,
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Unread 8px Black Dot Indicator
                    if (!isRead)
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

                const SizedBox(height: 10),

                // Title
                Text(
                  notif.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.cardTitle.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: isRead ? FontWeight.w600 : FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                // Message description
                Text(
                  notif.message,
                  style: AppTypography.captionMeta.copyWith(
                    color: AppColors.secondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';
import '../core/constants/app_shadows.dart';
import '../core/theme/app_typography.dart';
import '../data/models/attendance_model.dart';

/// CourseCard matching DESIGN.md:
/// 24px radius, standard shadow.
/// Header: time pill left, class badge (Praktikum vs Teori) right.
/// Course name in card-title, meta row (room • class), reminder line.
class CourseCard extends StatefulWidget {
  final AttendanceModel attendance;
  final VoidCallback? onToggleReminder;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.attendance,
    this.onToggleReminder,
    this.onDelete,
    this.onTap,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final att = widget.attendance;
    final isPraktikum = att.type.toLowerCase() == 'praktikum';

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          margin: const EdgeInsets.only(bottom: AppDimens.gutter),
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            boxShadow: const [AppShadows.standard],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Time pill left + Class badge right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Time pill (28px high, fill-1)
                  Container(
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.fill1,
                      borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 14,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          att.time.isNotEmpty ? att.time : '08:00 - 09:40 WIB',
                          style: AppTypography.captionMeta.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Class badge ("Praktikum" black / "Teori" fill-1)
                  Container(
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isPraktikum ? AppColors.primary : AppColors.fill1,
                      borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                    ),
                    child: Text(
                      att.type,
                      style: AppTypography.captionMeta.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isPraktikum
                            ? AppColors.onPrimary
                            : AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Row 2: Course Name (card-title)
              Text(
                att.subjectName,
                style: AppTypography.cardTitle.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 8),

              // Row 3: Meta row (room • class)
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    att.room.isNotEmpty ? att.room : 'Lab Komputer',
                    style: AppTypography.captionMeta.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      '•',
                      style: AppTypography.captionMeta.copyWith(
                        color: AppColors.outlineVariant,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.group_outlined,
                    size: 14,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    att.day,
                    style: AppTypography.captionMeta.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 10),

              // Row 4: Reminder status line + Delete action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: widget.onToggleReminder,
                    child: Row(
                      children: [
                        Icon(
                          att.reminderActive
                              ? Icons.notifications_active_outlined
                              : Icons.notifications_off_outlined,
                          size: 14,
                          color: att.reminderActive
                              ? AppColors.primary
                              : AppColors.outline,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          att.reminderActive
                              ? 'Pengingat aktif'
                              : 'Pengingat nonaktif',
                          style: AppTypography.captionMeta.copyWith(
                            color: att.reminderActive
                                ? AppColors.primary
                                : AppColors.outline,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.onDelete != null)
                    GestureDetector(
                      onTap: widget.onDelete,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: AppColors.secondary,
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

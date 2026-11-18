import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';
import '../core/constants/app_shadows.dart';
import '../core/theme/app_typography.dart';

/// FloatingBottomNav 5-slot navigation bar.
/// 72px high, 32px radius, floating above content.
/// Center button is a 56x56 black FAB raised 8px with CTA shadow.
/// Acuan: design/DESIGN.md
class FloatingBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;
  final VoidCallback onAddTap;
  final bool isAksiCepatOpen;

  const FloatingBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onAddTap,
    this.isAksiCepatOpen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: AppDimens.margin,
        right: AppDimens.margin,
        bottom: 16,
      ),
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusNav),
        boxShadow: const [AppShadows.standard],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Tab 0: Home
          _buildNavItem(
            index: 0,
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Home',
          ),

          // Tab 1: Selesai
          _buildNavItem(
            index: 1,
            icon: Icons.task_alt,
            activeIcon: Icons.task_alt,
            label: 'Selesai',
          ),

          // Center Button: [+] or [x] when Aksi Cepat is open
          GestureDetector(
            onTap: onAddTap,
            child: Container(
              width: 56,
              height: 56,
              transform: Matrix4.translationValues(0.0, -8.0, 0.0),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppDimens.radiusFab),
                boxShadow: const [AppShadows.cta],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: Icon(
                    isAksiCepatOpen ? Icons.close : Icons.add,
                    key: ValueKey<bool>(isAksiCepatOpen),
                    color: AppColors.onPrimary,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),

          // Tab 2: Absen
          _buildNavItem(
            index: 2,
            icon: Icons.calendar_today_outlined,
            activeIcon: Icons.calendar_today,
            label: 'Absen',
          ),

          // Tab 3: Catatan
          _buildNavItem(
            index: 3,
            icon: Icons.edit_note,
            activeIcon: Icons.edit_note,
            label: 'Catatan',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool isActive = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 24,
              color: isActive ? AppColors.primary : AppColors.outline,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.navLabel.copyWith(
                color: isActive ? AppColors.primary : AppColors.outline,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
            const SizedBox(height: 3),
            // 4px black active dot indicator
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? AppColors.primary : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

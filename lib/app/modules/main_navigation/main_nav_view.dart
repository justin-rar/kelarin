import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../global_widgets/floating_bottom_nav.dart';
import '../../global_widgets/quick_action_sheet.dart';
import '../attendance/views/attendance_view.dart';
import '../home/home_view.dart';
import '../note/views/note_view.dart';
import '../task/views/completed_tasks_view.dart';
import 'main_nav_controller.dart';

class MainNavigationView extends GetView<MainNavController> {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = const [
      HomeView(),
      CompletedTasksView(),
      AttendanceView(),
      NoteView(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Current Tab — smooth fade antar tab
          Obx(() {
            final idx = controller.currentIndex.value;
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              child: KeyedSubtree(
                key: ValueKey<int>(idx),
                child: pages[idx],
              ),
            );
          }),

          // Aksi Cepat Overlay — Fade masuk responsif instan tanpa lag blur
          Obx(() {
            final isOpen = controller.isAksiCepatOpen.value;
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              switchInCurve: Curves.easeOutQuad,
              switchOutCurve: Curves.easeInQuad,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              child: isOpen
                  ? QuickActionSheet(
                      key: const ValueKey('aksi-cepat'),
                      onClose: controller.closeAksiCepat,
                    )
                  : const SizedBox.shrink(key: ValueKey('empty')),
            );
          }),

          // Floating Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(() => FloatingBottomNav(
                  currentIndex: controller.currentIndex.value,
                  onTabSelected: controller.changeTab,
                  onAddTap: controller.toggleAksiCepat,
                  isAksiCepatOpen: controller.isAksiCepatOpen.value,
                )),
          ),
        ],
      ),
    );
  }
}


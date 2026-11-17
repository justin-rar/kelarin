import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../global_widgets/floating_bottom_nav.dart';
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
          // Current Tab Page View
          Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: pages,
          )),

          // Floating Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(() => FloatingBottomNav(
              currentIndex: controller.currentIndex.value,
              onTabSelected: controller.changeTab,
              onAddTap: () => controller.openAddActionMenu(context),
            )),
          ),
        ],
      ),
    );
  }
}


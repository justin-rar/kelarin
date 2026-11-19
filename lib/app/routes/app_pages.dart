import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/attendance/attendance_binding.dart';
import '../modules/attendance/views/add_attendance_view.dart';
import '../modules/main_navigation/main_nav_binding.dart';
import '../modules/main_navigation/main_nav_view.dart';
import '../modules/note/note_binding.dart';
import '../modules/note/views/add_note_view.dart';
import '../modules/note/views/edit_note_view.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/onboarding/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/pin/pin_binding.dart';
import '../modules/pin/pin_view.dart';
import '../modules/profile/profile_binding.dart';
import '../modules/profile/views/edit_profile_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import '../modules/task/task_binding.dart';
import '../modules/task/views/add_task_view.dart';
import '../modules/task/views/edit_task_view.dart';
import '../modules/task/views/task_detail_view.dart';
import 'app_routes.dart';

// Durasi & kurva transisi standar seluruh aplikasi
const Duration _kTransitionDuration = Duration(milliseconds: 320);
const Curve _kTransitionCurve = Curves.easeInOutCubic;

/// Custom transition: slide dari kanan + fade, dengan kurva yang smooth
CustomTransition get _slideRightFade => _SlideFadeTransition();

class _SlideFadeTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final slideIn = Tween<Offset>(
      begin: const Offset(0.06, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: _kTransitionCurve));

    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: _kTransitionCurve),
      child: SlideTransition(position: slideIn, child: child),
    );
  }
}

class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
      transitionDuration: _kTransitionDuration,
    ),
    GetPage(
      name: AppRoutes.pin,
      page: () => const PinView(),
      binding: PinBinding(),
      transition: Transition.fadeIn,
      transitionDuration: _kTransitionDuration,
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainNavigationView(),
      binding: MainNavBinding(),
      transition: Transition.fadeIn,
      transitionDuration: _kTransitionDuration,
    ),
    GetPage(
      name: AppRoutes.taskAdd,
      page: () => const AddTaskView(),
      binding: TaskBinding(),
      customTransition: _slideRightFade,
      transitionDuration: _kTransitionDuration,
    ),
    GetPage(
      name: AppRoutes.taskEdit,
      page: () => const EditTaskView(),
      binding: TaskBinding(),
      customTransition: _slideRightFade,
      transitionDuration: _kTransitionDuration,
    ),
    GetPage(
      name: AppRoutes.taskDetail,
      page: () => const TaskDetailView(),
      binding: TaskBinding(),
      customTransition: _slideRightFade,
      transitionDuration: _kTransitionDuration,
    ),
    GetPage(
      name: AppRoutes.attendanceAdd,
      page: () => const AddAttendanceView(),
      binding: AttendanceBinding(),
      customTransition: _slideRightFade,
      transitionDuration: _kTransitionDuration,
    ),
    GetPage(
      name: AppRoutes.noteAdd,
      page: () => const AddNoteView(),
      binding: NoteBinding(),
      customTransition: _slideRightFade,
      transitionDuration: _kTransitionDuration,
    ),
    GetPage(
      name: AppRoutes.noteEdit,
      page: () => const EditNoteView(),
      binding: NoteBinding(),
      customTransition: _slideRightFade,
      transitionDuration: _kTransitionDuration,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      customTransition: _slideRightFade,
      transitionDuration: _kTransitionDuration,
    ),
    GetPage(
      name: AppRoutes.profileEdit,
      page: () => const EditProfileView(),
      binding: ProfileBinding(),
      customTransition: _slideRightFade,
      transitionDuration: _kTransitionDuration,
    ),
    GetPage(
      name: AppRoutes.notification,
      page: () => const NotificationView(),
      customTransition: _slideRightFade,
      transitionDuration: _kTransitionDuration,
    ),
  ];
}


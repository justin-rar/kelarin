import 'package:get/get.dart';
import '../modules/attendance/views/add_attendance_view.dart';
import '../modules/main_navigation/main_nav_binding.dart';
import '../modules/main_navigation/main_nav_view.dart';
import '../modules/note/views/add_note_view.dart';
import '../modules/note/views/edit_note_view.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/pin/pin_binding.dart';
import '../modules/pin/pin_view.dart';
import '../modules/profile/views/about_view.dart';
import '../modules/profile/views/edit_profile_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import '../modules/task/views/add_task_view.dart';
import '../modules/task/views/edit_task_view.dart';
import '../modules/task/views/task_detail_view.dart';
import 'app_routes.dart';

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
      name: AppRoutes.pin,
      page: () => const PinView(),
      binding: PinBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainNavigationView(),
      binding: MainNavBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.taskAdd,
      page: () => const AddTaskView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.taskEdit,
      page: () => const EditTaskView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.taskDetail,
      page: () => const TaskDetailView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.attendanceAdd,
      page: () => const AddAttendanceView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.noteAdd,
      page: () => const AddNoteView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.noteEdit,
      page: () => const EditNoteView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.profileEdit,
      page: () => const EditProfileView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.profileAbout,
      page: () => const AboutView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.notification,
      page: () => const NotificationView(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}


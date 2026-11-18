import 'package:get/get.dart';
import '../modules/ai/views/tanya_ai_view.dart';
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
import '../modules/profile/views/about_view.dart';
import '../modules/profile/views/edit_profile_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import '../modules/task/task_binding.dart';
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
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
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
      binding: TaskBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.taskEdit,
      page: () => const EditTaskView(),
      binding: TaskBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.taskDetail,
      page: () => const TaskDetailView(),
      binding: TaskBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.attendanceAdd,
      page: () => const AddAttendanceView(),
      binding: AttendanceBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.noteAdd,
      page: () => const AddNoteView(),
      binding: NoteBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.noteEdit,
      page: () => const EditNoteView(),
      binding: NoteBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.profileEdit,
      page: () => const EditProfileView(),
      binding: ProfileBinding(),
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
    GetPage(
      name: AppRoutes.ai,
      page: () => const TanyaAiView(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}


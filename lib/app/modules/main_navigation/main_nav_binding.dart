import 'package:get/get.dart';
import '../ai/ai_controller.dart';
import '../attendance/attendance_controller.dart';
import '../note/note_controller.dart';
import '../notification/notification_controller.dart';
import '../profile/profile_controller.dart';
import '../task/task_controller.dart';
import 'main_nav_controller.dart';

class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavController>(() => MainNavController());
    Get.lazyPut<TaskController>(() => TaskController());
    Get.lazyPut<AttendanceController>(() => AttendanceController());
    Get.lazyPut<NoteController>(() => NoteController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<AiController>(() => AiController());
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}


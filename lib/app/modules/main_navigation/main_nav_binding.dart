import 'package:get/get.dart';
import '../attendance/attendance_controller.dart';
import '../calendar/calendar_controller.dart';
import '../note/note_controller.dart';
import '../notification/notification_controller.dart';
import '../profile/profile_controller.dart';
import '../task/task_controller.dart';
import 'main_nav_controller.dart';

class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavController>(() => MainNavController(), fenix: true);
    Get.lazyPut<TaskController>(() => TaskController(), fenix: true);
    Get.put<AttendanceController>(AttendanceController(), permanent: true);
    Get.lazyPut<NoteController>(() => NoteController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<NotificationController>(() => NotificationController(), fenix: true);
    Get.lazyPut<CalendarController>(() => CalendarController(), fenix: true);
  }
}


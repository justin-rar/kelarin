import 'package:get/get.dart';
import 'attendance_controller.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    // Gunakan instance yang sudah ada (dari MainNavBinding) jika tersedia.
    // Jika belum ada (misalnya navigasi langsung ke halaman ini),
    // buat instance baru dengan fenix:true agar tidak terhapus oleh GetX.
    if (!Get.isRegistered<AttendanceController>()) {
      Get.put<AttendanceController>(AttendanceController(), permanent: true);
    }
  }
}

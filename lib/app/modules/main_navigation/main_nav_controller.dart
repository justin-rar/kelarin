import 'package:get/get.dart';
import '../../data/services/notification_service.dart';

class MainNavController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxBool isAksiCepatOpen = false.obs;

  @override
  void onReady() {
    super.onReady();
    _requestNotificationPermissions();
  }

  Future<void> _requestNotificationPermissions() async {
    if (Get.isRegistered<NotificationService>()) {
      await Get.find<NotificationService>().requestPermissions();
    }
  }

  void changeTab(int index) {
    if (isAksiCepatOpen.value) {
      isAksiCepatOpen.value = false;
    }
    currentIndex.value = index;
  }

  void toggleAksiCepat() {
    isAksiCepatOpen.toggle();
  }

  void closeAksiCepat() {
    isAksiCepatOpen.value = false;
  }
}

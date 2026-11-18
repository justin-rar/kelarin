import 'package:get/get.dart';

class MainNavController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxBool isAksiCepatOpen = false.obs;

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

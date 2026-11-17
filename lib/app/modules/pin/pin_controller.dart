import 'package:get/get.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_routes.dart';

class PinController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final RxString enteredPin = ''.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isAuthMode = true.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    isAuthMode.value = args?['isAuth'] ?? true;
  }

  void appendDigit(String digit) {
    if (enteredPin.value.length < 4) {
      enteredPin.value += digit;
      errorMessage.value = '';

      if (enteredPin.value.length == 4) {
        _handleCompletePin();
      }
    }
  }

  void deleteDigit() {
    if (enteredPin.value.isNotEmpty) {
      enteredPin.value = enteredPin.value.substring(0, enteredPin.value.length - 1);
      errorMessage.value = '';
    }
  }

  void clearPin() {
    enteredPin.value = '';
    errorMessage.value = '';
  }

  void _handleCompletePin() {
    if (isAuthMode.value) {
      final savedPin = _storage.appPin;
      if (enteredPin.value == savedPin) {
        Get.offAllNamed(AppRoutes.main);
      } else {
        errorMessage.value = 'PIN salah. Silakan coba lagi.';
        enteredPin.value = '';
      }
    } else {
      // Setup / Change Mode
      _storage.setAppPin(enteredPin.value);
      _storage.setPinEnabled(true);
      Get.back(result: true);
      Get.snackbar('Sukses', 'PIN keamanan berhasil diperbarui',
          snackPosition: SnackPosition.TOP);
    }
  }
}


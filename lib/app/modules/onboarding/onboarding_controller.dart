import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  // Step 0: Profile & Security info form
  // Step 1: Set New PIN
  // Step 2: Confirm New PIN
  final RxInt currentStep = 0.obs;

  final nameController = TextEditingController();
  final securityAnswerController = TextEditingController();

  final RxBool obscureSecurityAnswer = true.obs;
  void toggleObscureSecurityAnswer() {
    obscureSecurityAnswer.value = !obscureSecurityAnswer.value;
  }

  final RxString selectedSecurityQuestion = 'Nama Ibu Kandung'.obs;
  final List<String> securityQuestions = [
    'Nama Ibu Kandung',
    'Nama Hewan Peliharaan Pertama',
    'Kota Tempat Lahir',
    'Sekolah Dasar Pertama',
  ];

  final RxString enteredPin = ''.obs;
  final RxString temporaryNewPin = ''.obs;
  final RxString pinErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Jangan pre-fill dari storage karena state awal kosong
    // Field dibiarkan kosong agar user mengisi sendiri
    if (_storage.securityQuestion.isNotEmpty &&
        securityQuestions.contains(_storage.securityQuestion)) {
      selectedSecurityQuestion.value = _storage.securityQuestion;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    securityAnswerController.dispose();
    super.onClose();
  }

  void proceedToPinSetup() {
    final name = nameController.text.trim();
    final answer = securityAnswerController.text.trim();

    if (name.isEmpty) {
      Get.rawSnackbar(
        message: 'Mohon isi nama lengkap Anda',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    if (answer.isEmpty) {
      Get.rawSnackbar(
        message: 'Mohon isi jawaban keamanan untuk pemulihan PIN',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Advance to PIN setup
    currentStep.value = 1;
    enteredPin.value = '';
    pinErrorMessage.value = '';
  }

  void backToProfileForm() {
    currentStep.value = 0;
    enteredPin.value = '';
    pinErrorMessage.value = '';
  }

  void appendPinDigit(String digit) {
    if (enteredPin.value.length < 4) {
      enteredPin.value += digit;
      pinErrorMessage.value = '';

      if (enteredPin.value.length == 4) {
        Future.delayed(const Duration(milliseconds: 150), () {
          _handleCompletePin();
        });
      }
    }
  }

  void deletePinDigit() {
    if (enteredPin.value.isNotEmpty) {
      enteredPin.value =
          enteredPin.value.substring(0, enteredPin.value.length - 1);
      pinErrorMessage.value = '';
    }
  }

  void clearPin() {
    enteredPin.value = '';
    pinErrorMessage.value = '';
  }

  Future<void> _handleCompletePin() async {
    final pin = enteredPin.value;

    if (currentStep.value == 1) {
      // Step 1: Save temp new PIN and go to confirmation
      temporaryNewPin.value = pin;
      enteredPin.value = '';
      currentStep.value = 2; // Confirm PIN step
    } else if (currentStep.value == 2) {
      // Step 2: Confirm PIN
      if (pin == temporaryNewPin.value) {
        // Save profile (hanya nama, field lain kosong saat awal)
        await _storage.setProfile(
          name: nameController.text.trim(),
          nim: '',
          email: '',
          major: '',
          semester: '',
        );

        // Save security info
        await _storage.setSecurityInfo(
          selectedSecurityQuestion.value,
          securityAnswerController.text.trim(),
        );

        // Save PIN and mark setup complete
        await _storage.setAppPin(pin);
        await _storage.setPinEnabled(true);
        await _storage.setProfileSetupDone(true);

        Get.rawSnackbar(
          message: 'Profil dan PIN keamanan berhasil dikonfigurasi!',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );

        Get.offAllNamed(AppRoutes.main);
      } else {
        pinErrorMessage.value = 'Konfirmasi PIN tidak cocok. Silakan ulangi.';
        enteredPin.value = '';
      }
    }
  }
}

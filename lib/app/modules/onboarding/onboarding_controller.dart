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
  final nimController = TextEditingController();
  final emailController = TextEditingController();
  final majorController = TextEditingController(text: 'Sistem Informasi');
  final securityAnswerController = TextEditingController();

  final RxString selectedSecurityQuestion = 'Nama Ibu Kandung'.obs;
  final List<String> securityQuestions = [
    'Nama Ibu Kandung',
    'Kota Kelahiran',
    'Sekolah Menengah Pertama (SMP)',
    'Nama Hewan Peliharaan Pertama',
  ];

  final RxString enteredPin = ''.obs;
  final RxString temporaryNewPin = ''.obs;
  final RxString pinErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Default initial suggestions if already present
    nameController.text = _storage.userName.isNotEmpty ? _storage.userName : '';
    nimController.text = _storage.userNim.isNotEmpty ? _storage.userNim : '';
    emailController.text = _storage.userEmail.isNotEmpty ? _storage.userEmail : '';
  }

  @override
  void onClose() {
    nameController.dispose();
    nimController.dispose();
    emailController.dispose();
    majorController.dispose();
    securityAnswerController.dispose();
    super.onClose();
  }

  void proceedToPinSetup() {
    final name = nameController.text.trim();
    final nim = nimController.text.trim();
    final email = emailController.text.trim();
    final answer = securityAnswerController.text.trim();

    if (name.isEmpty) {
      Get.rawSnackbar(
        message: 'Mohon isi nama lengkap Anda',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    if (nim.isEmpty) {
      Get.rawSnackbar(
        message: 'Mohon isi NIM Anda (digunakan untuk pemulihan PIN)',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    if (email.isEmpty) {
      Get.rawSnackbar(
        message: 'Mohon isi email Anda (digunakan untuk pemulihan PIN)',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    if (answer.isEmpty) {
      Get.rawSnackbar(
        message: 'Mohon isi jawaban pertanyaan keamanan pemulihan PIN',
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
        // Save profile
        await _storage.setProfile(
          name: nameController.text.trim(),
          nim: nimController.text.trim(),
          email: emailController.text.trim(),
          major: majorController.text.trim().isNotEmpty
              ? majorController.text.trim()
              : 'Sistem Informasi',
          semester: 'Semester 5',
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

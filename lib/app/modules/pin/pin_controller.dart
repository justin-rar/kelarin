import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../data/services/storage_service.dart';
import '../../global_widgets/undo_toast.dart';
import '../../routes/app_routes.dart';

enum PinFlowMode {
  auth,          // Login / unlock app
  setup,         // First-time or reset setup (new PIN -> confirm new PIN)
  change,        // Change PIN (old PIN -> new PIN -> confirm new PIN)
  disableConfirm // Verify PIN before disabling lock
}

enum PinStep {
  enterCurrent,  // Enter current/old PIN
  enterNew,      // Enter new PIN
  confirmNew,    // Confirm new PIN
}

class PinController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final Rx<PinFlowMode> flowMode = PinFlowMode.auth.obs;
  final Rx<PinStep> currentStep = PinStep.enterCurrent.obs;

  final RxString enteredPin = ''.obs;
  final RxString errorMessage = ''.obs;

  String _temporaryNewPin = '';
  bool isForgotPinReset = false;

  @override
  void onInit() {
    super.onInit();
    final rawArgs = Get.arguments;
    Map<String, dynamic>? args;
    if (rawArgs is Map) {
      args = rawArgs.map((key, value) => MapEntry(key.toString(), value));
    }
    final modeStr = args?['mode']?.toString();
    final isAuth = args?['isAuth'] == true;

    if (modeStr == 'change') {
      flowMode.value = PinFlowMode.change;
      currentStep.value = PinStep.enterCurrent;
    } else if (modeStr == 'setup' || isAuth == false) {
      flowMode.value = PinFlowMode.setup;
      currentStep.value = PinStep.enterNew;
    } else if (modeStr == 'disableConfirm') {
      flowMode.value = PinFlowMode.disableConfirm;
      currentStep.value = PinStep.enterCurrent;
    } else {
      flowMode.value = PinFlowMode.auth;
      currentStep.value = PinStep.enterCurrent;
    }
  }

  bool get isAuthMode => flowMode.value == PinFlowMode.auth;

  String get screenTitle {
    switch (flowMode.value) {
      case PinFlowMode.auth:
        return 'Masukkan PIN Keamanan';
      case PinFlowMode.setup:
        if (currentStep.value == PinStep.enterNew) {
          return 'Atur PIN Keamanan Baru';
        } else {
          return 'Konfirmasi PIN Baru';
        }
      case PinFlowMode.change:
        if (currentStep.value == PinStep.enterCurrent) {
          return 'Masukkan PIN Lama';
        } else if (currentStep.value == PinStep.enterNew) {
          return 'Masukkan PIN Baru';
        } else {
          return 'Konfirmasi PIN Baru';
        }
      case PinFlowMode.disableConfirm:
        return 'Konfirmasi PIN Keamanan';
    }
  }

  String get screenSubtitle {
    switch (flowMode.value) {
      case PinFlowMode.auth:
        return 'Akses data tugas dan catatan dilindungi';
      case PinFlowMode.setup:
        if (currentStep.value == PinStep.enterNew) {
          return 'Masukkan 4 digit kode PIN keamanan Anda';
        } else {
          return 'Masukkan ulang 4 digit PIN baru untuk verifikasi';
        }
      case PinFlowMode.change:
        if (currentStep.value == PinStep.enterCurrent) {
          return 'Verifikasi kode PIN lama Anda sebelum mengganti';
        } else if (currentStep.value == PinStep.enterNew) {
          return 'PIN baru tidak boleh sama dengan PIN sebelumnya';
        } else {
          return 'Masukkan ulang 4 digit PIN baru untuk verifikasi';
        }
      case PinFlowMode.disableConfirm:
        return 'Masukkan PIN saat ini untuk mematikan kunci keamanan';
    }
  }

  void appendDigit(String digit) {
    if (enteredPin.value.length < 4) {
      enteredPin.value += digit;
      errorMessage.value = '';

      if (enteredPin.value.length == 4) {
        Future.delayed(const Duration(milliseconds: 150), () {
          _handleCompletePin();
        });
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
    final pin = enteredPin.value;

    switch (flowMode.value) {
      // 1. AUTH MODE
      case PinFlowMode.auth:
        if (pin == _storage.appPin) {
          Get.offAllNamed(AppRoutes.main);
        } else {
          errorMessage.value = 'PIN salah. Silakan coba lagi.';
          enteredPin.value = '';
        }
        break;

      // 2. SETUP MODE (1x confirmation required)
      case PinFlowMode.setup:
        if (currentStep.value == PinStep.enterNew) {
          _temporaryNewPin = pin;
          enteredPin.value = '';
          currentStep.value = PinStep.confirmNew;
        } else if (currentStep.value == PinStep.confirmNew) {
          if (pin == _temporaryNewPin) {
            _storage.setAppPin(pin);
            _storage.setPinEnabled(true);
            _storage.setProfileSetupDone(true);

            if (isForgotPinReset) {
              UndoToast.show(message: 'PIN baru berhasil disimpan. Selamat datang!');
              Get.offAllNamed(AppRoutes.main);
            } else if (Get.previousRoute.isEmpty || Get.previousRoute == AppRoutes.splash) {
              Get.offAllNamed(AppRoutes.main);
            } else {
              Get.back(result: true);
              UndoToast.show(message: 'PIN keamanan berhasil diatur');
            }
          } else {
            errorMessage.value = 'Konfirmasi PIN tidak cocok. Silakan ulangi.';
            enteredPin.value = '';
          }
        }
        break;

      // 3. CHANGE PIN MODE (Old PIN -> New PIN [cannot be in history] -> Confirm New PIN)
      case PinFlowMode.change:
        if (currentStep.value == PinStep.enterCurrent) {
          if (pin == _storage.appPin) {
            enteredPin.value = '';
            currentStep.value = PinStep.enterNew;
          } else {
            errorMessage.value = 'PIN lama salah. Silakan coba lagi.';
            enteredPin.value = '';
          }
        } else if (currentStep.value == PinStep.enterNew) {
          if (_storage.isPinInHistory(pin)) {
            errorMessage.value = 'PIN baru tidak boleh sama dengan PIN sebelumnya!';
            enteredPin.value = '';
          } else {
            _temporaryNewPin = pin;
            enteredPin.value = '';
            currentStep.value = PinStep.confirmNew;
          }
        } else if (currentStep.value == PinStep.confirmNew) {
          if (pin == _temporaryNewPin) {
            _storage.setAppPin(pin);
            _storage.setPinEnabled(true);
            Get.back(result: true);
            UndoToast.show(message: 'PIN keamanan berhasil diperbarui');
          } else {
            errorMessage.value = 'Konfirmasi PIN tidak cocok. Silakan ulangi.';
            enteredPin.value = '';
          }
        }
        break;

      // 4. DISABLE PIN CONFIRMATION MODE
      case PinFlowMode.disableConfirm:
        if (pin == _storage.appPin) {
          _storage.setPinEnabled(false);
          Get.back(result: true);
          UndoToast.show(message: 'Kunci PIN keamanan dinonaktifkan');
        } else {
          errorMessage.value = 'PIN salah. Gagal menonaktifkan PIN.';
          enteredPin.value = '';
        }
        break;
    }
  }

  // ---------------------------------------------------------------------------
  // LUPA PIN VERIFICATION DIALOG & RESET LOGIC
  // ---------------------------------------------------------------------------
  void openForgotPinModal(BuildContext context) {
    final nimInput = TextEditingController();
    final emailInput = TextEditingController();
    final securityInput = TextEditingController();
    final modalError = ''.obs;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: AppDimens.margin,
          right: AppDimens.margin,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.statDark,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Pemulihan PIN (Lupa PIN)',
                style: AppTypography.cardTitle.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                'Masukkan informasi pribadi profil Anda untuk mengonfirmasi identitas:',
                style: AppTypography.bodyDefault.copyWith(color: AppColors.secondary),
              ),
              const SizedBox(height: 16),

              // Field NIM
              Text('NIM Terdaftar *', style: AppTypography.fieldLabel.copyWith(color: AppColors.secondary)),
              const SizedBox(height: 6),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.fill1,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  controller: nimInput,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: 123220001',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Field Email
              Text('Email Terdaftar *', style: AppTypography.fieldLabel.copyWith(color: AppColors.secondary)),
              const SizedBox(height: 6),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.fill1,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  controller: emailInput,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'nama@student.upnyk.ac.id',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Pertanyaan Keamanan
              Text(
                'Pertanyaan Keamanan: ${_storage.securityQuestion} *',
                style: AppTypography.fieldLabel.copyWith(color: AppColors.secondary),
              ),
              const SizedBox(height: 6),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.fill1,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  controller: securityInput,
                  decoration: const InputDecoration(
                    hintText: 'Jawaban keamanan yang Anda daftarkan',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),

              // Error feedback
              Obx(() {
                if (modalError.value.isEmpty) return const SizedBox(height: 8);
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    modalError.value,
                    style: const TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                );
              }),

              const SizedBox(height: 20),

              // Button Verifikasi
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                    ),
                  ),
                  onPressed: () {
                    final enteredNim = nimInput.text.trim();
                    final enteredEmail = emailInput.text.trim().toLowerCase();
                    final enteredAnswer = securityInput.text.trim().toLowerCase();

                    final registeredNim = _storage.userNim.trim();
                    final registeredEmail = _storage.userEmail.trim().toLowerCase();
                    final registeredAnswer = _storage.securityAnswer.trim().toLowerCase();

                    // Verification logic
                    final bool isNimMatch = enteredNim == registeredNim;
                    final bool isEmailMatch = enteredEmail == registeredEmail;
                    final bool isAnswerMatch =
                        registeredAnswer.isEmpty || enteredAnswer == registeredAnswer;

                    if (isNimMatch && (isEmailMatch || isAnswerMatch)) {
                      Get.back(); // close sheet
                      // Switch PinController to Reset Setup mode
                      isForgotPinReset = true;
                      flowMode.value = PinFlowMode.setup;
                      currentStep.value = PinStep.enterNew;
                      enteredPin.value = '';
                      errorMessage.value = '';
                      Get.rawSnackbar(
                        message: 'Identitas terverifikasi! Silakan atur PIN baru Anda.',
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 3),
                      );
                    } else {
                      modalError.value =
                          'Data verifikasi tidak cocok dengan profil terdaftar. Pastikan NIM dan Email/Jawaban benar.';
                    }
                  },
                  child: Text(
                    'Verifikasi & Atur Ulang PIN',
                    style: AppTypography.buttonText.copyWith(color: AppColors.onPrimary),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

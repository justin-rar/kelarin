import 'package:get/get.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final RxDouble progress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _startInitSequence();
  }

  Future<void> _startInitSequence() async {
    // Smooth progress animation
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 120));
      progress.value = i / 10.0;
    }

    await Future.delayed(const Duration(milliseconds: 200));

    if (_storage.isPinEnabled) {
      Get.offAllNamed(AppRoutes.pin, arguments: {'isAuth': true});
    } else {
      Get.offAllNamed(AppRoutes.main);
    }
  }
}


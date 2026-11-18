import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ai_controller.dart';
import 'tanya_ai_view.dart';
import '../../../routes/app_routes.dart';

/// Legacy BottomSheet wrapper maintained for backward compatibility.
/// Routes to the full-screen [TanyaAiView] matching Layar 18 & 19 specs.
class TanyaAiBottomSheet extends StatelessWidget {
  const TanyaAiBottomSheet({super.key});

  static void show(BuildContext context) {
    if (!Get.isRegistered<AiController>()) {
      Get.put(AiController());
    }
    Get.toNamed(AppRoutes.ai);
  }

  @override
  Widget build(BuildContext context) {
    return const TanyaAiView();
  }
}

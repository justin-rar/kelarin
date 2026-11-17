import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../ai_controller.dart';

class TanyaAiBottomSheet extends StatelessWidget {
  const TanyaAiBottomSheet({super.key});

  static void show(BuildContext context) {
    if (!Get.isRegistered<AiController>()) {
      Get.put(AiController());
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TanyaAiBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AiController controller = Get.find<AiController>();
    final TextEditingController textController = TextEditingController();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.statDark,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          size: 18,
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tanya AI',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'Asisten Produktivitas & Belajar',
                          style: TextStyle(fontSize: 11, color: AppColors.secondary),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.primary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 24),

          // Suggestion Chips
          SizedBox(
            height: 36,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
              scrollDirection: Axis.horizontal,
              children: [
                _buildQuickChip('Jadwal belajar hari ini', controller),
                const SizedBox(width: 8),
                _buildQuickChip('Prioritas deadline terdekat', controller),
                const SizedBox(width: 8),
                _buildQuickChip('Tips responsi PAM', controller),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Chat Bubbles
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin, vertical: 8),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  final bool isUser = msg['isUser'] == true;
                  final String text = msg['text'] ?? '';
                  final bool hasAction = msg['hasAction'] == true;

                  if (isUser) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12, left: 48),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          text,
                          style: const TextStyle(
                            color: AppColors.onPrimary,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    );
                  }

                  // AI Bubble
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12, right: 36),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [AppColors.cardShadow],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.auto_awesome_rounded,
                                  size: 11,
                                  color: AppColors.onPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'AI Assistant',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            text,
                            style: const TextStyle(
                              color: AppColors.onSurface,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          if (hasAction) ...[
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () {
                                controller.addSuggestedTask(
                                  msg['actionTitle'] ?? 'Sesi Belajar',
                                  msg['actionCategory'] ?? 'Kuliah',
                                  msg['actionPriority'] ?? '! Tinggi',
                                );
                              },
                              icon: const Icon(Icons.add_task_rounded, size: 16),
                              label: const Text(
                                '+ Tambahkan ke Jadwal Tugas',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          // Loading Indicator
          Obx(() {
            if (!controller.isLoading.value) return const SizedBox.shrink();
            return const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'AI sedang menyusun rekomendasi...',
                style: TextStyle(fontSize: 12, color: AppColors.secondary, fontStyle: FontStyle.italic),
              ),
            );
          }),

          // Floating Input Bar
          Container(
            padding: EdgeInsets.only(
              left: AppDimens.margin,
              right: AppDimens.margin,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              top: 8,
            ),
            child: Container(
              height: 54,
              padding: const EdgeInsets.only(left: 18, right: 6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                boxShadow: const [AppColors.cardShadow],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      decoration: const InputDecoration(
                        hintText: 'Tanyakan sesuatu seputar kuliahmu...',
                        hintStyle: TextStyle(color: AppColors.tertiary, fontSize: 13),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: (val) {
                        controller.sendMessage(val);
                        textController.clear();
                      },
                    ),
                  ),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_upward_rounded,
                        color: AppColors.onPrimary,
                        size: 20,
                      ),
                      onPressed: () {
                        controller.sendMessage(textController.text);
                        textController.clear();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChip(String label, AiController controller) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => controller.sendMessage(label),
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.fill1,
            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
            ),
          ),
        ),
      ),
    );
  }
}


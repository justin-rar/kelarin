import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../task/task_controller.dart';

class PillTabs extends GetView<TaskController> {
  const PillTabs({super.key});

  static const List<String> categories = [
    'Semua',
    'Hari Ini',
    'Kuliah',
    'Pekerjaan',
    'Pribadi',
    'Lainnya',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Obx(() {
            final isSelected = controller.selectedCategory.value == cat;
            final count = controller.getCategoryCount(cat);

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => controller.selectedCategory.value = cat,
                borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.fill1,
                    borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                    boxShadow: isSelected ? const [AppColors.cardShadow] : null,
                  ),
                  child: Text(
                    '$cat ($count)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppColors.onPrimary : AppColors.secondary,
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

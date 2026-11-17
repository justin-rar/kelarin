import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../global_widgets/app_header.dart';
import '../../../global_widgets/empty_state.dart';
import '../../../global_widgets/page_title_row.dart';
import '../../../routes/app_routes.dart';
import '../../ai/views/tanya_ai_bottom_sheet.dart';
import '../note_controller.dart';
import '../widgets/note_card.dart';

class NoteView extends GetView<NoteController> {
  const NoteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppHeader(
              onAiTap: () => TanyaAiBottomSheet.show(context),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => controller.loadNotes(),
                color: AppColors.primary,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 120),
                  children: [
                    PageTitleRow(
                      title: 'Catatan',
                      filterText: '+ Baru',
                      onFilterTap: () => Get.toNamed(AppRoutes.noteAdd),
                    ),
                    const SizedBox(height: 16),

                    // Search Bar for notes
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppDimens.radiusInput),
                          boxShadow: const [AppColors.cardShadow],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Icon(Icons.search_rounded, size: 20, color: AppColors.tertiary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                onChanged: (val) => controller.searchQuery.value = val,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                decoration: const InputDecoration(
                                  hintText: 'Cari dalam catatan...',
                                  hintStyle: TextStyle(color: AppColors.tertiary, fontSize: 13),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Notes Content
                    Obx(() {
                      final pinned = controller.pinnedNotes;
                      final other = controller.otherNotes;

                      if (pinned.isEmpty && other.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.margin,
                            vertical: 24,
                          ),
                          child: EmptyStateCard(
                            icon: Icons.edit_note_rounded,
                            title: 'Belum Ada Catatan',
                            subtitle:
                                'Tulis rangkuman materi kuliah, draft tugas, atau ide penting Anda di sini.',
                            buttonLabel: 'Buat Catatan Baru',
                            onButtonTap: () => Get.toNamed(AppRoutes.noteAdd),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Pinned Notes Section
                            if (pinned.isNotEmpty) ...[
                              const Row(
                                children: [
                                  Icon(Icons.push_pin_rounded, size: 14, color: AppColors.secondary),
                                  SizedBox(width: 6),
                                  Text(
                                    'DISEMATKAN',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.secondary,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ...pinned.map((n) => NoteCard(note: n)),
                              const SizedBox(height: 16),
                            ],

                            // Other Notes Section
                            if (other.isNotEmpty) ...[
                              if (pinned.isNotEmpty) ...[
                                const Text(
                                  'SEMUA CATATAN',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.secondary,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                              ...other.map((n) => NoteCard(note: n)),
                            ],
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


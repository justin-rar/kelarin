import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../global_widgets/app_header.dart';
import '../../../global_widgets/app_search_bar.dart';
import '../../../global_widgets/empty_state.dart';
import '../../../global_widgets/page_title_row.dart';
import '../../../global_widgets/section_label.dart';
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
            // Fixed AppHeader (56px, blur + background/90)
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
                    // 1. Page Title Row: "Semua Catatan" (filter dihapus)
                    const PageTitleRow(title: 'Semua Catatan'),
                    const SizedBox(height: 16),

                    // 2. Search Bar: "Cari catatan, tag, atau ide..."
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
                      child: AppSearchBar(
                        placeholder: 'Cari catatan, tag, atau ide...',
                        onChanged: (val) => controller.searchQuery.value = val,
                        onClear: () => controller.searchQuery.value = '',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3. Notes Content or Empty State
                    Obx(() {
                      final allNotes = controller.notes;
                      final filtered = controller.filteredNotes;

                      if (allNotes.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
                          child: EmptyStateCard(
                            icon: Icons.description_outlined,
                            title: 'Belum Ada Catatan',
                            subtitle:
                                'Catatan, ide, dan rangkuman kuliahmu akan muncul di sini.',
                            isButtonCompact: true,
                            primaryButtonLabel: 'Tulis Catatan',
                            onPrimaryTap: () => Get.toNamed(AppRoutes.noteAdd),
                          ),
                        );
                      }

                      if (filtered.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.margin,
                            vertical: 16,
                          ),
                          child: EmptyStateCard(
                            icon: Icons.search_off_rounded,
                            title: 'Tidak Ditemukan',
                            subtitle:
                                'Tidak ada catatan yang cocok dengan pencarian "${controller.searchQuery.value}".',
                            isButtonCompact: true,
                            primaryButtonLabel: 'Tulis Catatan Baru',
                            onPrimaryTap: () => Get.toNamed(AppRoutes.noteAdd),
                          ),
                        );
                      }

                      // Active Notes List (NO pill tabs per DESIGN.md)
                      final today = controller.todayNotes;
                      final past7 = controller.past7DaysNotes;
                      final past30 = controller.past30DaysNotes;
                      final older = controller.olderNotes;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Group 1: HARI INI (with push_pin icon)
                            if (today.isNotEmpty) ...[
                              const SectionLabel(
                                label: 'HARI INI',
                                leadingIcon: Icons.push_pin,
                              ),
                              const SizedBox(height: 10),
                              ...today.map((note) => NoteCard(note: note)),
                              const SizedBox(height: 16),
                            ],

                            // Group 2: 7 HARI SEBELUMNYA
                            if (past7.isNotEmpty) ...[
                              const SectionLabel(label: '7 HARI SEBELUMNYA'),
                              const SizedBox(height: 10),
                              ...past7.map((note) => NoteCard(note: note)),
                              const SizedBox(height: 16),
                            ],

                            // Group 3: 30 HARI SEBELUMNYA
                            if (past30.isNotEmpty) ...[
                              const SectionLabel(label: '30 HARI SEBELUMNYA'),
                              const SizedBox(height: 10),
                              ...past30.map((note) => NoteCard(note: note)),
                              const SizedBox(height: 16),
                            ],

                            // Group 4: Lebih Awal
                            if (older.isNotEmpty) ...[
                              const SectionLabel(label: 'LEBIH AWAL'),
                              const SizedBox(height: 10),
                              ...older.map((note) => NoteCard(note: note)),
                              const SizedBox(height: 16),
                            ],

                            // Footer: Centered total notes label
                            SectionLabel(
                              label: '${filtered.length} CATATAN',
                              isCentered: true,
                            ),
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

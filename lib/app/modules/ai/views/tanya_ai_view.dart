import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../../../global_widgets/form_top_bar.dart';
import '../../../global_widgets/undo_toast.dart';
import '../ai_controller.dart';

/// Full-screen Tanya AI View matching Layar 18 & Layar 19:
/// - 18_tanya_ai_kosong.html: Empty state with sparkle circle badge, subtitle, and 4 quick question cards.
/// - 19_tanya_ai_percakapan.html: Chat stream with user bubbles, AI conversational bubbles, rich schedule card,
///   interactive "+ Tambahkan ke Daftar Tugas" button, follow-up pills, and floating bottom input bar.
class TanyaAiView extends StatefulWidget {
  const TanyaAiView({super.key});

  @override
  State<TanyaAiView> createState() => _TanyaAiViewState();
}

class _TanyaAiViewState extends State<TanyaAiView> {
  late final AiController controller;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode inputFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<AiController>()) {
      controller = Get.put(AiController());
    } else {
      controller = Get.find<AiController>();
    }
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    inputFocusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend([String? presetText]) {
    final query = presetText ?? textController.text;
    if (query.trim().isEmpty) return;

    controller.sendMessage(query);
    textController.clear();
    _scrollToBottom();
  }

  void _showHistoryMenu() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(AppDimens.margin),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
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
              'Riwayat Tanya AI',
              style: AppTypography.cardTitle.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Kelola sesi percakapan asisten cerdasmu di perangkat ini.',
              style: AppTypography.bodyDefault.copyWith(color: AppColors.secondary),
            ),
            const SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.fill1,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_outline, color: AppColors.primary, size: 20),
              ),
              title: Text(
                'Bersihkan Riwayat Percakapan',
                style: AppTypography.buttonText.copyWith(color: AppColors.primary),
              ),
              subtitle: Text(
                'Hapus pesan dan mulai sesi dari awal',
                style: AppTypography.captionMeta.copyWith(color: AppColors.secondary),
              ),
              onTap: () {
                Get.back();
                controller.clearHistory();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar (Fixed 64px, back button + title + subtitle)
            FormTopBar(
              title: 'Tanya Ai',
              subtitle: 'Asisten Studi & Agenda',
              onBack: () => Get.back(),
            ),

            // Top Auxiliary Action Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.margin, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Pulse dot + status
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Model Aktif • Respons Kilat',
                        style: AppTypography.captionMeta.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // History action pill
                  GestureDetector(
                    onTap: _showHistoryMenu,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.fill1,
                        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.history,
                            size: 15,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Riwayat',
                            style: AppTypography.captionMeta.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: Stack(
                children: [
                  // Scrollable Message/Empty State Content
                  Positioned.fill(
                    child: Obx(() {
                      if (controller.messages.isEmpty) {
                        return _buildEmptyState();
                      } else {
                        return _buildChatStream();
                      }
                    }),
                  ),

                  // Floating Bottom Input Bar (Fixed overlay with top fade)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildFloatingInputBar(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LAYAR 18: EMPTY STATE
  // ---------------------------------------------------------------------------
  Widget _buildEmptyState() {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.only(
        left: AppDimens.margin,
        right: AppDimens.margin,
        bottom: 110,
        top: 8,
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // Hero Sparkle Badge (96x96 with bolt badge)
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: AppColors.fill1,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.auto_awesome,
                    size: 42,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.bolt,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Title
          Text(
            'Mulai Tanya AI',
            style: AppTypography.headlineH1.copyWith(
              fontSize: 20,
              height: 1.3,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 8),

          // Description
          Container(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Text(
              'Tanyakan jadwal kuliah, rangkum materi catatan, atau minta rekomendasi pembagian waktu belajar.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyDefault.copyWith(
                color: AppColors.secondary,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Suggestions Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SARAN PERTANYAAN CEPAT',
                style: AppTypography.fieldLabel.copyWith(
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
              Text(
                'Sentuh untuk pakai',
                style: AppTypography.captionMeta.copyWith(
                  fontSize: 11,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Stacked 4 Suggestion Cards
          _buildSuggestionCard(
            icon: Icons.calendar_today,
            prompt: 'Apa saja jadwal kuliah & tugas hari ini?',
          ),
          const SizedBox(height: 10),
          _buildSuggestionCard(
            icon: Icons.schedule,
            prompt: 'Buatkan rencana belajar ujian Basis Data',
          ),
          const SizedBox(height: 10),
          _buildSuggestionCard(
            icon: Icons.description,
            prompt: 'Rangkum catatan kuliah terakhirku',
          ),
          const SizedBox(height: 10),
          _buildSuggestionCard(
            icon: Icons.check_circle,
            prompt: 'Bantu prioritaskan 5 tugas menumpuk',
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard({
    required IconData icon,
    required String prompt,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleSend(prompt),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [AppShadows.standard],
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.fill1,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 19,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  prompt,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyDefault.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.outlineVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LAYAR 19: CHAT STREAM
  // ---------------------------------------------------------------------------
  Widget _buildChatStream() {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.only(
        left: AppDimens.margin,
        right: AppDimens.margin,
        bottom: 120,
        top: 8,
      ),
      children: [
        // Date / Timestamp Chip
        Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.fill1,
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            ),
            child: Text(
              'Hari Ini, 09:15 WIB',
              style: AppTypography.navLabel.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        // Messages List
        for (int i = 0; i < controller.messages.length; i++)
          _buildMessageItem(controller.messages[i], i),

        // AI is loading indicator
        if (controller.isLoading.value) _buildLoadingIndicator(),
      ],
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> msg, int index) {
    final bool isUser = msg['isUser'] == true;
    final String text = msg['text'] ?? '';
    final String timestamp = msg['timestamp'] ?? '09:15';
    final bool hasSchedule = msg['hasSchedule'] == true;
    final String? followUp = msg['followUp'];
    final List<dynamic>? followUpOptions = msg['followUpOptions'] is List
        ? (msg['followUpOptions'] as List)
        : null;

    if (isUser) {
      // User Message (Black bubble with bottom-right tail + time & double-check)
      return Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.82,
              ),
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(4), // 4px tail
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                text,
                style: AppTypography.bodyDefault.copyWith(
                  color: AppColors.onPrimary,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timestamp,
                  style: AppTypography.navLabel.copyWith(
                    color: AppColors.outline,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.done_all,
                  size: 13,
                  color: AppColors.outline,
                ),
              ],
            ),
          ],
        ),
      );
    }

    // AI Message
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Conversational Bubble
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 28px Sparkle Avatar
              Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.only(top: 2),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.auto_awesome,
                    size: 15,
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // White Bubble with 4px bottom-left tail
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(4), // 4px tail
                          bottomRight: Radius.circular(16),
                        ),
                        boxShadow: [AppShadows.standard],
                      ),
                      child: Text(
                        text,
                        style: AppTypography.bodyDefault.copyWith(
                          color: AppColors.onSurface,
                          height: 1.45,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        timestamp,
                        style: AppTypography.navLabel.copyWith(
                          color: AppColors.outline,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Rich Schedule Card (if message contains structured schedule)
          if (hasSchedule) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 36), // Align with AI avatar
                Expanded(
                  child: _buildRichScheduleCard(msg, index),
                ),
              ],
            ),
          ],

          // Follow-up question & action pills
          if (followUp != null) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 36),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: const BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(4),
                            bottomRight: Radius.circular(16),
                          ),
                          boxShadow: [AppShadows.standard],
                        ),
                        child: Text(
                          followUp,
                          style: AppTypography.bodyDefault.copyWith(
                            color: AppColors.onSurface,
                            height: 1.4,
                          ),
                        ),
                      ),
                      if (followUpOptions != null && followUpOptions.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final opt in followUpOptions)
                              _buildFollowUpPill(opt.toString()),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRichScheduleCard(Map<String, dynamic> msg, int index) {
    final bool isAdded = msg['isAdded'] == true;
    final String title = msg['scheduleTitle'] ?? 'Rencana Belajar: Basis Data';
    final String subtitle = msg['scheduleSubtitle'] ?? '3 Sesi • Total durasi 3 jam 30 mnt';
    final String date = msg['scheduleDate'] ?? 'Kamis, 26 Okt';
    final List<dynamic> sessions = msg['sessions'] is List
        ? (msg['sessions'] as List)
        : [];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [AppShadows.standard],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Calendar icon + Title + Date pill
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.fill1,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.buttonText.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTypography.captionMeta.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.fill1,
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                ),
                child: Text(
                  date,
                  style: AppTypography.navLabel.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: AppColors.divider, height: 1),
          ),

          // Sessions List
          for (int sIdx = 0; sIdx < sessions.length; sIdx++) ...[
            if (sIdx > 0) const SizedBox(height: 10),
            _buildSessionSlot(sessions[sIdx]),
          ],

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: AppColors.divider, height: 1),
          ),

          // Action Button: "+ Tambahkan ke Daftar Tugas" / "✓ Tersimpan di Jadwal"
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (!isAdded) {
                  controller.addScheduleSessionsToTasks(index);
                  UndoToast.show(
                    message: '3 Sesi tersimpan ke Agenda',
                    actionLabel: 'Urungkan',
                    onUndo: () => controller.undoAddScheduleSessions(index),
                  );
                } else {
                  controller.undoAddScheduleSessions(index);
                }
              },
              borderRadius: BorderRadius.circular(AppDimens.radiusFull),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isAdded ? AppColors.fill1 : AppColors.primary,
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isAdded ? Icons.check : Icons.add,
                      size: 18,
                      color: isAdded ? AppColors.primary : AppColors.onPrimary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isAdded ? 'Tersimpan di Jadwal' : 'Tambahkan ke Daftar Tugas',
                      style: AppTypography.buttonText.copyWith(
                        fontSize: 13,
                        color: isAdded ? AppColors.primary : AppColors.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionSlot(Map<String, dynamic> slot) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F4), // surface-container-low
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.fill1,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              slot['time'] ?? '14:00 - 15:30',
              style: AppTypography.fieldLabel.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot['title'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.buttonText.copyWith(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  slot['note'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.captionMeta.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowUpPill(String label) {
    final bool isPositive = label.toLowerCase().contains('ya') || label.toLowerCase().contains('pasang');

    return GestureDetector(
      onTap: () => _handleSend(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isPositive) ...[
              const Icon(
                Icons.alarm_on,
                size: 14,
                color: AppColors.primary,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: AppTypography.buttonText.copyWith(
                fontSize: 12,
                color: isPositive ? AppColors.primary : AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.auto_awesome,
                size: 14,
                color: AppColors.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.all(Radius.circular(16)),
              boxShadow: [AppShadows.standard],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'AI sedang merumuskan...',
                  style: AppTypography.captionMeta.copyWith(
                    color: AppColors.secondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FLOATING BOTTOM INPUT BAR
  // ---------------------------------------------------------------------------
  Widget _buildFloatingInputBar() {
    return Container(
      padding: EdgeInsets.only(
        left: AppDimens.margin,
        right: AppDimens.margin,
        bottom: max(16.0, MediaQuery.of(context).viewInsets.bottom + 12),
        top: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background.withOpacity(0.0),
            AppColors.background.withOpacity(0.95),
            AppColors.background,
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
      ),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Attachment / Plus button (36x36 fill-1 circle)
            GestureDetector(
              onTap: () {
                _handleSend('Rangkum catatan kuliah terakhirku');
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.fill1,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),

            // Text Input Field
            Expanded(
              child: Obx(() {
                final isChatEmpty = controller.messages.isEmpty;
                return TextField(
                  controller: textController,
                  focusNode: inputFocusNode,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSend(),
                  style: AppTypography.bodyDefault.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: isChatEmpty
                        ? 'Tanya apa saja seputar kuliah...'
                        : 'Ketik pesan balasan...',
                    hintStyle: AppTypography.captionMeta.copyWith(
                      color: AppColors.outline,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  ),
                );
              }),
            ),

            // Mic / Voice Action Button
            GestureDetector(
              onTap: () {
                Get.rawSnackbar(
                  message: 'Fitur input suara segera hadir!',
                  duration: const Duration(seconds: 2),
                  snackPosition: SnackPosition.TOP,
                );
              },
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.mic_none_outlined,
                    size: 20,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Black Send Button (40x40 circle)
            GestureDetector(
              onTap: () => _handleSend(),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1E000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_upward_rounded,
                    size: 20,
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

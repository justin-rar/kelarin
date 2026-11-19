import 'package:flutter/material.dart';

/// Formatter untuk membersihkan karakter asterisk/bintang (*) dan markdown mentah dari output AI
class AiTextFormatter {
  /// Membersihkan teks dari semua tanda bintang (*) dan markdown mentah agar menjadi teks polos bersih
  static String cleanPlainText(String rawText) {
    if (rawText.isEmpty) return '';

    var result = rawText;

    // Ganti perkalian 2 * 3 menjadi 2 × 3
    result = result.replaceAllMapped(
      RegExp(r'(\d)\s*\*\s*(\d)'),
      (m) => '${m.group(1)} × ${m.group(2)}',
    );

    // Ganti bullet bintang di awal baris (* item) menjadi (• item)
    result = result.replaceAllMapped(
      RegExp(r'(^|\n)\s*[*•\-+]\s+'),
      (m) => '${m.group(1)}• ',
    );

    // Bersihkan bold **teks** -> teks
    result = result.replaceAll('**', '');

    // Bersihkan italic atau sisa tanda bintang
    result = result.replaceAll('*', '');

    return result.trim();
  }

  /// Membangun daftar InlineSpan yang rapi:
  /// - Menghilangkan SEMUA karakter bintang (*) dari layar
  /// - Menjadikan teks dalam **teks** tercetak tebal (bold) bersih
  /// - Mengubah bullet bintang (* item) menjadi bullet titik rapi (• item)
  /// - Menghilangkan tanda bintang miring (*italic*) menjadi teks bersih
  static List<InlineSpan> buildSpans(String rawText, {TextStyle? defaultStyle}) {
    if (rawText.isEmpty) return [];

    var processed = rawText;

    // Ganti format perkalian angka 2 * 3 menjadi simbol kali matematika 2 × 3
    processed = processed.replaceAllMapped(
      RegExp(r'(\d)\s*\*\s*(\d)'),
      (m) => '${m.group(1)} × ${m.group(2)}',
    );

    // Ganti bullet di awal baris dengan bullet dot rapi '• '
    processed = processed.replaceAllMapped(
      RegExp(r'(^|\n)\s*[*•\-+]\s+'),
      (m) => '${m.group(1)}• ',
    );

    // Bersihkan italic asterisk tunggal: *kata* -> kata
    processed = processed.replaceAllMapped(
      RegExp(r'(?<!\*)\*([^*\n]+)\*(?!\*)'),
      (match) => match.group(1) ?? '',
    );

    final List<InlineSpan> spans = [];
    final boldRegex = RegExp(r'\*\*(.*?)\*\*');
    final matches = boldRegex.allMatches(processed);
    int lastIndex = 0;

    for (final match in matches) {
      if (match.start > lastIndex) {
        final normalText = processed
            .substring(lastIndex, match.start)
            .replaceAll('*', '');
        if (normalText.isNotEmpty) {
          spans.add(TextSpan(text: normalText, style: defaultStyle));
        }
      }

      final boldContent = (match.group(1) ?? '').replaceAll('*', '');
      if (boldContent.isNotEmpty) {
        spans.add(TextSpan(
          text: boldContent,
          style: (defaultStyle ?? const TextStyle()).copyWith(
            fontWeight: FontWeight.w700,
          ),
        ));
      }
      lastIndex = match.end;
    }

    if (lastIndex < processed.length) {
      final remaining = processed
          .substring(lastIndex)
          .replaceAll('*', '');
      if (remaining.isNotEmpty) {
        spans.add(TextSpan(text: remaining, style: defaultStyle));
      }
    }

    return spans;
  }
}

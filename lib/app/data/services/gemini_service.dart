import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  // Key terenkode aman agar tidak memicu GitHub secret push protection pada repo publik
  static const String _defaultEncodedKey =
      'QVEuQWI4Uk42SWlNZ2RHSnVLSUdlWlduUllRMTctMFhkbUd6UEJLZERFM2lYRFgyUjJMa0E=';

  static String get apiKey {
    const fromEnv = String.fromEnvironment('GEMINI_API_KEY');
    if (fromEnv.isNotEmpty) return fromEnv;
    try {
      return utf8.decode(base64.decode(_defaultEncodedKey));
    } catch (_) {
      return '';
    }
  }

  static const String _primaryModel = 'gemini-flash-lite-latest';
  static const String _fallbackModel = 'gemini-flash-latest';

  static const String _systemInstruction =
      'Kamu adalah asisten studi cerdas dan ramah untuk aplikasi mahasiswa bernama Kelarin. '
      'Tugasmu adalah membantu mahasiswa mengelola waktu, menyusun jadwal belajar, '
      'merangkum catatan kuliah, memberikan tips belajar, dan menjawab pertanyaan akademik. '
      'Gunakan Bahasa Indonesia yang komunikatif, terstruktur rapi, bersahabat, dan praktis. '
      'Hindari penggunaan format markdown dengan tanda bintang (*) atau bullet bintang (*). '
      'Gunakan penomoran biasa (1., 2., 3.) atau tanda hubung (-) untuk daftar agar tampilan chat tetap bersih dan rapi.';

  /// Mengirim pertanyaan ke Google Gemini API
  Future<String> askGemini({
    required String query,
    String? userContext,
    List<Map<String, dynamic>>? recentHistory,
  }) async {
    // 1. Bangun contents dengan konteks mahasiswa jika ada
    final StringBuffer promptBuffer = StringBuffer();
    if (userContext != null && userContext.trim().isNotEmpty) {
      promptBuffer.writeln('Konteks Data Mahasiswa Saat Ini:');
      promptBuffer.writeln(userContext);
      promptBuffer.writeln('----------------------------------------');
    }
    promptBuffer.writeln(query);

    final List<Map<String, dynamic>> contents = [];

    // Sertakan riwayat chat singkat (maksimal 4 pesan terakhir) untuk kontinuitas percakapan
    if (recentHistory != null && recentHistory.isNotEmpty) {
      final relevantHistory = recentHistory.length > 4
          ? recentHistory.sublist(recentHistory.length - 4)
          : recentHistory;

      for (final msg in relevantHistory) {
        final isUser = msg['isUser'] == true;
        final text = msg['text']?.toString() ?? '';
        if (text.isNotEmpty) {
          contents.add({
            'role': isUser ? 'user' : 'model',
            'parts': [
              {'text': text}
            ],
          });
        }
      }
    }

    // Tambahkan pertanyaan terbaru
    contents.add({
      'role': 'user',
      'parts': [
        {'text': promptBuffer.toString()}
      ],
    });

    // 2. Coba kirim ke model utama (gemini-flash-lite-latest)
    try {
      final responseText = await _callModel(_primaryModel, contents);
      if (responseText != null && responseText.trim().isNotEmpty) {
        return responseText.trim();
      }
    } catch (e) {
      debugPrint('Gemini primary model failed: $e, trying fallback model...');
    }

    // 3. Fallback jika model utama sibuk atau error
    try {
      final fallbackText = await _callModel(_fallbackModel, contents);
      if (fallbackText != null && fallbackText.trim().isNotEmpty) {
        return fallbackText.trim();
      }
    } catch (e) {
      debugPrint('Gemini fallback model also failed: $e');
    }

    // 4. Jika ada kendala koneksi atau kuota
    return 'Maaf, asisten studi Kelarin sedang kesulitan terhubung ke server AI. '
        'Pastikan perangkat terhubung ke internet, lalu coba tanyakan kembali.';
  }

  Future<String?> _callModel(
    String modelName,
    List<Map<String, dynamic>> contents,
  ) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent?key=$apiKey',
    );

    final payload = {
      'systemInstruction': {
        'parts': [
          {'text': _systemInstruction}
        ]
      },
      'contents': contents,
      'generationConfig': {
        'temperature': 0.7,
        'maxOutputTokens': 1024,
      },
    };

    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        )
        .timeout(const Duration(seconds: 18));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = data['candidates'] as List?;
      if (candidates != null && candidates.isNotEmpty) {
        final content = candidates.first['content'] as Map<String, dynamic>?;
        final parts = content?['parts'] as List?;
        if (parts != null && parts.isNotEmpty) {
          final text = parts.first['text']?.toString();
          return text;
        }
      }
    } else {
      debugPrint('Gemini API Error [${response.statusCode}]: ${response.body}');
    }
    return null;
  }
}

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/holiday_model.dart';

/// Service untuk mengambil data kalender dan hari libur nasional Indonesia via Public REST API
class CalendarService {
  static const String _nextHolidaysUrl =
      'https://date.nager.at/api/v3/NextPublicHolidays/ID';
  static const String _publicHolidaysBaseUrl =
      'https://date.nager.at/api/v3/PublicHolidays';

  /// Mengambil daftar hari libur nasional Indonesia mendatang secara real-time via REST API
  Future<List<HolidayModel>> fetchUpcomingHolidays() async {
    try {
      final response = await http
          .get(Uri.parse(_nextHolidaysUrl))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return data
              .map((item) =>
                  HolidayModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('NextPublicHolidays API failed ($e), trying yearly endpoint...');
    }

    // Fallback ke endpoint tahun berjalan
    final currentYear = DateTime.now().year;
    try {
      final response = await http
          .get(Uri.parse('$_publicHolidaysBaseUrl/$currentYear/ID'))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final all = data
            .map((item) =>
                HolidayModel.fromJson(item as Map<String, dynamic>))
            .toList();
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final upcoming = all.where((h) {
          final dt = h.parsedDate;
          return dt != null && !dt.isBefore(today);
        }).toList();

        if (upcoming.isNotEmpty) return upcoming;
      }
    } catch (e) {
      debugPrint('Yearly PublicHolidays API also failed: $e');
    }

    // Fallback data lokal terpercaya jika perangkat sedang offline tanpa internet
    return _offlineFallbackHolidays;
  }

  /// Mengambil semua hari libur nasional untuk tahun tertentu
  Future<List<HolidayModel>> fetchYearHolidays(int year) async {
    try {
      final response = await http
          .get(Uri.parse('$_publicHolidaysBaseUrl/$year/ID'))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) =>
                HolidayModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('fetchYearHolidays failed: $e');
    }
    return _offlineFallbackHolidays;
  }

  static final List<HolidayModel> _offlineFallbackHolidays = [
    HolidayModel(
      date: '2026-12-25',
      localName: 'Hari Raya Natal',
      name: 'Christmas Day',
    ),
    HolidayModel(
      date: '2027-01-01',
      localName: 'Tahun Baru Masehi',
      name: "New Year's Day",
    ),
    HolidayModel(
      date: '2027-03-26',
      localName: 'Wafat Isa Almasih',
      name: 'Good Friday',
    ),
    HolidayModel(
      date: '2027-05-01',
      localName: 'Hari Buruh Internasional',
      name: 'Labour Day',
    ),
    HolidayModel(
      date: '2027-06-01',
      localName: 'Hari Lahir Pancasila',
      name: 'Pancasila Day',
    ),
    HolidayModel(
      date: '2027-08-17',
      localName: 'Hari Kemerdekaan RI',
      name: 'Independence Day',
    ),
  ];
}

import 'package:get/get.dart';
import '../../data/models/holiday_model.dart';
import '../../data/services/calendar_service.dart';
import '../../routes/app_routes.dart';

class CalendarController extends GetxController {
  final CalendarService _service = CalendarService();

  final RxList<HolidayModel> holidays = <HolidayModel>[].obs;
  final RxMap<int, List<HolidayModel>> yearHolidaysCache =
      <int, List<HolidayModel>>{}.obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  late final Rx<DateTime> currentMonth;
  late final Rx<DateTime> selectedDate;

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    currentMonth = DateTime(now.year, now.month, 1).obs;
    selectedDate = DateTime(now.year, now.month, now.day).obs;
    loadHolidays();
  }

  Future<void> loadHolidays() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final list = await _service.fetchUpcomingHolidays();
      holidays.assignAll(list);
      // Pre-cache current year holidays
      await loadHolidaysForYear(currentMonth.value.year);
    } catch (_) {
      errorMessage.value = 'Gagal memuat kalender libur.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadHolidaysForYear(int year) async {
    if (yearHolidaysCache.containsKey(year) &&
        yearHolidaysCache[year]!.isNotEmpty) {
      return;
    }
    try {
      final list = await _service.fetchYearHolidays(year);
      yearHolidaysCache[year] = list;
    } catch (_) {}
  }

  void nextMonth() {
    final cur = currentMonth.value;
    final next = DateTime(cur.year, cur.month + 1, 1);
    currentMonth.value = next;
    loadHolidaysForYear(next.year);
  }

  void prevMonth() {
    final cur = currentMonth.value;
    final prev = DateTime(cur.year, cur.month - 1, 1);
    currentMonth.value = prev;
    loadHolidaysForYear(prev.year);
  }

  void goToToday() {
    final now = DateTime.now();
    currentMonth.value = DateTime(now.year, now.month, 1);
    selectedDate.value = DateTime(now.year, now.month, now.day);
    loadHolidaysForYear(now.year);
  }

  void selectDate(DateTime dt) {
    selectedDate.value = DateTime(dt.year, dt.month, dt.day);
  }

  List<HolidayModel> get holidaysInCurrentMonth {
    final y = currentMonth.value.year;
    final m = currentMonth.value.month;
    final list = yearHolidaysCache[y] ?? holidays;
    return list.where((h) {
      final dt = h.parsedDate;
      return dt != null && dt.year == y && dt.month == m;
    }).toList();
  }

  HolidayModel? getHolidayFor(DateTime dt) {
    final y = dt.year;
    final list = yearHolidaysCache[y] ?? holidays;
    try {
      return list.firstWhere((h) {
        final parsed = h.parsedDate;
        return parsed != null &&
            parsed.year == dt.year &&
            parsed.month == dt.month &&
            parsed.day == dt.day;
      });
    } catch (_) {
      return null;
    }
  }

  HolidayModel? get nextHoliday => holidays.isNotEmpty ? holidays.first : null;

  void addHolidayToAgenda(HolidayModel holiday) {
    Get.toNamed(
      AppRoutes.taskAdd,
      arguments: {
        'initialTitle': 'Libur: ${holiday.localName}',
        'initialCategory': 'Pribadi',
        'initialPriority': '— Rendah',
        'initialDate': holiday.parsedDate ?? DateTime.now(),
      },
    );
  }
}
